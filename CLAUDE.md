# Sparks Brain — Operating Instructions

You have a persistent memory system in the `brain/` directory. Use it.

## Session Start

Read the brain files relevant to your current task:
- **Always read**: `active.md` (know what's in progress)
- **For debugging/fixes**: `incidents.md` (check if this was solved before), `stack.md` (know the infrastructure)
- **For new features**: `patterns.md` (follow established conventions), `stack.md` (know what exists)
- **For collaboration**: `people.md` (know who's involved)
- **For infrastructure work**: `machines.md` (know the topology)

Don't read everything every time. Read what's relevant. Be efficient.

## During the Session

Work normally. Code, debug, build. The brain doesn't change your workflow.

**But pay attention to what you learn.** If you discover something that future sessions would benefit from — a bug pattern, a configuration gotcha, a codebase convention, a completed task — hold onto it.

## Session End — Update the Brain

Before the session ends, review what you learned and update the relevant brain files.

### What to Write

**incidents.md** — Any bug or issue that took real debugging effort:
```markdown
## [Short descriptive title]
**Date:** YYYY-MM-DD
**Symptom:** What you observed
**Cause:** What was actually wrong
**Fix:** What you did
**Prevention:** How to avoid this in the future
```

**patterns.md** — Conventions you discovered or established:
```markdown
## [Pattern name]
[What the pattern is, when to use it, why it exists]
```

**active.md** — Update project state:
- Mark completed items as done
- Add new items that emerged
- Update blockers
- Adjust priorities based on what you learned

**stack.md** — New services, changed configs, updated dependencies:
```markdown
## [Service/Tool name]
- **Version:** x.x.x
- **Port:** XXXX
- **Config:** /path/to/config
- **Notes:** [anything CC needs to know]
```

**machines.md** — Infrastructure changes, new hostnames, network changes.

**people.md** — New collaborators, updated roles, relevant context.

### What NOT to Write

- Routine code changes (that's what Git history is for)
- Temporary debugging notes (only write lasting insights)
- Opinions or speculation (write facts and decisions)
- Sensitive credentials (never put secrets in brain files)

### How to Write

- Be concise. Future-you is scanning, not reading novels.
- Be specific. "Fixed the auth bug" is useless. "Fixed token refresh race condition in /api/auth/callback — the refresh was firing before the previous token was invalidated" is useful.
- Date everything in incidents. Context decays.
- Use headers and structure consistently so files stay scannable.

## Commit Convention

When updating brain files, commit with this format:

```
brain: [brief description of what was learned/updated]
```

Examples:
```
brain: added runbook for postgres connection pool exhaustion
brain: updated stack.md with new redis cache config
brain: marked authentication refactor as complete in active.md
brain: documented naming convention for API route handlers
```

Group related brain updates into a single commit when possible. Don't pollute the history with micro-updates.

## Rules

1. **Never delete history from incidents.md.** Old incidents are still valuable. Add new ones at the top.
2. **Keep active.md current.** This is the most-read file. If it's stale, the brain is stale.
3. **Be honest about what you don't know.** If you're uncertain about something, say so in the brain file. "Vapor Truth" — no covering up gaps.
4. **Don't bloat the files.** If a brain file exceeds ~500 lines, consider splitting it into sub-files. The brain should be fast to read.
5. **Scream on failure.** If you can't read or update a brain file, tell the user. Never silently skip a brain update.
