# Active

What's happening right now. Current work, priorities, blockers, next actions.

**Last updated:** 2026-04-18

---

## Kickstart — Next Session (2026-04-19)
Guy's words tonight: "Tomorrow we finish testing and bridging desktops."
- **Finish testing:** Passport Lane Phase 1.5 is live on THE VAULT; 4 dispositions
  (hard_block, review_required, local_only, allow) verified end-to-end via curl.
  Opie has the new /observe response schema post-restart. Next move is likely
  Opie driving observe_behavior through its MCP tool and confirming the new
  disposition/taint/flagged_spans fields surface correctly in the Desktop UI.
- **Bridging desktops:** ambiguous phrasing — could mean Desktop-to-Desktop MCP
  bridge work, or bridging Opie (Desktop) and CC (IGOR) to share state more
  cleanly. Ask Opie/Guy first move, don't assume.
- **Fresh Opie context:** opie.md was last updated April 14-16 and does NOT yet
  mention Passport Lane. If Opie boots without context, point him at
  `brain/projects/products/mnemo-passport.md` (has both Phase 1 + Phase 1.5
  SHIPPED banners I wrote today).

---

## In Progress
- [x] **Passport Lane Phase 1.5** — SHIPPED 2026-04-18. Per-evidence provenance,
  32 named detectors, 4-YAML config, Gate 2 stub, bucket_floor audit trail.
  Commits: mnemo-cortex `d31e5fa`, brain `8ebd19f` (April-is-daughter fix).
- [ ] **Rocky's Gallery — Shopify store** — Scaffold built at /home/guy/shopify/rockys-gallery/. Shopify AI Toolkit installed (17 skills). Andre's starter photos on IGOR. Next: Guy signs up for Shopify, picks 4 starter pieces, CC builds the store.
- [ ] **Hoffman Bedding — Google Merchant Center** — GMC suspended (not dead). All product/site fixes COMPLETE. SEO + alt text applied (129/129 products, 723/723 images). 2 missing product types fixed. Microsoft Clarity installed (analytics only, April 14). Waiting for cool-down period to end before re-appeal.
- [ ] **Stripe publishable key** — Guy needs to grab pk_live_ from dashboard.stripe.com/apikeys
- [x] **Sparks Counters** — GoatCounter on THE VAULT (port 50180), sparks_stats FrankenTool #13, peter-stats.py, all 11 site pages instrumented. Counting from April 14.
- [x] **Hoffman SEO batch** — 129/129 alt text + SEO title + SEO description applied. 723/723 images have alt. April reviewing live.

## Up Next
- [ ] Rocky's Gallery Shopify signup + first 4 product listings
- [ ] Andre's full catalog download from Google Drive (auth issue — need public share or manual download)
- [ ] Chat Portal deployment (after Stripe key)
- [ ] Sparks Bus v0.2 — bus_subscribe (standing interest), message TTL
- [ ] Mem0 bridge production deploy (code exists, needs pip install on THE VAULT)
- [ ] Hoffman Bedding re-appeal (waiting on GMC cool-down end date from April)
- [ ] Hoffman 28 collection SEO descriptions (separate batch)

## Blocked
- **Heartbeat re-enable:** Resolved — heartbeat running on Nemotron free tier (1h interval)
- **Sparky Mnemo:** ~~Needs NVIDIA/NemoClaw#1551 fix or workaround~~ RESOLVED — Docker bridge path works. Consider updating/withdrawing #1551.

## Completed This Session (April 7, 2026)

### OpenClaw 2026.4.5 Post-Update Verification
- [x] `openclaw doctor --fix` — config migrated, backup created
- [x] Heartbeat cron verified clean (Nemotron free, 348 runs, no cost leak)
- [x] Mnemo bridge on THE VAULT — healthy (170 entries, save/recall working)
- [x] Memory-core plugin enabled, dreaming enabled (daily frequency)
- [x] Gateway restarted to pick up config changes

### Opie Memory Fix
- [x] Diagnosed: Opie's watcher dead since March 25 (Desktop moved to IndexedDB)
- [x] Stopped and disabled mnemo-watcher-opie systemd service
- [x] Patched MCP server v2.1.0: nudge system (tool call tracking, save reminders, session_end tool)
- [x] Pulled Desktop integration from public GitHub (mnemo-cortex v2.3.0)
- [x] Updated both repos: mnemo-cortex (pushed) + mnemo-cortex-mcp (archived, local only)
- [x] Updated Opie brain lane with current ground truth
- [x] Restarted Claude Desktop, verified Opie boots with corrected context

### Hoffman Bedding — Full Compliance Cleanup
- [x] Email audit: found 2 straggler supplier emails (makeitblanket, lasetany), replaced then removed
- [x] 14 missing product types filled in (blankets, pillows, quilts, bed frame, accessories)
- [x] 2 ALL CAPS titles fixed (Andrea Lumbar Pillow, Palma Handwoven Baskets)
- [x] 17 supplier URLs removed (16 melangehome.com + 1 americanblossomlinens.com)
- [x] Reed Diffuser junk data cleaned (30 timestamp artifacts removed)
- [x] sameAs empty social links fixed in theme header.liquid (filters blanks now)
- [x] Contact page EST→PST: confirmed fixed in template (CDN propagating)
- [x] TOS [LINK] placeholder: fixed by Opie + April
- [x] Shipping policy intl contradiction: fixed by April
- [x] Final state: 0 stray emails, 0 external URLs, 0 placeholders, all types filled, all titles clean
- [x] Deep audit: 207/252 products clean (82.1%), site policies 100% compliant

### April 6 Completed (prior session)
- [x] Peter Widget built, deployed, live on projectsparks.ai
- [x] Mem0 bridge built (8/8 tests pass, not deployed to production)
- [x] Hoffman email fix (128 products unified to hoffmanbedding@gmail.com)

## Notes
- Peter Widget backend: IGOR:50095 (systemd: peter-widget.service)
- Peter Widget API: https://igor.tailce7587.ts.net (Tailscale Funnel)
- Peter Mnemo: IGOR:50002 (agent_id: peter-widget-{visitorId})
- Peter knowledge: ~/peter-customer/knowledge/products.md
- Mem0 bridge: ~/github/mnemo-cortex/agentb/mem0_bridge.py (needs pip install + deploy)
- NemoClaw issue: NVIDIA/NemoClaw#1551
- Hoffman: GMC suspended, all fixes done. 106 draft products ready to publish. 723 images need alt text.
- Opie MCP: ~/github/mnemo-cortex-mcp/server.js v2.1.0 (nudge system, session_end tool)
- Shopify auth: OAuth client_credentials flow via FrankenClaw pattern (auto-refreshes 24h tokens)

---

*CC updates this file every session. If this file is stale, the brain is stale.*
