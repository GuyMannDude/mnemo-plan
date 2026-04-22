# Active

What's happening right now. Current work, priorities, blockers, next actions.

**Last updated:** 2026-04-22

---

## Sparks Bus — Notification Loop SHIPPED 2026-04-22

Thin upgrade on v0.1 (separate from the parked v0.2 ground-up rebuild). The
delivery-confirmation loop is now visible in `#dispatch`.

- **Doctrine:** Discord = doorbell, Mnemo = mailbox, `tracking_id` = receipt.
- **Lifecycle posts:** 📬 DELIVERED → ✅ PICKED UP → 🔄 LOOP CLOSED, plus
  ⚠️ STALE in `#alerts` after 1h unacknowledged.
- **All logic in `~/scripts/sparks-bus-watcher.py`** — Bus MCP server NOT
  modified. Watcher is the single integration point; idempotent via 5 new
  DB columns (`tracking_id, mnemo_saved_at, notified_at, pickup_notified_at,
  stale_notified_at`). Restart-safe.
- **Mnemo save:** `POST artforge:50001/writeback` with `session_id =
  bus-{id}-{iso}` (or `bus-reply-{id}-{iso}` for replies). Recallable by
  tracking_id within seconds.
- **CC startup hook:** `~/github/sparks-brain/hooks/bus-pending.sh` prints
  any unread CC bus messages at session start. Silent when none.
- **Settings:** appended to SessionStart command in `~/.claude/settings.json`.
- **Backup before ALTER:** `~/.sparks/bus.sqlite.bak-20260422-070553`.
- Pre-existing 27 rows backfilled with sentinel `mnemo_saved_at='backfilled'`
  to suppress retro notifications.
- **Deferred:** Opie's startup hook (Guy handing to Opie). BW channel
  `bw-tasks` not in `discord-channels.json` (stale JSON, not a real bug —
  delivery already works). Out of scope.

Full session log in `~/github/sparks-brain-guy/brain/cc-session.md` (Session 10).

---

## Kickstart — Next Session (probably 2026-04-22)

### Rocky's Gallery is LIVE
**https://rockysgallery.com** — public, buyable, no password gate.

Store state:
- **21 products** across 5 `$6` collections (WMS, Cathedral Forests, Black Line, Storm Bloom, Natural)
- **1 active `$25` 1/1 drop**: Spoon on Linen (`/products/spoon-on-linen-1-of-1`, live as of ~19:20 UTC April 21)
- **3 empty collections** (Altar, Cartography of Nowhere, Monochrome Flora) — populate only when 1/1 drops expire to $6

### 1/1 Drop System — BUILT + RUNNING
Full auto-rotation. Queue at `~/shopify/rockys-gallery/1of1-queue/queue.json`.
Current queue: Isola Minore → Olive Branch → Dried Thistle → Braided Delta → Dried Protea v2.

**Scripts at `~/shopify/rockys-gallery/scripts/`:**
- `one_of_one.py` — state layer (queue, active, sold/expired logs, file lock, Discord alert helper)
- `rotate.py` — core engine: `promote_next` / `retire_sold` / `demote_expired` / `sweep_expired`
- `poll_sales.py` — 5-min cron polls Shopify for paid `tag:1of1` orders, calls retire_sold
- `watermark.py` + `apply_watermarks.py` — diamond crosshatch watermark pipeline
- `gallery_api.py` + `fileflare.py` — API helpers

**Crons (in user crontab):**
- `*/15 * * * *` rotate.py sweep — 24h expiry sweep
- `*/5 * * * *` poll_sales.py — sales detection

**Rotation flow (sold case):**
poll_sales detects paid tag:1of1 → rotate.retire_sold → archive product, log sale, update metafields, promote_next from queue → Discord alert to #cc-log

**Rotation flow (expiry case):**
cron sweep → rotate.demote_expired → price $6, tags swap, product stays ACTIVE in target collection → promote_next → Discord alert

**End-to-end NOT YET TESTED in production.** Spoon on Linen is live at $25, needs first real sale or 24h-expiry to verify full rotation.

