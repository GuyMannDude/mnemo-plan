# Stack

Every service, tool, and dependency in the Project Sparks ecosystem.

---

## NemoClaw
- **Version:** 0.1.0
- **Location:** THE VAULT — `~/.npm-global/bin/nemoclaw`
- **What it is:** CLI that runs OpenClaw inside OpenShell sandboxes with NVIDIA inference. Manages sandbox lifecycle, policy presets, and deployment.
- **Key commands:**
  - `nemoclaw list` — list sandboxes
  - `nemoclaw <name> connect` — connect to sandbox
  - `nemoclaw <name> status` — health check
  - `nemoclaw <name> destroy` — tear down sandbox
  - `nemoclaw deploy <instance>` — deploy to Brev VM
  - `nemoclaw start/stop/status` — manage services (Telegram, tunnel)
- **Dependencies:** openclaw 2026.3.11, Node >=20.0.0
- **Config:** `~/.nemoclaw/credentials.json` (mode 600)
- **Active sandbox:** `sparks-nemo` (multiple connect processes running since Mar 19)
- **Pod networking:** NemoClaw pods are network-isolated by default — cannot reach host ports. Fix pending via drop-in YAML network policy presets (NemoClaw Compatibility Spec).
- **Notes:** Credentials prompted on first use, saved securely. License: Apache-2.0.

## OpenClaw
- **What it is:** Agent framework. Rocky and Sparky run on it.
- **Versions:**
  - IGOR: v2026.3.13 (v2026.3.22 update pending green light)
  - THE VAULT (host): v2026.3.22
  - Sparky (NemoClaw pod): v2026.3.11
- **Rocky config:** `~/.openclaw/workspace/` on IGOR
- **Notes:** Rocky's SOUL.md and MEMORY.md in `~/.openclaw/workspace/` are sacred — never modify without asking.

## Mnemo Cortex
- **Version:** 2.0 (SQLite + FTS5, TypeScript)
- **Server:** THE VAULT (artforge), port 50001
- **From IGOR:** `http://artforge:50001`
- **Repo:** `~/github/mnemo-cortex/` (local), GuyMannDude/mnemo-cortex (GitHub)
- **Daemons:** Watcher + refresher on THE VAULT (systemd user services)
- **LLM summarizer:** OpenRouter / gemini-2.5-flash with deterministic fallback
- **CRITICAL:** No mnemo-cortex process should ever run on IGOR.

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

## Ollama
- **Location:** THE VAULT
- **Port:** 11434
- **From IGOR:** `100.22.45.109:11434` (Tailscale)

## Agent Zero (Bullwinkle)
- **Location:** IGOR, Docker container
- **Port:** localhost:50090
- **Model:** nvidia/nemotron-3-super-120b-a12b:free (all slots)
- **Notes:** NOT managed by OpenClaw. Separate system.

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
