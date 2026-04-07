# Active

What's happening right now. Current work, priorities, blockers, next actions.

**Last updated:** 2026-04-07

---

## In Progress
- [ ] **Hoffman Bedding — Google Merchant Center** — GMC suspended (not dead). All product/site fixes COMPLETE. Waiting for cool-down period to end before re-appeal. April tracking the timeline.
- [ ] **Stripe publishable key** — Guy needs to grab pk_live_ from dashboard.stripe.com/apikeys
- [ ] **Sparky Mnemo blocked** — NemoClaw openshell proxy returns 403 on non-TLS internal endpoints. Issue filed: NVIDIA/NemoClaw#1551. Sparky updated to OpenClaw 2026.4.5 but can't reach Mnemo.
- [ ] **Mnemo Desktop integration** — Pulled from public GitHub (v2.3.0). MCP nudge system built (v2.1.0). Working on our Opie. Will re-publish when proven.

## Up Next
- [ ] Chat Portal deployment (after Stripe key)
- [ ] Rocky-to-CC bridge
- [ ] Mem0 bridge production deploy (code exists, needs pip install on THE VAULT)
- [ ] Hoffman Bedding re-appeal (waiting on GMC cool-down end date from April)
- [ ] Bulk image alt text for Hoffman (723 images, 0% have alt — big SEO win)

## Blocked
- **Heartbeat re-enable:** Resolved — heartbeat running on Nemotron free tier (1h interval)
- **Sparky Mnemo:** Needs NVIDIA/NemoClaw#1551 fix or workaround

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
