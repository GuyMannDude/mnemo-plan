# Stack

Every service, tool, and dependency in the Project Sparks ecosystem.

---

## Rocky's Gallery 1-of-1 rotation — TORN DOWN 2026-04-23

All automation killed per Guy's directive. 1-of-1 drops are manual now: Guy picks the piece, sets the price, publishes, pulls.

**What was removed:**
- Both crons (`*/15 rotate.py sweep`, `*/5 poll_sales.py`) — out of crontab.
- `rotate.py`, `poll_sales.py`, `one_of_one.py` — moved to `~/shopify/rockys-gallery/scripts/_archived-automation-2026-04-23/`. Reversible if ever needed.
- `active.json` cleared (active=None, awaiting_gate=None).
- Isola Minore on Shopify → `status=DRAFT` (pulled from storefront). Product record preserved for manual re-promotion later.

**What's kept in place:**
- Utility scripts: `gallery_api.py` (Shopify Admin API helper), `fileflare.py` (Fileflare upload), `watermark.py` + `apply_watermarks.py` (image watermarking). Still useful for manual 1/1 prep.
- `queue.json`, `sold-log.json`, `expired-log.json` — historical data, left on disk.
- Spoon on Linen at $6 in the Altar collection — demote already completed, stays as-is.

**Replacement: Shopify Flow → Discord webhook → `#alerts` on 1/1 sale.**
- Steps documented at `~/shopify/rockys-gallery/SHOPIFY-FLOW-1OF1-ALERT.md`.
- One-time setup (Guy creates a Discord webhook for `#alerts`, builds a Flow with trigger=`order created`, condition=`any line item tag includes 1of1`, action=`Send HTTP request` to the webhook).
- Zero server code. Replaces `poll_sales.py` entirely.

**Doctrine:** Guy's 1-of-1s are a curator move now, not a pipeline. Each drop is manual and intentional. Price, timing, and lifecycle are Guy's calls per piece.

