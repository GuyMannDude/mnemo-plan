# Active

What's happening right now. Current work, priorities, blockers, next actions.

**Last updated:** 2026-04-05

---

## In Progress
- [ ] **Chat Portal — Guy testing** — Portal live at localhost:50085. Two-tier model (free Grok 4 Fast / paid Sonnet $2.99). Mnemo on 50002 for customer memory. 8 content docs. Stripe product + price created. Needs publishable key to go live with payments.
- [ ] **Stripe publishable key** — Guy needs to grab pk_live_ from dashboard.stripe.com/apikeys
- [ ] **LAN access for Sparky gateway** — Gateway works on localhost:18789 on THE VAULT. Need rebind to 0.0.0.0.
- [ ] **Rocky's Router GitHub repo → private**
- [ ] **Add mnemo-cortex network policy preset** — for NemoClaw sandbox
- [ ] **NotebookLM MCP for Opie** — Installed (v0.5.16), auth works for reads, writes fail (Google cookie expiry issue). Config in Claude Desktop. Needs fresh `nlm login` before write operations.

## Up Next
- [ ] Chat Portal deployment to projectsparks.ai (after Guy tests locally)
- [ ] Rocky-to-CC bridge — `claude -p` works from shell. Not wired yet.

## Blocked
- **Heartbeat re-enable:** Needs OpenClaw per-session model override feature.
- **NotebookLM writes:** Google session cookies expire every ~2-3 hours. Write operations need fresh CSRF token. No permanent fix — Google-side limitation. Workaround: `nlm login` before write sessions.

## Recently Completed (April 5, 2026)
- [x] **Shopify unblocked** — Store URL was wrong (wug → wugjc3-qh). Updated keys.json. All 3 FrankenTools (products, inventory, collections) now work.
- [x] **Shopify catalog pull** — 354 products pulled to ~/github/hoffman-bedding/products.json
- [x] **Succulents archived** — 2 succulent products archived (not deleted) per Guy's approval
- [x] **Product feed cleanup** — 80 products drafted: 8 zero-price, 72 out-of-stock. Feed now clean: 146 active products, all with prices, inventory, images, descriptions.
- [x] **robots.txt fixed** — Created custom robots.txt.liquid removing /policies/ block. Google can now crawl all policy pages.
- [x] **Footer contact info added** — Phone (559) 417-3135, email hoffmanbedding@gmail.com, address 26285 Haley Way Madera CA 93638 added to theme footer.
- [x] **Merchant Center readiness verified** — All checks PASS. April cleared to resubmit.
- [x] **NotebookLM catalog upload** — Converted catalog to markdown, uploaded to NotebookLM notebook as source (source ID: 2bef1ade-7871-4fee-ac67-9c2268801428)
- [x] **Rocky's Switch og:image** — Changed from generic og-image.png to rocky.png on projectsparks.ai/rockys-switch. Deployed to Firebase.
- [x] **NotebookLM MCP installed** — uv + notebooklm-mcp-cli v0.5.16 on IGOR. Auth as guitarmanndude69@gmail.com. Config added to Claude Desktop.
- [x] **Theme API access** — April granted read_themes + write_themes scopes to RockyBot app.

## Previously Completed (April 2-4, 2026)
- [x] Opie MCP fix — opie-brain MCP server v2.0.0
- [x] Chat Portal built — Codex scaffold + CC integration
- [x] Portal Mnemo instance on IGOR:50002
- [x] Stripe integration — acct_1SzUT7Dk4CDADjbW
- [x] Rocky's Switch shipped PUBLIC
- [x] FrankenClaw shipped PUBLIC (12 tools, v0.3.0)
- [x] OpenClaw updated to 2026.4.2
- [x] CSR Rocky portal — No Manual Editing doctrine
- [x] mnemo-cortex v2.2.0 (MCP bridge merge, health command)
- [x] CronAlarm pushed public

## Notes
- Hoffman Bedding store: hoffmanbedding.com (handle: wugjc3-qh.myshopify.com)
- Shopify API scopes: read/write products, read/write inventory, read_product_listings, read/write themes
- Shopify creds in ~/.rockys-switch/keys.json under "shopify_hoffman"
- Google Tag on store: GT-MQ76NGRV, Merchant Center: MC-V8WZQYSXZR
- NotebookLM notebook ID: e18f3b53-bb26-49a9-ab54-14d8af2bc7d9
- April = Guy's collaborator on Hoffman Bedding Shopify store
- Product catalog files: ~/github/hoffman-bedding/products.json (original), products-clean.json (post-archive), products-clean.txt (markdown for NotebookLM)

---

*CC updates this file every session. If this file is stale, the brain is stale.*
