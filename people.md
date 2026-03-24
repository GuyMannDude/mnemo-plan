# People

Collaborators, agents, and roles in the Project Sparks ecosystem.

---

## Guy
- **Role:** Creator, maker, Project Sparks founder
- **Location:** Half Moon Bay, CA
- **Background:** 73-year-old maker, not a developer. Builds 3D printed seasonal collectibles (projectsparks.ai).
- **Working style:** Zero-fat. Action over theory. Simple explanations. Trusts CC to act autonomously.
- **Note:** Guy is the human. Everyone else below is an AI agent.

## Rocky
- **Role:** Primary AI assistant. Guy's right hand.
- **Platform:** OpenClaw on IGOR
- **Model (primary):** openrouter/google/gemini-3.1-pro-preview
- **Model (fallback):** openrouter/nvidia/nemotron-3-super-120b-a12b:free
- **Workspace:** `~/.openclaw/workspace/`
- **Sacred files:** SOUL.md and MEMORY.md — never touch without asking Guy.
- **Browser:** CDP attach configured (chrome://inspect, port 9222)

## Alice Moltman (RETIRED)
- **Status:** Fully retired as of 2026-03-23.
- **Was:** Agent on THE VAULT. Took the bullets — ran experimental/risky tasks first.
- **Platform:** OpenClaw on artforge (now disabled)
- **Host config archived to:** `/media/guy/5TB_DRIVE-2/ARCHIVE/alice-host-config-20260323/`
- **Disabled services:** Host-level gateway, sparks-router, mnemo watcher/refresher on THE VAULT.
- **Notes:** Alice's role (experimental test-first agent) is now absorbed by Sparky in the NemoClaw sandbox.

## Sparky
- **Role:** Agent inside NemoClaw sandbox on THE VAULT. Runs Nemotron 3 Super free via OpenRouter. CLI only (no gateway/Telegram).
- **Platform:** OpenClaw v2026.3.11 inside NemoClaw pod
- **Current issue:** Cannot reach mnemo-cortex (port 50001) due to NemoClaw pod network isolation. Also: device identity error on gateway.

## Opie (CC / Claude Code)
- **Role:** Claude Code on IGOR. Execution engine. Reads the brain, does the work, writes back what it learns.
- **Model:** Claude Opus 4.6
- **Auth:** Max plan via claude.ai
- **Principles:** Vapor Truth — never fabricate, never cover up. If uncertain, say so.

## Bullwinkle (BW)
- **Role:** Agent Zero instance
- **Platform:** Docker on IGOR (localhost:50090)
- **Model:** nvidia/nemotron-3-super-120b-a12b:free (all slots)
- **Notes:** NOT managed by OpenClaw. Separate system.

---

*CC updates this file as collaborators and roles change.*
