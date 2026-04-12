# Stack

Every service, tool, and dependency in the Project Sparks ecosystem.

---

## NemoClaw
- **Version:** 0.1.0
- **Location:** THE VAULT — `~/.npm-global/bin/nemoclaw`
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

## OpenClaw
- **What it is:** Agent framework. Rocky and Sparky run on it.
- **Versions:**
  - IGOR: **v2026.4.8** (updated April 8, doctor --fix run)
  - THE VAULT (host): v2026.3.22
  - Sparky (NemoClaw pod): **v2026.4.11** (was 2026.3.11, updated April 12)
  - **Latest available: v2026.4.11** (released April 11)
- **Rocky config:** `~/.openclaw/workspace/` on IGOR
- **Rocky model:** DeepSeek V3.2 via OpenRouter DIRECT (no Switch proxy). 5 aliases: DeepSeek, Grok, Free, Gemini, Grok41. Switch via `/model` command in chat.
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
- **Tools:** 12 FrankenTools (search, vision, browser, web_scrape, 3x shopify, 5x notebooklm)
- **Website:** projectsparks.ai/frankenclaw

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
