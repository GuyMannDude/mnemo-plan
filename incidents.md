# Incidents

The runbook. Every bug that cost real debugging time, documented so it never costs time again.

**New incidents go at the top.** Never delete old ones — they're still valuable context.

---

## OpenClaw 4.20 upgrade — four cascading EACCES / cache snags
**Date:** 2026-04-22
**Symptom:** After `sudo npm install -g openclaw@2026.4.20` + gateway restart on IGOR, four cascading failures:
 1. Gateway crash-looped on first 2 restart attempts with `Cannot find module runtime-prepare.runtime-<hash>.js` (hash mismatch).
 2. Log flooded with `EACCES: permission denied, open '/tmp/jiti/*.cjs'` warnings → Telegram + Discord channels failed to hot-load.
 3. After jiti fix, 4 plugins (acpx, browser, discord, telegram) failed to initialize: `EACCES: permission denied, mkdir '/usr/lib/node_modules/openclaw/dist/extensions/<plugin>/node_modules'`.
 4. Orthogonal: `~/.openclaw/openclaw.json` had stale sparks-bus MCP path (`~/github/sparks-bus/server.js`, file moved to `~/github/sparks-bus-mcp/server.js`).
**Cause:**
 - (1) Transient — `jiti` bundler cache from the previous version referenced a bundle hash that no longer existed. Self-healed on retry 3 once the new bundle was loaded and cached.
 - (2 & 3) Root ownership: `sudo npm install -g` writes to `/usr/lib/node_modules/openclaw/` as root, but the gateway runs as user `guy`. OpenClaw 4.20 does two runtime-write operations that fail when owned by root: jiti caches TypeScript entries to `/tmp/jiti/` (pre-existing root-owned entries block overwrite), and each plugin installs its own `node_modules` on first load inside `dist/extensions/<plugin>/`.
 - (4) Independent: the sparks-bus MCP server repo was renamed before Rocky was restarted, same stale-path pattern as the April 22 Claude Desktop fix.
**Fix:**
 ```
 sudo chown -R guy:guy /tmp/jiti/
 sudo chown -R guy:guy /usr/lib/node_modules/openclaw/dist/extensions/
 ```
 Plus: edit openclaw.json sparks-bus entry to `~/github/sparks-bus-mcp/server.js`. Restart gateway.
**Prevention:**
 - **After every `sudo npm install -g openclaw@X`, follow with these two chown commands before restarting the gateway.** They're cheap, idempotent, and avoid every re-run of this incident.
 - Whenever an MCP server repo is renamed (sparks-bus, mnemo-cortex, etc), grep every agent's config for the old path in the same commit.
 - Gateway crash-looping with self-heal is a known pattern — if you see up to 2 crashes then a successful start, the jiti cache just had to repopulate. Only dig deeper if it fails more than 3 times.
 - The systemd `.service` file hard-codes a version string in its Description field — it won't update on upgrade. Ignore the cosmetic mismatch; trust `openclaw --version` and `ps -o etime` for the real state.

## Claude Desktop MCP config drift — `opie_startup` missing, sparks-bus disconnected
**Date:** 2026-04-22
**Symptom:** Opie could not find `opie_startup` at session start (the tool his system prompt tells him to always call). Separately, Claude Desktop showed a "Sparks-bus disconnected" MCP error on launch.
**Cause:** Claude Desktop (pid 3048486) had been up continuously since April 18. MCP subprocesses are spawned ONCE at app launch and never re-read the config file, so two server-repo reorganizations that happened mid-flight were invisible:
 - `mnemo-cortex` MCP fork: an opie-brain-flavored server lives at `~/github/mnemo-cortex-mcp/server.js` (exposes `opie_startup`, `list_brain_files`, `read_brain_file`, `write_brain_file`, `session_end`, `wiki_*`, plus `mnemo_*`). A consolidated OpenClaw-facing fork lives at `~/github/mnemo-cortex/integrations/openclaw-mcp/server.js` (only `mnemo_*` + `passport_*`). Claude Desktop's config was pointing at the consolidated fork — wrong for Opie.
 - `sparks-bus` MCP: the server moved from `~/github/sparks-bus/server.js` (now the Python watcher + docs repo only) to `~/github/sparks-bus-mcp/server.js`. Config was never updated. Process died on spawn because the old path no longer exists.
