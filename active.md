# Active

What's happening right now. Current work, priorities, blockers, next actions.

**Last updated:** 2026-03-23

---

## In Progress
- [ ] **Sparky gateway fix** — Device identity error + pod network isolation preventing Sparky from reaching mnemo-cortex
- [ ] **Heartbeat cost leak fix** — Cron heartbeat defaulting to Gemini Pro (~$2.40/day). Needs per-session model override.
- [ ] **Rocky OpenClaw update** — IGOR at v2026.3.13, update to v2026.3.22 pending green light

## Up Next
- [ ] NemoClaw network policy preset — drop-in YAML to allow pod→host traffic (port 50001)
- [ ] Verify NemoClaw sandbox health on THE VAULT (`nemoclaw sparks-nemo status`)
- [ ] Test browser fix that was pending before this session

## Blocked
- **Sparky↔Mnemo:** NemoClaw pod network isolation blocks Sparky from reaching mnemo-cortex (port 50001). Fix requires NemoClaw Compatibility Spec YAML presets.
- **Heartbeat:** Needs OpenClaw per-session model override feature to force cron jobs to free tier.

## Recently Completed
- [x] Sparks Brain populated with real infrastructure data (2026-03-23)
- [x] Rocky consulted for brain completeness check (2026-03-23)
- [x] Alice fully retired, config archived to 5TB_DRIVE-2 (2026-03-23)
- [x] Billing firehose also fixed on THE VAULT host config (2026-03-23)
- [x] Sparks Brain repo created and published (GuyMannDude/sparks-brain)
- [x] Mnemo Cortex v2.0 deployed on THE VAULT (2026-03-16)
- [x] Zombie mnemo-cortex process killed on IGOR (2026-03-16)
- [x] Billing firehose plugged on IGOR — disabled sessionMemory + memoryFlush (2026-03-16)
- [x] Rocky workspace slimmed: 74.5 KB → 20.8 KB (2026-03-16)
- [x] Dead providers cleaned from openclaw.json (2026-03-16)

## Notes
- Alice is retired. Sparky (in NemoClaw pod) now fills the experimental agent role.
- Sparky is CLI-only — no gateway, no Telegram.
- Sparks Router v0.6.0 active on IGOR (localhost:8100). Smart/Utility→Gemini Pro, Free→Nemotron.
- Testing frameworks at `~/github/mnemo-cortex/tests/ongoing/` and `~/github/sparks-router/tests/ongoing/`
- Legacy Gemini 3.1 Pro image model removed from THE VAULT config.

---

*CC updates this file every session. If this file is stale, the brain is stale.*
