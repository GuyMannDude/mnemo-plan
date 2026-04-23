# Active

What's happening right now. Current work, priorities, blockers, next actions.

**Last updated:** 2026-04-22 (late evening)

## Rocky on OpenClaw 2026.4.20 + Google Drive read-only — SHIPPED 2026-04-22

- **OpenClaw 2026.4.20** live on IGOR (`openclaw --version` + running gateway pid 166556). Four cascading incidents hit + logged in `incidents.md`: jiti cache crash-loop (self-healed), `/tmp/jiti` root-perms, `dist/extensions/*/node_modules` root-perms, stale `sparks-bus-mcp` MCP path in `openclaw.json`. Recipe for future upgrades captured in the incident entry.
- **DeepSeek confirmed active** — Guy switched via OpenClaw's `/model` picker (Switch is bypassed for Rocky). Rocky saved a real Mnemo memory (`faefd3c133e43121`) during verification, confirming end-to-end.
- **Google Drive (read-only)** wired as MCP subprocess for Rocky using `@modelcontextprotocol/server-gdrive` (archived but stable). Scopes granted, token at `~/.openclaw/google/.gdrive-server-credentials.json` mode 600. Account `guitarmanndude69@gmail.com`. Tools: `gdrive_search`, `gdrive_read`. No write, no Docs/Sheets edits — matches "read-only first" rule. **Future swap:** Google's official remote MCP launched same day; migrate when docs firm up.
- **Claude Desktop MCP config drift** (Opie's `opie_startup` missing + Sparks-Bus disconnected) both fixed, Desktop relaunched, all MCPs healthy.
- **Developer's Passport v2.4.1** shipped (rename + policy tweaks + 53.0% / 0.458 eval + PR #2315 for NemoClaw mnemo-cortex preset).
- **Pinned v0.0.22** of NemoClaw is the upstream tag we'd upgrade Sparky to once PR #2315 merges. Sparky upgrade still parked.
- **OpenClaw 2026.4.21** dropped during this session — staying on .20, letting it settle. Recipe for .21 bump ready when wanted.
- **Guy Hutchins** (not Hoffman) — fixed in mnemo-cortex pyproject.toml + CONTRIBUTING.md. Memory saved.

**Parked idea — Passport CLI companion (2026-04-22):** Guy raised the question of shipping Passport as a CLI alongside MCP (someone in a video argued CLI over MCP for most use cases). CC research: all 5 Passport tools are stateless CRUD — textbook CLI shape, ~60-line wrapper over the existing Python module. Wins: scriptable, cronable, pipeable, zero context overhead for non-using agents, works in any shell-equipped agent. Loses: tool auto-discovery, cuts off Claude Desktop (no shell). **Build trigger:** ship the CLI when ONE of these is true — (a) Guy wants to script against Passport from cron/bash hooks, (b) a new agent platform shows up without MCP support, (c) public users ask for non-MCP integration. Until then, MCP covers real need.

**Next session first moves:**
- Test Rocky's gdrive tools in UI (ask Rocky to search a known Drive file).
- Check PR #2315 review status at https://github.com/NVIDIA/NemoClaw/pull/2315.
- **PR #2315 signing deferred:** CodeRabbit approved, zero comments, merge-blocked only on "verified signatures." Guy attempted to add SSH Signing Key 2026-04-22 evening but hit Pixel 2FA trouble + a despaced-key paste error. Recovery codes found at `~/Downloads/github-recovery-codes.md` (16 codes confirmed format). Pickup: register `~/.ssh/id_ed25519.pub` at https://github.com/settings/ssh/new as **Key type = Signing Key** (paste must keep the two mandatory spaces in `ssh-ed25519 AAAA... rocky@igor`). Then CC amends commit at `/tmp/NemoClaw` with author `Guy Hutchins <guy@projectsparks.ai>` (local-repo config only, not global), SSH-signs, rebases on `origin/main`, force-pushes `mnemo-cortex-preset` branch on `GuyMannDude/NemoClaw`.
- If Rocky runs clean for 24+h on .20, bump to .21 using the documented recipe (sudo npm install + two chowns + daemon-reload + restart).
- Sparky NemoClaw upgrade: gated on PR #2315 merging upstream.

---


---

## Developer's Passport v2.4.1 — SHIPPED 2026-04-22

Rebrand + policy tweaks + docs release. Product now positioned as
dev-targeted beta, not a normal-user product. Possessive in the name
is deliberate — drops when hosted / browser-AI story ships.

**What landed (mnemo-cortex commit `14834ba`, pyproject 2.4.1):**
- Policy tweaks applied: `semi_trusted_remote → allow`, `untrusted_web → review_required`, new `insufficient_evidence → review_required`. validation.py now reads insufficient_evidence from policy instead of hard-coding hard_block.
- Eval moved 48.0% / 0.428 → **53.0% / 0.458** (+5pp). F1: `allow` +0.251, `review_required` +0.089, `hard_block` +0.027, `local_only` -0.246 (tradeoff from raising untrusted_web floor — those cases now land at review_required).
- passport/README.md rewritten (UNDER CONSTRUCTION banner gone, 5-tool table corrected, 5-minute dev quickstart verified end-to-end, honest Known Gaps section).
- Top-level README.md, CAPABILITIES.md, CHANGELOG.md updated with Developer's Passport framing.
- Eval harness (`tests/passport/corpus_score.py`, `corpus_migrate.py`) in repo.

**Landing page** (projectsparks-site commit `566fd34`, deployed):
- `projectsparks.ai/mnemo-cortex` Passport section renamed to Developer's Passport, callout copy reframed around safety machinery, meta/og/twitter descriptions updated, `TODO` comment marks the rename as intentional for future full release.

**Infra changes on artforge:**
- `~/.mnemo/passport/policy.yaml` synced to tweaked values.
- uvicorn at 50001 restarted (pid 415966). Old pid was 2732068, running since April 18 with cached pre-tweak policy.
- **Patched `agentb-bridge/agentb_mcp.py`**: the FastMCP constructor fails at startup when `MNEMO_OAUTH_*` env vars aren't set because `verifier` was built unconditionally while `_auth_settings` was None — mcp 1.27.0 rejects that combo. Surgical fix: `token_verifier=verifier if _auth_settings else None`. Backup at `agentb_mcp.py.bak-pre-oauth-conditional-2026-04-22`.
- Smoke test: `/passport/context` returns empty-claim structure; `/passport/pending` returns obs_001 + obs_003 (the two retained entries).

**Held out of repo — decision: available on request:**
- 200-entry eval corpus YAMLs (tests/passport/corpus/{benign,toxic,edge,adversarial}.yaml). GitHub secret-scanning rejected push because toxic.yaml contains fake-but-well-formed Slack tokens used as detector training bait. CHANGELOG + README note that corpus ships on request.

**Pending cleanup (still in queue):**
- obs_005–014 (Opie's speculative seed round from earlier today) — WIPED from artforge pending queue before release work started.
- obs_002 (wrong claim — Guy does NOT want confirmation prompts) and obs_004 (dup of obs_003) — FORGOTTEN earlier in session per Guy's direction.
- obs_001 + obs_003 remain in pending; Guy can promote or forget at leisure.

**Parked (not shipping — ditch-or-revive based on demand):**
- Chrome extension (mnemo-passport-ext) — was briefly explored as the "take your AI with you" vehicle. Pivoted away: Mnemo is already an MCP server, browser AIs are the real target.
- claude.ai custom connector via HTTP MCP wrapper — needed because Mnemo's port 50001 is REST, not MCP protocol. Needs: FastMCP HTTP wrapper + Cloudflare Tunnel to `mnemo.projectsparks.ai` (or similar) + bearer/OAuth auth. 1–2 days of build work. Parked until a real user for the browser path shows up.
- Platform reality check for reference: Claude.ai supports user-configured remote MCP (Settings → Connectors), ChatGPT requires Developer Mode and is read-only for Plus/Pro (write-capable only on Business+), Gemini consumer web has no MCP UI at all (CLI + API + Enterprise only).

**First moves next session:**
- If browser-AI interest returns: start with Claude.ai-only, FastMCP HTTP wrapper exposing `passport_get_user_context` only, Cloudflare Tunnel. Don't over-scope.
- If corpus-shipping approved: either (a) click GitHub's unblock URL (`/security/secret-scanning/unblock-secret/3CjQ0iqbUupe20LaNiLcWjG89Cf` on mnemo-cortex), (b) obfuscate fake tokens in corpus YAMLs, or (c) leave held-on-request.
- Opie doctrine drift noted earlier in session: he auto-dispatched observations without courier-through-Guy. Guy pulled the ball back to direct-to-CC for this release. If/when Opie returns to lead, re-enforce the assembly-line boundary.

---

## Mnemo Wiki Compiler — SHIPPED 2026-04-22 (PM)

Karpathy/Nate-Jones hybrid: Mnemo is source of truth, wiki is a compiled view
auto-generated from Mnemo each night. If they disagree, Mnemo wins. Manual
wiki edits get overwritten and warned. Doctrine recorded in the script header.

- **Compiler:** `~/github/mnemo-cortex/mnemo-wiki-compile.py` (committed `9c910d3`,
  pushed). 860 lines. Self-contained.
- **Pipeline:** harvest (AgentB writebacks + Mnemo SQLite) → cluster (Python,
  deterministic — no LLM routing) → compile (one gemini-2.5-flash call per
  topic) → cross-ref validate (no hallucinated wikilinks) → write with
  `.md.prev` rollback → regenerate `INDEX.md` → audit summary.
- **Topology:** Mnemo data lives on artforge; wiki master lives on IGOR
  (`/home/guy/wiki`, 3,145 files). Cron runs on artforge; nightly wrapper at
  `/home/guy/mnemo-wiki-nightly.sh` does: rsync IGOR→artforge → compile →
  rsync artforge→IGOR. Compiler-owned sections only: `projects/`, `entities/`,
  `concepts/`. The `sources/` section is owned by the file-inventory job and
  is NOT touched.
- **Cron:** `30 3 * * *` on artforge, 15 min after Dreaming finishes. SSH key
  artforge→IGOR set up (added artforge's `id_ed25519.pub` to IGOR's
  `authorized_keys`).
- **Smoke test:** `entities/guy.md` compiled live from 91 memories — dense
  Summary, dated Key Facts, chronological Timeline, 10 validated cross-refs.
  ~1.5s LLM call, ~$0.005. End-to-end rsync to IGOR confirmed.
- **Failure handling:** per-page isolation. One bad LLM call → ⚠️ to `#alerts`
  (reusing Sparks Bus token + channels file) → run continues. `delivery_failed`
  doctrine consistent with the bus.
- **Audit folded in:** every nightly logs counts of pages > 30d stale, < 3
  source memories, manually edited. No separate `--audit` flag.
- **Topic discovery deferred:** `concepts/` only updates pages that already
  exist (conservative, per Guy). `projects/` pages only birth from
  `projects_referenced` field. No noun-phrase auto-discovery yet.
- **Flags:** `--dry-run --verbose` (cluster + plan, no LLM); `--days N`;
  `--topics section/slug,...`; `--full` (all-time, expensive — sparingly).

## Sparks Bus — Repo Package SHIPPED 2026-04-22 (PM)

Standalone-capable package now lives in `~/github/mnemo-cortex/sparks_bus/`
(committed `92af388`, pushed). 17 files: watcher, schema, config examples,
A2A agent cards (CC/Rocky/Opie/BW/Cliff), systemd unit, README, SETUP-PROMPT,
A2A mapping doc.

- **Two modes auto-detected at startup**: FULL (Mnemo reachable) or STANDALONE
  (payload travels in Discord notifications). Both verified end-to-end.
- **Phase 1 hardening folded in**: tuple-returning wakers, `delivery_failed_at`
  column for one-shot ⚠️ alerts, `BUS_*` env-var overrides for every config key.
- **A2A baked in**: `to_a2a_task()` translator in the watcher; 5 cards under
  `agent-cards/`; mapping reference in `A2A.md`. Transport (HTTPS/JSON-RPC) is
  v2 roadmap — data shape compat is in now.
- **Production watcher at `~/scripts/sparks-bus-watcher.py` is still the OLD
  one.** Migration is a one-liner: change systemd ExecStart to point at
  `~/github/mnemo-cortex/sparks_bus/sparks-bus-watcher.py` and restart. Holding
  on Guy's call.

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