**Fix:** Edited `~/.config/Claude/claude_desktop_config.json`: pointed `mnemo-cortex` at `mnemo-cortex-mcp/server.js`, pointed `sparks-bus` at `sparks-bus-mcp/server.js`. Full-quit + relaunch Desktop (window close is NOT enough — the main Electron pid has to die). All three MCP servers came back healthy. Backups: `claude_desktop_config.json.bak-pre-opie-fix-2026-04-22`.
**Prevention:**
 - MCP subprocesses are re-read only on app launch. If you edit the config, fully quit Desktop (`kill -TERM <pid>`, not window close).
 - When either MCP server repo reorganizes, audit the Claude Desktop config the same commit.
 - Desktop should never be allowed to run for weeks without a restart — config drift accumulates silently.
 - The persistent `cowork-vm-service.js` subprocess is safe to leave running; it's not the main app and doesn't hold MCP state.

## agentb-bridge can't restart — FastMCP rejects `token_verifier` without `auth_settings`
**Date:** 2026-04-22
**Symptom:** After killing artforge's uvicorn agentb-bridge (pid 2732068, running since April 18) to pick up a policy change, it refused to restart. Traceback: `ValueError: Cannot specify auth_server_provider or token_verifier without auth settings` in mcp 1.27.0's `FastMCP.__init__`.
**Cause:** `/home/guy/agentb-bridge/agentb_mcp.py` unconditionally constructs `verifier = MnemoTokenVerifier(...)` and passes `token_verifier=verifier` to `FastMCP(...)`, but `_auth_settings` is only set when `MNEMO_OAUTH_ISSUER` AND `MNEMO_OAUTH_AUDIENCE` env vars are present. Those vars aren't in the service file, aren't in `~/.bashrc`, aren't anywhere findable — the old April-18 process had them somehow (maybe from a shell session that's long gone) but a clean restart hits the library check. mcp library ≥ ~1.25 rejects the `verifier-without-auth` combination.
**Fix:** Surgical one-line patch on artforge: `token_verifier=verifier if _auth_settings else None,` at `agentb_mcp.py:232`. Backup at `agentb_mcp.py.bak-pre-oauth-conditional-2026-04-22`. Process restarted cleanly (pid 415966), /passport/context returns expected data.
**Prevention:**
 - Before killing a long-running service, capture its env: `cat /proc/<pid>/environ | tr '\0' '\n' > /tmp/<svc>.env.snapshot`. Would have saved this debug.
 - agentb-bridge has no systemd unit, no git, no dependency pinning. That's tech debt. A proper systemd user unit + pinned requirements.txt would make this service restart-safe. Currently the only protection is "don't kill it."
 - If OAuth is deliberately optional (looks like it is — code branches on env presence), the `verifier` object should also be conditional — don't build what you won't pass.

---

