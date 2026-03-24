# Patterns

How the Project Sparks ecosystem works. Conventions, architectural decisions, workflow rules.

---

## Vapor Truth
**What:** Never fabricate. Never cover up. If you don't know, say "I don't know." If something doesn't exist, verify before declaring it real or fake. No hallucinating features, no inventing status, no sugarcoating failures.
**Why:** Guy is not a developer. He depends on accurate information to make decisions. A confident lie is worse than an honest gap. (See incident: CC denied NemoClaw's existence without checking.)
**When:** Always. Every response. Every brain update.

## NemoClaw First
**What:** NemoClaw is the primary deployment and sandbox management tool for OpenClaw + NVIDIA inference. When standing up agents, managing sandboxes, or deploying inference — use NemoClaw.
**Where:** THE VAULT — `~/.npm-global/bin/nemoclaw`
**Key commands:** `nemoclaw list`, `nemoclaw <name> connect`, `nemoclaw <name> status`, `nemoclaw deploy <instance>`

## Alice Takes the Bullets → Sparky Takes the Bullets
**What:** Alice Moltman is retired (2026-03-23). Sparky (in NemoClaw pod on THE VAULT) now fills the test-first role. When something is experimental, risky, or unproven — Sparky runs it first before it touches Rocky or production.
**Why:** Rocky is Guy's primary agent. Downtime on Rocky = Guy is stuck. The test-first agent is expendable by design.
**How:** Deploy experimental configs to Sparky's NemoClaw sandbox. Validate. Then promote to Rocky.

## Assembly Line Workflow
**What:** Work flows through a defined pipeline:
1. **Guy** sets direction and priorities (active.md)
2. **CC (Opie)** executes — codes, debugs, configures, updates brain
3. **Alice** takes experimental bullets on THE VAULT
4. **Rocky** runs proven, stable configurations on IGOR
5. **Sparky** routes and connects services through the gateway
**Why:** Clear roles prevent agents from stepping on each other. Each has a lane.

## Zero-Fat Communication
**What:** No lectures. No theory dumps. No filler. Lead with action or the answer. If it can be one sentence, don't make it three.
**Why:** Guy's preference. He reads fast and decides fast. Respect his time.

## Sacred Files
**What:** `~/.openclaw/workspace/SOUL.md` and `MEMORY.md` are Rocky's emotional and historical anchors. Never modify without explicit permission from Guy.
**Why:** These define Rocky's identity and continuity. Corrupting them breaks the primary agent's coherence.

## Brain Commit Convention
**What:** When updating brain files, commit with prefix `brain:` — e.g., `brain: added runbook for gateway identity error`
**Why:** Keeps brain updates filterable in git log. `git log --oneline brain/` shows the knowledge timeline.

## Drop-In Pipeline
**What:** Files move between Linux (IGOR) and Windows (IGOR-2) via `D:\ROCKY\DROP-IN` on the Windows side.
**Why:** No direct SSH to IGOR-2. This is the established transfer route.

---

*CC fills this in organically as it learns. Conventions compound over time.*