### Key doctrines learned/applied today
- **Watermark density LOCKED at** `spacing=100px, line_width=1px, alpha=70/255` — Guy approved "lighter" over "dense"
- **Fileflare chunked S3 upload** (POST /assets/signed → PUT chunks → POST /assets/:id/uploaded → POST /assets/:id/attach). POST not PUT for the "uploaded" step (docs inconsistent).
- **Sold 1/1 = truly gone.** Never resold. Not even at $6. Expired 1/1 = demoted to $6, that's the ONLY path to $6 for a drop.
- **`/pages/one-of-one` template is parked.** Metafield-in-Liquid access was fighting Shopify render cache for hours. Workaround: "Today's Drop" nav link goes straight to `/products/spoon-on-linen-1-of-1`, which has the scarcity copy in its description.
- **Real webhook deferred.** Polling every 5 min is the current production path.

### Theme aesthetic — overhauled 2026-04-21
- **Typography:** Fraunces 600 for headings, Fraunces 500 for subheadings, Inter 400 for body
- **Palette:** warm paper (#F8F3ED) + deep warm charcoal (#1A1816) + ember red accent (#C03A1B — echoes the watermark)
- **Schemes 1-3** updated to graduated paper tones (paper, soft paper, deeper cream)
- Scheme 6 (hero overlay) kept dark

### Shopify storefront render cache — KNOWN PAIN
Template/section changes take 10-60 min to flow through the rendered HTML. Individual product pages update faster than `/` or `/pages/*`. Do not blame cache as an excuse, but know it's real.

### Paths Guy will care about
- **Store admin:** https://admin.shopify.com/store/yjjp1h-a6
- **Live store:** https://rockysgallery.com
- **GALLERY-STATUS.md** at `~/shopify/rockys-gallery/` — living doc (not yet updated to reflect 1/1 system; TODO)
- **Fileflare dashboard:** https://app.digital-downloads.com (Guy has it bookmarked, has API key)

### Bot testbed mandate
Rocky's Gallery is BOTH a revenue store AND a testbed for Triage Nurse / Store Doctor. When we deploy those, plant edge cases here first (mispriced products, stale data, broken descriptions) and measure what the bots catch. Lab-notebook doc TBD.

### Passport Lane — still parked
`mnemo-cortex/passport/` — Phase 1.5 shipped April 18, corpus loaded April 19, baseline 48% / macro-F1 0.428. Tuning conversation with Opie pending. Strategic direction locked: normal users first, enterprise later. See `sparks-brain-guy/brain/projects/products/mnemo-passport.md`.

---

## In Progress

- [x] **Rocky's Gallery LIVE** (2026-04-21 afternoon)
- [x] **1/1 Drop System shipped** — rotation engine, queue, polling cron, Discord alerts, watermark pipeline, Fileflare chunked upload
- [x] **21 products watermarked** at lighter density (100/1/70)
- [x] **Theme aesthetic overhaul** — Fraunces serif + warm paper + ember red
- [x] **Meta title/description + og:image + collection hero images** — all set
- [ ] **Passport Phase 1.5 corpus tuning** — two policy tweaks proposed, awaiting Opie's call: bucket_defaults (untrusted_web→review_required, semi_trusted_remote→allow) + insufficient_evidence→review_required
- [ ] **Rocky's Gallery — Shopify CSR Portal** — separate product, not touched today

## Outstanding polish (tomorrow if desired)

- Collection page layout (make it more gallery-index, less e-commerce grid)
- Product page typography/whitespace refinement
- Custom CSS asset for finer opinionated moves beyond theme settings
- `/pages/one-of-one` template — when the metafield/render fight can be debugged
- Real Shopify webhook (replace polling)
- Homepage hero: currently Aisle, could rotate with the 1/1 once metafield renders work

## Hoffman Bedding — GMC still in cool-down
No movement today. Re-appeal when April confirms cool-down is over.

## Scripts Guy should know exist
- `~/shopify/rockys-gallery/scripts/rotate.py status` — show queue depth + active drop
- `~/shopify/rockys-gallery/scripts/one_of_one.py queue list` — list queued pieces
- Queue files: `~/shopify/rockys-gallery/1of1-queue/*.json`