## Opie session watcher dead for 13 days — stale context, bad directives
**Date:** 2026-04-07
**Symptom:** Opie issued CC directives with 3 factual errors: claimed `/dreaming` was a CLI command (it's a plugin config), said ComfyUI was on THE VAULT (it's on IGOR-2), said Mem0 bridge "still works" (never deployed to production). CC caught all three during verification.
**Cause:** Claude Desktop v2.1.87 moved session storage from disk JSONL (`~/.config/Claude/local-agent-mode-sessions/`) to internal IndexedDB (cowork VM architecture). The `mnemo-watcher-opie` systemd service was polling a dead JSONL file from March 25 — 13 days with zero new data captured. Opie's only memory came from manual `mnemo_save` calls, last one April 4.
**Fix:**
  1. Stopped and disabled `mnemo-watcher-opie` service
  2. Patched MCP server to v2.1.0: tool call tracking, save reminder after 20 calls, `session_end` tool
  3. Updated `opie_startup` identity text: warns Opie watcher is dead, saves are mandatory
  4. Pulled Claude Desktop integration from public GitHub (mnemo-cortex v2.3.0)
  5. Updated Opie brain lane with current ground truth
  6. Updated mnemo-cortex-mcp standalone repo README (archived, can't push)
**Prevention:** Desktop session storage format is not under our control. MCP-only memory (nudge system) is the reliable path. The file watcher approach only works for clients that write JSONL (CC, OpenClaw). Do not re-enable the Opie watcher unless Desktop brings back disk-based session files.

## Zombie mnemo-cortex v2 daemons on IGOR — probable source of mystery Gemini Flash calls
**Date:** 2026-03-24
**Symptom:** Two mnemo-cortex v2 processes running on IGOR since March 17 — `mnemo-watcher-rocky.sh` (PID 488150) and `mnemo-refresher-rocky.sh` (PID 488151). These are the old v2 watcher/refresher daemons that should only run on THE VAULT. Probable source of unexplained Gemini 2.5 Flash calls on OpenRouter — the v2 compaction code calls OpenRouter for LLM summarization.
**Cause:** Systemd user services (`mnemo-watcher.service`, `mnemo-refresh.service`) in `~/.config/systemd/user/` were enabled and set to `WantedBy=default.target` with `Restart=on-failure`. They survived across reboots. Same zombie pattern as the March 16 incident.
**Fix:**
  1. Killed both processes
  2. `systemctl --user stop` + `disable` both services
  3. `systemctl --user daemon-reload`
  4. Updated `~/scripts/mnemo-health.sh` — removed watcher/refresher checks (they're supposed to be dead), now only checks THE VAULT server health
  5. Bumped heartbeat timeout 30s→60s, reset error counter (6 consecutive timeouts)
**Prevention:** Standing rule reinforced: no mnemo-cortex process should ever run on IGOR. The systemd services are disabled but still on disk — if anyone re-enables them, the zombie pattern repeats. Consider deleting the service files entirely.

## agentb_bridge.py patched for multi-agent memory isolation
**Date:** 2026-03-24
**Symptom:** All agents (Rocky, CC) writing to the same flat `~/.agentb/memory/` directory. No tenant isolation. CC's test writeback mixed in with Rocky's memories.
**Cause:** The agentb_bridge.py on THE VAULT was single-tenant by design — `agent_id` was accepted in requests but ignored for storage paths. L3 scan only searched the root memory dir.
**Fix:** Three patches to `~/agentb-bridge/agentb_bridge.py` on THE VAULT:
  1. Added `agent_id: Optional[str]` field to `WritebackRequest` Pydantic model
  2. Writeback now saves to `~/.agentb/memory/{agent_id}/` subdirectory (defaults to `default/`)
  3. L3 scan and idle precache now glob `memory/*.json` AND `memory/*/*.json` for cross-agent reads
  - Migrated existing files: Rocky's 3 files → `memory/rocky/`, CC's 1 file → `memory/cc/`
  - Restarted via `sudo systemctl restart agentb-bridge`
  - Backup at `~/agentb-bridge/agentb_bridge.py.bak`
**Prevention:** Any new agent registering with mnemo-cortex should use a unique `agent_id`. The bridge now auto-creates subdirectories.

## Heartbeat cron burning Gemini Pro credits on empty HEARTBEAT.md
**Date:** 2026-03-23
**Symptom:** Rocky's "System Health Heartbeat" cron job running every hour, costing ~$2.40/day in OpenRouter credits (Gemini 3.1 Pro).
**Cause:** The cron job (`~/.openclaw/cron/jobs.json`, id `0bc68de3`) fires unconditionally every 3600s. It sends a payload to the `main` agent which uses Rocky's primary model (Gemini Pro). HEARTBEAT.md is comments-only and says to skip when empty, but the cron scheduler doesn't check file contents before firing — it always spins up a full model session.
**Fix:** Disabled the cron job (`"enabled": false` in jobs.json). HEARTBEAT.md has no active tasks, so the job was doing nothing useful.
**Re-enable when:** (a) there are actual heartbeat tasks in HEARTBEAT.md, AND (b) OpenClaw supports per-session model override to force heartbeat to the free Nemotron tier.
**Prevention:** Never enable scheduled cron jobs on paid models without explicit model overrides. Heartbeat/polling jobs must use free-tier models.

## NemoClaw clean reinstall — gateway + identity + network all fixed
**Date:** 2026-03-23
**Symptom:** Multiple cascading issues: gateway "pairing required" error, pod→host network isolation, relay chain proxy hacks (`sparky-proxy.mjs`), device identity mismatch between sandbox/root users.
**Root cause:** NemoClaw was not installed via the official installer (`curl -fsSL https://www.nvidia.com/nemoclaw.sh | bash`). It was manually installed as an npm global package from an unknown source. This left the gateway, identity, port forwarding, and networking in a broken/partial state that required hand-patched workarounds.
**Fix:** Full clean reinstall:
  1. Destroyed old sandbox (`nemoclaw sparks-nemo destroy`)
  2. Killed all zombie processes (12+ stale nemoclaw/openshell/proxy PIDs from Mar 19-22)
  3. Removed old install (`rm -rf ~/.npm-global/lib/node_modules/nemoclaw ~/.nemoclaw/`)
  4. Removed relay chain hack (`/tmp/sparky-proxy.mjs`)
  5. Ran official installer: `curl -fsSL https://www.nvidia.com/nemoclaw.sh | bash` with env vars:
     - `NEMOCLAW_NON_INTERACTIVE=1`, `NEMOCLAW_SANDBOX_NAME=sparks-nemo`
     - `NEMOCLAW_PROVIDER=cloud`, `NEMOCLAW_MODEL=nvidia/nemotron-3-super-120b-a12b`
  6. Installer handled everything: gateway, sandbox creation, identity, port forward, inference config, policies
**Result:** All checks pass:
  - `nemoclaw sparks-nemo status` → Ready (Landlock + seccomp + netns)
  - `openshell forward list` → running (PID managed by openshell, 127.0.0.1:18789)
  - Gateway serves OpenClaw Control HTML on localhost:18789
  - Sandbox can reach mnemo-cortex at `host.docker.internal:50001` — verified with `curl` from inside sandbox (returned `status: ok`). UFW rule from earlier session survived, and the clean reinstall resolved the pod network isolation.
  - Device identity error resolved — the official installer handles identity setup correctly (no more "pairing required" errors).
  - Mnemo-cortex and Ollama completely untouched throughout
**Prevention:** Always use the official NemoClaw installer. Never `npm install -g` from a tarball or unknown source. The installer handles gateway, identity, port forwarding, and policy setup correctly. The npm registry `nemoclaw` package is a 222-byte name squatter — the real source is `github.com/NVIDIA/NemoClaw`.

## Heartbeat cost leak
**Date:** 2026-03-23 (ongoing)
**Symptom:** Cron job heartbeat burning ~$2.40/day in OpenRouter credits.
**Cause:** Heartbeat cron job runs on the `main` agent without a model override, so it defaults to Gemini Pro instead of using the free Nemotron tier.
**Fix:** Pending — need OpenClaw per-session model override to force heartbeat to free tier.
**Prevention:** Any cron/scheduled agent call must specify an explicit model override. Never let scheduled jobs default to paid models.

## CC denied NemoClaw's existence
**Date:** 2026-03-23
**Symptom:** CC (Opie) told Guy that NemoClaw doesn't exist and there's no such NVIDIA project.
**Cause:** CC didn't check the actual install path on THE VAULT before declaring it fake. NemoClaw is a real NVIDIA project at `github.com/NVIDIA/NemoClaw` with an official installer at `nvidia.com/nemoclaw.sh`.
**Fix:** Verified NemoClaw v0.1.0 on THE VAULT. Later did a clean reinstall via official installer.
**Prevention:** Always check the actual system before declaring something doesn't exist. Vapor Truth means verifying, not guessing.

## Billing firehose — sessionMemory + memoryFlush
**Date:** 2026-03-16
**Symptom:** OpenRouter credits burning while idle. 66 embedded agent runs/hour.
**Cause:** Two OpenClaw settings were generating excessive API calls:
  - `memorySearch.experimental.sessionMemory` — 66 embedded agent runs/hour
  - `compaction.memoryFlush` — secondary token burner
**Fix:** Disabled both settings in OpenClaw config. Also found and fixed same bug in THE VAULT host config (discovered 2026-03-23 per Rocky).
**Prevention:** Audit any experimental/polling settings for cost before enabling. Monitor OpenRouter dashboard after config changes.

## Zombie mnemo-cortex process on IGOR
**Date:** 2026-03-16
**Symptom:** Requests from IGOR to mnemo-cortex were being intercepted locally instead of reaching THE VAULT (artforge:50001).
**Cause:** A mnemo-cortex v2.0 process was running on IGOR at localhost:50001, shadowing the remote service on THE VAULT.
**Fix:** Killed the local process. Patched handler.ts. Permanently removed the pipx mnemo-cortex binary from IGOR.
**Prevention:** No mnemo-cortex process should ever run on IGOR. If `curl localhost:50001` responds on IGOR, something is wrong. The canonical server is always `artforge:50001`.

---

*The first time CC fixes a non-trivial bug, it adds it here. Newest at top.*
