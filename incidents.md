# Incidents

The runbook. Every bug that cost real debugging time, documented so it never costs time again.

**New incidents go at the top.** Never delete old ones — they're still valuable context.

---

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