## Microsoft Clarity — rockysgallery.com analytics
- **Live on rockysgallery.com as of 2026-04-23 evening** (snippet injected via Shopify admin → theme.liquid or Additional scripts).
- **Project ID:** `wge18xcvkx` (confirmed by curling the live pages and grepping the clarity init call).
- **API queries** via the Clarity Data Export API (https://clarity.microsoft.com/projects/view/wge18xcvkx/dashboard — same auth pattern as Hoffman Bedding's setup). Unique visitors per URL is the queryable metric for the v1.1 rotation visitor-threshold trigger.
- **Pairs with Hoffman Bedding's Clarity** (separate project, installed April 14). Two stores, two project IDs, same tooling.

## Google Drive (Rocky, read-only)
- **How:** Two FrankenTools at `~/github/frankenclaw/tools/gdrive.py` (commit `9a33d6f`): `gdrive_search` + `gdrive_read`. Auto-discovered by FrankenClaw on Rocky session start.
- **Why not the MCP server:** The archived `@modelcontextprotocol/server-gdrive` exposes reading as MCP **Resources**, not Tools. OpenClaw's agent surface is tool-centric — Rocky could search but couldn't see the Resource-based read path. Swapping to FrankenClaw owns the full flow in Python and matches the rest of the tool pattern (shopify_*, notebooklm_*).
- **Was:** `~/.openclaw/openclaw.json` had a `mcp.servers.gdrive` entry. Removed 2026-04-22 in favor of the FrankenClaw implementation.
- **OAuth client** (the app): `~/.openclaw/google/credentials.json` — "installed" type OAuth 2.0 client, was already on disk from Feb 20.
- **User token** (the grant): `~/.openclaw/google/.gdrive-server-credentials.json`, mode 600, contains access_token + refresh_token. Completed interactive OAuth flow 2026-04-22 18:54. Account: `guitarmanndude69@gmail.com`. Scope: `https://www.googleapis.com/auth/drive.readonly` (whole Drive, read-only — no way to scope narrower with the archived server).
- **Tools exposed to Rocky:** `gdrive_search` (search files/folders), `gdrive_read` (read file contents).
- **No write access.** Matches Guy's "read-only first" rule.
- **Known deprecation:** npm package is marked "no longer supported" with SDK pinned at mcp@1.0.1 (current is 1.27+). Works today via stdio protocol stability. **Swap target:** Google announced official remote MCP servers for Google services on 2026-04-22; once docs mature (check `docs.cloud.google.com/mcp/`), migrate from the archived stdio server to the official remote MCP.

## NemoClaw
- **Version:** 0.1.0 locally (installed 2026-03-23). Upstream has since retagged from 0.1.0 pre-release back to 0.0.x series; **v0.0.22 is the current stable tag** (Apr 21 2026, NVIDIA). ~30 days of commits ahead of Guy's install. Alpha software per NVIDIA — "APIs and behavior may change without notice."
- **Upgrade path (per NVIDIA):** `cd ~/.nemoclaw/source && git pull && ./install.sh` — bootstrap-style, rebuilds sandbox from pinned image digest. `nemoclaw <name> rebuild` reapplies every preset so policies survive upgrades (IF the preset exists upstream).
- **Mnemo-cortex preset contributed upstream 2026-04-22:** PR https://github.com/NVIDIA/NemoClaw/pull/2315 — structural clone of `local-inference.yaml`, opt-in (not in any policy tier). When merged, `nemoclaw <sandbox> policy-add mnemo-cortex` becomes the persistent path for giving sandboxed agents access to Mnemo at `host.openshell.internal:50001`. Until merged, Mnemo access inside sparks-nemo is unverified and may already be broken (not in applied-policies list).
- **Location:** THE VAULT — `~/.npm-global/bin/nemoclaw` (not in system PATH on artforge; CLI reachable only via full path or via `nemoclaw-blueprint` scripts)
- **Source:** github.com/NVIDIA/NemoClaw (cloned to `~/.nemoclaw/source/`)
- **Installed via:** Official installer: `curl -fsSL https://www.nvidia.com/nemoclaw.sh | bash` (2026-03-23 clean reinstall)
- **What it is:** CLI that runs OpenClaw inside OpenShell sandboxes with NVIDIA inference. Manages sandbox lifecycle, policy presets, and deployment.
- **Key commands:**
  - `nemoclaw list` — list sandboxes
  - `nemoclaw <name> connect` — connect to sandbox
  - `nemoclaw <name> status` — health check
  - `nemoclaw <name> destroy` — tear down sandbox
  - `nemoclaw deploy <instance>` — deploy to Brev VM
  - `nemoclaw start/stop/status` — manage services (Telegram, tunnel)
  - `nemoclaw onboard` — interactive setup wizard
- **Dependencies:** openclaw 2026.3.11, Node >=20.0.0
- **Config:** `~/.nemoclaw/credentials.json` (mode 600), `~/.nemoclaw/sandboxes.json`
- **Active sandbox:** `sparks-nemo` (Landlock + seccomp + netns, NVIDIA cloud inference)
- **Port forward:** `openshell forward` handles 127.0.0.1:18789 → sandbox natively. No proxy hacks.
- **Pod networking:** Pods are network-isolated by default. Host services need: (a) OpenShell network policy entry via `openshell policy set`, and (b) UFW rule for Docker bridge subnets (172.16.0.0/12).
- **WARNING:** The npm registry `nemoclaw` package (222 bytes) is a name squatter. Never `npm install -g nemoclaw` — always use the official installer.
- **Notes:** License: Apache-2.0. Uninstall: `curl -fsSL https://raw.githubusercontent.com/NVIDIA/NemoClaw/refs/heads/main/uninstall.sh | bash`

## Rocky's Switch + Sparky's Router — RETIRED 2026-04-23

Both Switch-pattern routers deprecated and disabled. Rocky had already bypassed his Switch (uses OpenClaw `/model` picker directly against OpenRouter). Sparky and Peter migrations:

- **Sparky-host (artforge)**: `~/.openclaw/openclaw.json` openrouter baseUrl changed from `http://127.0.0.1:50075/v1` (Sparky's Router) → `https://openrouter.ai/api/v1` direct. Four models staged in the provider array: `nvidia/nemotron-3-super-120b-a12b:free` (default), `nvidia/nemotron-3-nano-30b-a3b:free`, `deepseek/deepseek-v3.2`, `deepseek/deepseek-v3.2:free`. Guy switches via OpenClaw `/model` like Rocky does. Backup: `openclaw.json.bak-pre-switch-retire-2026-04-23`. `sparkys-router.service` stopped + disabled. Port 50075 freed. openclaw-gateway restarted pid 3545570.
- **Peter Widget (IGOR, port 50085)**: NO CHANGE NEEDED. `start.sh` already overrides LLM_URL to `https://openrouter.ai/api/v1/chat/completions` direct — Switch-free for LLM routing. Models still free=`x-ai/grok-4-fast`, paid=`anthropic/claude-sonnet-4`. Key-file path stayed at `~/.rockys-switch/keys.json` because it's shared with Rocky's Gallery scripts (`fileflare.py`, `gallery_api.py`). Renaming would have broken Shopify automation. Path is cosmetic legacy, service dependency is gone.
- **Rocky's Switch on IGOR**: systemd service already inactive; `disable`d so it won't auto-start. Config dirs (`~/.rockys-switch/`, `~/.sparksrouter/`) and repos (`~/github/rockys-switch/`, `~/github/sparkys-router/`) left on disk for history.

Live consumers of the old keys.json path to be aware of: `~/portal/src/server.js` (Peter), `~/shopify/rockys-gallery/scripts/fileflare.py`, `~/shopify/rockys-gallery/scripts/gallery_api.py`. All three still function — they read the same keys file, just from its Switch-legacy location.

## OpenClaw
- **What it is:** Agent framework. Rocky and Sparky run on it.
- **Versions (verified 2026-04-22):**
  - IGOR: **v2026.4.15** (on disk + running gateway, pid 2327375 restarted Apr 16)
  - THE VAULT (host): **v2026.4.20** (upgraded 2026-04-22 via `sudo npm install -g openclaw@2026.4.20`; gateway restarted). **Cosmetic:** systemd unit description still says v2026.4.15 — hard-coded in the .service file, not regenerated by npm.
  - Sparky (NemoClaw pod): v2026.4.11 (last known April 12 — unverified since NemoClaw upgrade was deferred)
  - **Latest available: v2026.4.20** (released pre-April 22)
- **Rocky config:** `~/.openclaw/workspace/` on IGOR
- **Rocky model:** Rocky's Switch is **bypassed** for Rocky. Rocky talks to OpenRouter directly and Guy switches models manually via OpenClaw's `/model` command. As of 2026-04-22, running Nemotron free (nvidia/nemotron-3-super-120b-a12b:free) — confirmed via OpenRouter usage logs. The Switch config file (`~/.rockys-switch/config.json`) still reads `activeModel: deepseek/deepseek-v3.2` but that field is cosmetic now for Rocky. Switch is still LIVE serving Sparky and Peter Customer.
- **New in 2026.4.5:**
  - memory-core plugin enabled (was disabled), dreaming enabled (daily frequency)
  - Heartbeat cron running clean on Nemotron free tier (1h interval, 348+ runs)
  - Video/music provider plugins exist but need API keys or ComfyUI server to activate
  - ComfyUI plugin loaded but no running server (ComfyUI is on IGOR-2, not network-reachable)
- **Notable in 2026.4.9–4.11 (not yet installed):**
  - 4.10: Active Memory plugin (automatic context recall before replies — big for Rocky)
  - 4.10: Plugin manifest auth/setup descriptors (relevant for FrankenClaw)
  - 4.10: `openclaw exec-policy` CLI command
  - 4.10: Major browser/security and tools/security hardening
  - 4.11: Ollama model cache (stops refetching on picker refresh — good for THE VAULT)
  - 4.11: Agent failover scoped to current attempt (reliability fix)
  - 4.11: Agent timeout honors explicit config
  - 4.9: Dreaming grounded backfill (replay old notes into Dreams)
  - 4.9: Ollama thinking output when /think is on
- **Notes:** Rocky's SOUL.md and MEMORY.md in `~/.openclaw/workspace/` are sacred — never modify without asking.

## Chat Portal (Rocky's Chat Portal)
- **What it is:** Public-facing chat interface where visitors talk to Rocky about Project Sparks products
- **Repo:** ~/github/sparks-router-v2-codex/ (GuyMannDude/sparks-router-v2, main branch)
- **Port:** 50085
- **Stack:** Zero-dependency Node.js (ESM), static file serving, no express
- **LLM:** Via Rocky's Switch (50060). Free tier: Grok 4 Fast. Paid tier: Claude Sonnet 4.
- **Memory:** Portal Mnemo on IGOR:50002 (separate instance, ~/.agentb-portal/ data dir). Per-customer memory via cookie UUID → Mnemo agent_id.
- **Content:** 8 markdown docs in content/ (FrankenClaw, FrankenTools, Mnemo, Switch, SPARC, OpenClaw, NemoClaw, Modular Vision)
- **Stripe:** Account acct_1SzUT7Dk4CDADjbW (ProjectSparks). Product: Rocky Chat — Sonnet Upgrade (prod_UGTmzzSvtWaMer). Price: $2.99 (price_1THwp0Dk4CDADjbWAPtR4GxV). Needs publishable key from dashboard.
- **Status:** Running locally, Guy testing tomorrow. Test mode (instant upgrade) until Stripe publishable key added.


## Peter Widget (Customer-Facing Chat)
- **Version:** 1.0.0
- **What it is:** Lightweight chat widget on projectsparks.ai. Peter the lobster answers questions about Project Sparks products.
- **Location:** IGOR
- **Port:** 50095 (systemd: peter-widget.service)
- **Public URL:** https://igor.tailce7587.ts.net (Tailscale Funnel)
- **LLM:** Via Rocky's Switch (IGOR:50060, Grok 4 Fast)
- **Memory:** Portal Mnemo (IGOR:50002, agent_id: peter-widget-{visitorId})
- **Knowledge:** ~/peter-customer/knowledge/products.md (loaded at startup)
- **Frontend:** rocky-widget.js served from Firebase Hosting (projectsparks.ai)
- **Identity:** Completely separate from Rocky M. — different name, Mnemo instance, agent_id
- **Repo:** ~/github/rocky-widget/
## Rocky's Switch
- **Version:** 1.2.0-oc2026.4.8
- **Port:** 50060
- **Config dir:** ~/.rockys-switch/ (config.json + keys.json, 0600 permissions)
- **Service:** rockys-switch.service (systemd user)
- **Repo:** ~/github/guys-switch/ (GuyMannDude/rockys-switch — **PRIVATE** as of April 8)
- **What it does:** API proxy for Peter Widget ONLY. Rocky no longer uses it (switched to native OpenClaw model routing direct to OpenRouter).
- **Status:** Pulled from public site and GitHub on April 8. Reasoning model fix (v1.2.0) and Bug 2 (/api/keys crash) shipped before pull.

## FrankenClaw
- **Version:** 0.3.0
- **Location:** ~/github/frankenclaw/
- **GitHub:** GuyMannDude/frankenclaw (PUBLIC, MIT)
- **Tools:** 13 FrankenTools (search, vision, browser, web_scrape, 3x shopify, 5x notebooklm, sparks_stats)
- **Website:** projectsparks.ai/frankenclaw
- **sparks_stats:** Combined web + Peter Widget counter. Params: scope (web|peter|all), window (24h|7d|30d|all). Web data from GoatCounter on THE VAULT (SSH + SQLite). Peter data from local Mnemo store.
- **Doctrine:** For site or Peter numbers, call sparks_stats. Don't guess, don't fetch raw logs, don't invent metrics.

## Mnemo Cortex / AgentB Bridge
- **Deployed version:** agentb_bridge v0.1.0 (standalone FastAPI, NOT the mnemo-cortex v2 repo)
- **GitHub version:** v2.3.0 (April 7 — Desktop integration pulled)
- **Server:** THE VAULT (artforge), port 50001, systemd service `agentb-bridge`
- **From IGOR:** `http://artforge:50001`
- **Source:** `~/agentb-bridge/agentb_bridge.py` on THE VAULT
- **Repo (reference):** `~/github/mnemo-cortex/` (local), GuyMannDude/mnemo-cortex (GitHub)
- **LLM:** Ollama local — qwen2.5:32b-instruct (reasoning) + nomic-embed-text (embedding)
- **Endpoints:** `/health`, `/context`, `/preflight`, `/writeback`, `/ingest`
- **Cache tiers:** L1 (pre-built bundles) → L2 (embedding index) → L3 (brute-force scan)
- **Multi-agent:** Writes isolated to `~/.agentb/memory/{agent_id}/`, reads span all agents. 170+ entries across cc, opie, rocky.
- **Opie MCP server:** ~/github/mnemo-cortex-mcp/server.js v2.1.0 (nudge system, session_end tool). Spawned by Claude Desktop via stdio. mnemo-watcher-opie DISABLED (Desktop stopped writing JSONL).
- **CC watcher:** mnemo-watcher-cc systemd service — still works (CC writes JSONL to ~/.claude/projects/).
- **CRITICAL:** No mnemo-cortex process should run on IGOR port 50001 (conflicts with THE VAULT). Exception: Portal Mnemo on port 50002 for customer chat memory (separate data dir ~/.agentb-portal/).

## Sparks Router
- **Version:** 0.6.0
- **What it is:** API router for Project Sparks services
- **Location:** IGOR, localhost:8100
- **Repo:** `~/github/sparks-router/` (local)
- **Stack:** Python (pyproject.toml, requirements.txt)
- **Config:** `config.json` (example at `config.example.json`)
- **Tier mapping:**
  - Smart/Utility tiers → Gemini 3.1 Pro
  - Free tier → Nemotron
- **UI:** `ui-server/` directory
- **Scaffold:** `~/github/sparks-router/sparks-router-scaffold/`
- **Tests:** `~/github/sparks-router/tests/ongoing/`

## Sparks Brain
- **What it is:** Persistent markdown memory system for Claude Code
- **Repo:** `~/github/sparks-brain/` (local), GuyMannDude/sparks-brain (GitHub)
- **How it works:** CC reads brain files at session start, updates during work, commits back via Git. No database, no vector store.

## Mnemo-Claude Bridge
- **What it is:** Hook scripts that give CC persistent long-term memory via mnemo-cortex
- **Agent ID:** `cc`
- **Hooks:**
  - `~/github/sparks-brain/hooks/mnemo-startup.sh` — pulls context at session start (CC's own + Rocky's recent activity)
  - `~/github/sparks-brain/hooks/mnemo-writeback.sh` — archives session summary at session end
- **Write isolation:** CC writes to `~/.agentb/memory/cc/` on THE VAULT
- **Read access:** Cross-agent — reads all agents via shared L2 index + L3 full scan across all `memory/*/` subdirs
- **Server:** agentb_bridge on THE VAULT (artforge:50001), systemd service `agentb-bridge`
- **Patched:** `~/agentb-bridge/agentb_bridge.py` — added `agent_id` to WritebackRequest, agent-based subdirectory writes, cross-agent L3 scan. Backup at `agentb_bridge.py.bak`.
- **Cost:** $0 — all embedding/reasoning via local Ollama (qwen2.5:32b-instruct + nomic-embed-text)
- **Wired in:** `~/CLAUDE.md` STARTUP block (step 3) and SESSION END block

## Ollama
- **Location:** THE VAULT
- **Port:** 11434
- **From IGOR:** `100.22.45.109:11434` (Tailscale)

## Agent Zero (Bullwinkle / BW)
- **Version:** v0.9.8.2
- **Location:** IGOR, Docker container `bw` (image: agent0ai/agent-zero)
- **Port:** localhost:50090 (maps to container port 80)
- **API:** `POST http://localhost:50090/api_message` with `X-API-KEY` header and `{"message": "...", "context_id": "..."}` body
- **Bridge script:** `~/.bw/bw-talk.sh` — grabs live token from container, sends message, returns JSON
- **Token:** Should be pinned to `bw_sk_rocky_2026` via `~/.bw/pin-token.sh`, but may need refresh (settings show empty)
- **Models:** All Nemotron free tier via OpenRouter (chat, util, browser). Embeddings via Ollama on THE VAULT (100.65.135.34:11434)
- **Work dir:** `~/.bw/work_dir/` — has barbie-images from prior scraping tasks
- **Config:** `~/.bw/settings/settings.json`
- **Notes:** NOT managed by OpenClaw. Separate system. Container has been up 9+ days.

## CronAlarm
- **Repo:** `~/github/cronalarm/`
- **Config/Logs:** `~/.cronalarm/`
- **Scripts:** `~/scripts/`

## Claude Code (CC)
- **Location:** IGOR
- **Auth:** Max plan via claude.ai (guitarmanndude69@gmail.com)
- **Model:** Claude Opus 4.6
- **To switch to API:** set ANTHROPIC_API_KEY env var + `claude auth logout`

---

*CC updates this file as services are added, changed, or removed.*
