# Incidents

The runbook. Every bug that cost real debugging time, documented so it never costs time again.

**New incidents go at the top.** Never delete old ones — they're still valuable context.

---

## Sparky gateway device identity error
**Date:** 2026-03-23 (ongoing)
**Symptom:** Sparky gateway failing with device identity error. Gateway cannot route correctly.
**Cause:** Under investigation.
**Fix:** TBD — active blocker.
**Prevention:** TBD.

## Sparky/Mnemo pod network isolation
**Date:** 2026-03-23 (ongoing)
**Symptom:** Sparky (inside NemoClaw pod) cannot reach mnemo-cortex on THE VAULT at port 50001.
**Cause:** NemoClaw pod network isolation blocks host port access by default. The pod is sandboxed and cannot see host services.
**Fix:** Pending — need drop-in YAML network policy presets via NemoClaw Compatibility Spec to allow pod→host traffic on port 50001.
**Prevention:** Any new service that needs pod↔host communication must have a network policy preset added to NemoClaw before deployment.

## Heartbeat cost leak
**Date:** 2026-03-23 (ongoing)
**Symptom:** Cron job heartbeat burning ~$2.40/day in OpenRouter credits.
**Cause:** Heartbeat cron job runs on the `main` agent without a model override, so it defaults to Gemini Pro instead of using the free Nemotron tier.
**Fix:** Pending — need OpenClaw per-session model override to force heartbeat to free tier.
**Prevention:** Any cron/scheduled agent call must specify an explicit model override. Never let scheduled jobs default to paid models.

## CC denied NemoClaw's existence
**Date:** 2026-03-23
**Symptom:** CC (Opie) told Guy that NemoClaw doesn't exist and there's no such NVIDIA project.
**Cause:** CC searched for `github.com/NVIDIA/NemoClaw` (wrong — NemoClaw is an npm package, not an NVIDIA GitHub repo). CC didn't check the actual install path on THE VAULT before declaring it fake.
**Fix:** Verified NemoClaw v0.1.0 installed at `~/.npm-global/bin/nemoclaw` on THE VAULT with active `sparks-nemo` sandbox processes. Apologized. Updated brain.
**Prevention:** Always check the actual system before declaring something doesn't exist. Vapor Truth means verifying, not guessing.

## Billing firehose — sessionMemory + memoryFlush
**Date:** 2026-03-16
**Symptom:** OpenRouter credits burning while idle. 66 embedded agent runs/hour.
**Cause:** Two OpenClaw settings were generating excessive API calls:
  - `memorySearch.experimental.sessionMemory` — 66 embedded agent runs/hour
  - `compaction.memoryFlush` — secondary token burner
**Fix:** Disabled both settings in OpenClaw config. Also found and fixed same bug in THE VAULT host config (discovered 2026-03-23 per Rocky).
**Prevention:** Audit any experimental/polling settings for cost before enabling. Monitor OpenRouter dashboard after config changes.

## Zombie mnemo-cortex process on IGOR
**Date:** 2026-03-16
**Symptom:** Requests from IGOR to mnemo-cortex were being intercepted locally instead of reaching THE VAULT (artforge:50001).
**Cause:** A mnemo-cortex v2.0 process was running on IGOR at localhost:50001, shadowing the remote service on THE VAULT.
**Fix:** Killed the local process. Patched handler.ts. Permanently removed the pipx mnemo-cortex binary from IGOR.
**Prevention:** No mnemo-cortex process should ever run on IGOR. If `curl localhost:50001` responds on IGOR, something is wrong. The canonical server is always `artforge:50001`.

---

*The first time CC fixes a non-trivial bug, it adds it here. Newest at top.*
