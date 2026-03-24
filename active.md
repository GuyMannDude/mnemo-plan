# Active

What's happening right now. Current work, priorities, blockers, next actions.

**Last updated:** 2026-03-23

---

## In Progress
- [ ] **LAN access for Sparky gateway** — Gateway works on localhost:18789 on THE VAULT. Need to rebind to 0.0.0.0 so Guy can reach it from IGOR at `http://artforge:18789/`. Command: `openshell forward stop 18789 sparks-nemo && openshell forward start -d 0.0.0.0:18789 sparks-nemo`
- [ ] **Heartbeat cost leak fix** — Cron heartbeat defaulting to Gemini Pro (~$2.40/day). Needs per-session model override.
- [ ] **Rocky OpenClaw update** — IGOR at v2026.3.13, update to v2026.3.22 pending green light
- [ ] **Add mnemo-cortex network policy preset** — need to re-add custom `mnemo-cortex.yaml` preset to the clean NemoClaw install's presets dir (UFW rule survived but the policy preset file was part of the old install)

## Up Next
- [ ] Browser test: Guy opens `http://artforge:18789/` from IGOR and chats with Sparky
- [ ] Test browser fix that was pending before this session

## Blocked
- **Heartbeat:** Needs OpenClaw per-session model override feature to force cron jobs to free tier.

## Recently Completed
- [x] **NemoClaw clean reinstall** (2026-03-23) — official installer, all checks pass, no more proxy hacks
- [x] Sparky gateway fix — resolved by clean reinstall (identity, networking, port forward all handled by installer)
- [x] Sparks Brain populated with real infrastructure data (2026-03-23)
- [x] Rocky consulted for brain completeness check (2026-03-23)
- [x] Alice fully retired, config archived to 5TB_DRIVE-2 (2026-03-23)
- [x] Billing firehose also fixed on THE VAULT host config (2026-03-23)
- [x] Sparks Brain repo created and published (GuyMannDude/sparks-brain)
- [x] Mnemo Cortex v2.0 deployed on THE VAULT (2026-03-16)
- [x] Zombie mnemo-cortex process killed on IGOR (2026-03-16)
- [x] Billing firehose plugged on IGOR — disabled sessionMemory + memoryFlush (2026-03-16)

## Notes
- Alice is retired. Sparky (in NemoClaw pod) now fills the experimental agent role.
- NemoClaw installed via `curl -fsSL https://www.nvidia.com/nemoclaw.sh | bash` — never use npm install.
- The npm registry `nemoclaw` package (222 bytes, by jacobtomlinson) is a name squatter. Real source: github.com/NVIDIA/NemoClaw.
- Sparks Router v0.6.0 active on IGOR (localhost:8100). Smart/Utility→Gemini Pro, Free→Nemotron.
- Mnemo-cortex reachable from sandbox pod via `host.docker.internal:50001` (UFW rule for 172.16.0.0/12 on port 50001).

---

*CC updates this file every session. If this file is stale, the brain is stale.*
