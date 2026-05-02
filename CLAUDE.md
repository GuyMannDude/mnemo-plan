# mnemo-plan — Operating Instructions

You have a persistent project pad in this directory. Read what you need at the start of a session; write back what's worth keeping at the end.

## Session start — what to read

Don't read everything every time. Read what's relevant to the task you've been given:

- **Always**: `active.md` — know what's in progress, what's blocked, what's queued.
- **If `agent-lanes/<your-name>.md` exists**: read it. Your personal continuity — identity, current focus, open threads. (Multi-agent setups only.)
- **If `projects/<topic>.md` exists for the task**: read it. Shared cross-agent state — what other agents have done, decided, or shipped. (Multi-project setups only.)
- **For new features or refactors**: `project.md` (scope), `stack.md` (what exists), `decisions.md` (what was already chosen).
- **For debugging**: `incidents.md` (was this seen before?), `stack.md` (where it lives).
- **For collaboration / handoff**: `people.md` (who else is in the loop).

The `read_brain_file` MCP tool is what gets you these. `list_brain_files` shows what's actually here.

## During the session — what to notice

Work normally. The brain doesn't change your workflow.

**But pay attention to what you learn.** If you hit a configuration gotcha, finish a task, make a non-obvious decision, or discover a pattern that will matter next time — hold onto it.

## Session end — what to write back

Use `write_brain_file` to update the relevant file:

- **Finished a task** → mark it done in `active.md`.
- **Made a non-obvious decision** → log it in `decisions.md` with the reason.
- **Found a bug pattern or hit a configuration trap** → write it up in `incidents.md`.
- **Changed the infrastructure** → update `stack.md`.
- **Started something new** → add it to `active.md`.
- **Touched a project that has its own file in `projects/`** → update that project's file (Last updated header + affected sections).
- **Closing your session** → update your own `agent-lanes/<your-name>.md` (if you have one): bump the date, note what you changed.

Keep entries short. Future-you will thank present-you for terse, well-named sections.

**Optional: structured task lines.** When tasks have dependencies, multi-agent handoff, or human-gate review, promote them from plain bullets to the structured form documented in [THE-LANE-PROTOCOL.md § Task structure](THE-LANE-PROTOCOL.md#task-structure-optional). Shape: `- [ ] [task:slug] (assignee, state:label, [blocks/blocked-by:slug]) Description`. Untagged bullets stay valid for trivial work.

When you're done writing, **commit and push** so other machines and other agents see your updates next time:

```bash
bash scripts/sync.sh                       # default message
bash scripts/sync.sh "wrap: shipped X"     # custom message
```

(Or run `git add -A && git commit -m "..." && git push` directly — `sync.sh` is just a wrapper.)

## Doctrines (rename / extend / delete this section to match your project)

These are values that should outlive any single session:

- **Truth over face-saving.** When you don't know something, say so. When something broke, say what broke. Future sessions need accurate state, not optimism.
- **Read before writing.** Check if the topic already has a section before adding a new one. Don't fragment.
- **Short over comprehensive.** Three crisp lines beat a paragraph nobody will re-read.

---

*Customize this file for your own workflow. The bridge doesn't enforce any of it — these are just the guardrails this template starts with.*
