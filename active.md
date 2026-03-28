# Active

What's happening right now. Current work, priorities, blockers, next actions.

**Last updated:** 2026-03-27

---

## In Progress
- [ ] **LAN access for Sparky gateway** — Gateway works on localhost:18789 on THE VAULT. Need to rebind to 0.0.0.0 so Guy can reach it from IGOR at `http://artforge:18789/`. Command: `openshell forward stop 18789 sparks-nemo && openshell forward start -d 0.0.0.0:18789 sparks-nemo`
- [x] **Heartbeat cost leak fix** — Disabled cron job (2026-03-23). Re-enable when HEARTBEAT.md has tasks AND free-tier model override is available.
- [ ] **Rocky OpenClaw update** — IGOR at v2026.3.13, update to v2026.3.22 pending green light
- [x] **Mnemo-cortex reachable from pod** — verified with curl from inside sandbox, status: ok. UFW rule + clean reinstall fixed it.
- [ ] **Add mnemo-cortex network policy preset** — need to re-add custom `mnemo-cortex.yaml` preset to the clean NemoClaw install's presets dir (UFW rule survived but the policy preset file was part of the old install)

## Up Next
- [ ] Browser test: Guy opens `http://artforge:18789/` from IGOR and chats with Sparky
- [ ] Test browser fix that was pending before this session
- [ ] **Rocky-to-CC bridge** — `claude -p` works from shell (needs `env -u CLAUDECODE`). Rocky can dispatch tasks to CC and read stdout. Not wired yet.
- [ ] **BW integration** — BW reachable at localhost:50090, API is POST /api_message, bridge script at `~/.bw/bw-talk.sh`. Token pin may need refresh.
- [ ] **IGOR-2 network access** — hostname doesn't resolve from IGOR. Need Tailscale IP or DNS entry.

## Blocked
- **Heartbeat re-enable:** Needs OpenClaw per-session model override feature to force cron jobs to free tier. Job disabled until then.

## Recently Completed
- [x] **Rocky's Router → GitHub** (2026-03-27) — Repo initialized at ~/github/rockys-router/, pushed to GuyMannDude/rockys-router. README with Rocky hero image, .gitignore, full product description.
- [x] **"Sparks Router" → "Rocky's Router" rename** (2026-03-27) — Renamed across all projectsparks.ai pages (index, sparks-router, claudepilot, mnemo-cortex). Both ClaudePilot guide texts updated. Zero remaining "Sparks Router" text references.
- [x] **Saves-money messaging** (2026-03-27) — Router page fully rebuilt from "under construction" to live product page with $2.40→$0 savings callout. New "saves money" section added to mnemo-cortex page linking the two products. Deployed to Firebase.
- [x] **Rocky hero image** (2026-03-27) — ROCKY-REALISTIC-V3-brawler.png deployed to both GitHub README and projectsparks.ai router page.
- [x] **Mnemo-Claude Bridge** (2026-03-24) — CC has persistent long-term memory via mnemo-cortex on THE VAULT. Agent ID "cc", isolated writes to `memory/cc/`, cross-agent reads from all agents (Rocky, Sparky, CC) via shared L2+L3. Two hook scripts: `mnemo-startup.sh` (session start context pull) and `mnemo-writeback.sh` (session end archive). agentb_bridge.py patched for multi-agent isolation. CLAUDE.md wired with startup/shutdown hooks.
- [x] **Mnemo-cortex Claude Code integration packaged** (2026-03-24) — `integrations/claude-code/` added to mnemo-cortex repo with install.sh, hook scripts, README. PR #1 merged to master.
- [x] **projectsparks.ai/mnemo-cortex page updated** (2026-03-24) — "Deep Recall" branding, Claude Code integration section with model tiers and install command, neon steampunk styling (brighter gold/amber/copper), bumped text sizes, added /sessions endpoint. Deployed via Firebase.
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
- **Work orders:** Guy drops tasks in a Google Doc at https://docs.google.com/document/d/13kDZHXodmsAi30Ah30CmHpktNHI98w8ZbTigEUR37fg/edit — CC should check this on startup.
- Alice is retired. Sparky (in NemoClaw pod) now fills the experimental agent role.
- NemoClaw installed via `curl -fsSL https://www.nvidia.com/nemoclaw.sh | bash` — never use npm install.
- The npm registry `nemoclaw` package (222 bytes, by jacobtomlinson) is a name squatter. Real source: github.com/NVIDIA/NemoClaw.
- Rocky's Router v3 at localhost:50070, systemd service `rockys-router`. GitHub: GuyMannDude/rockys-router.
- Sparks Router v0.6.0 active on IGOR (localhost:8100). Smart/Utility→Gemini Pro, Free→Nemotron.
- Mnemo-cortex reachable from sandbox pod via `host.docker.internal:50001` (UFW rule for 172.16.0.0/12 on port 50001).

---

*CC updates this file every session. If this file is stale, the brain is stale.*
