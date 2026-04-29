# mnemo-plan

> The manual project pad for the [Mnemo Cortex](https://github.com/GuyMannDude/mnemo-cortex) ecosystem.

**Mnemo Cortex** captures conversation memory automatically — what agents said, what happened, what was decided.

**mnemo-plan** is the opposite: the stuff *you* write and curate. Project specs. Active task lists. Decision logs. Architecture docs. Anything an agent needs to know **before** a conversation starts.

> **For the operating practice that goes with this template, see [THE-LANE-PROTOCOL.md](THE-LANE-PROTOCOL.md).** The structure tells you what files to have. The protocol tells you how to live in them.

It's just a folder of markdown files in a Git repo. Any LLM that can call the Mnemo MCP tools `read_brain_file` / `write_brain_file` / `list_brain_files` can read and edit them. Not Claude-specific.

## How to use this template

1. **Fork or clone this repo** somewhere your machine can reach.
2. **Edit the files** to reflect your actual project. Each template starts with a comment explaining what goes there.
3. **Point your Mnemo MCP bridge at it** by setting the `BRAIN_DIR` environment variable in your MCP config:
   ```json
   {
     "mcpServers": {
       "mnemo-cortex": {
         "command": "node",
         "args": ["/path/to/mnemo-cortex/integrations/openclaw-mcp/server.js"],
         "env": {
           "MNEMO_URL": "http://localhost:50001",
           "MNEMO_AGENT_ID": "your-agent-id",
           "BRAIN_DIR": "/absolute/path/to/your/mnemo-plan"
         }
       }
     }
   }
   ```
4. **Restart your agent.** It now sees `read_brain_file`, `write_brain_file`, and `list_brain_files` in its tool list, scoped to your `BRAIN_DIR`.

When the bridge detects `BRAIN_DIR` on disk, it auto-enables those tools. No flag, no switch. If the directory doesn't exist, the tools silently don't register.

## What's in the template

| File | Purpose |
|---|---|
| `project.md` | Top-level project overview. What you're building, why, what's done. |
| `active.md` | Current work. In-progress, blocked, queued, recently completed. |
| `stack.md` | Infrastructure and setup notes. Where things run. How they connect. |
| `decisions.md` | Decision log. What you chose, why, what you ruled out. |
| `people.md` *(optional)* | Collaborators, agents, roles. Who's involved. |
| `incidents.md` *(optional)* | Bug history. What broke, what you found, what you fixed. |
| `agent-lanes/` *(multi-agent)* | One file per agent. Personal "who am I, what's current for me." Owned by the named agent. |
| `projects/` *(multi-project)* | One file per project. Shared cross-agent state for projects that multiple agents touch. |
| `scripts/sync.sh` | Optional helper — `bash scripts/sync.sh` to commit + push the brain at session end. |
| `CLAUDE.md` | Operating instructions for the agent reading this brain. |
| `hooks/` | Optional shell hooks for Claude Code session start/end. |

Edit, rename, delete, add. The bridge just lists `*.md` files — there's no schema enforcement. Use what helps your project.

## Multi-agent and multi-project

Two patterns scale the brain when one project / one agent isn't your reality:

**`agent-lanes/`** — Each agent gets its own personal file (`agent-lanes/cc.md`, `agent-lanes/opie.md`, `agent-lanes/builder.md`). Identity, current focus, open threads. Read your own lane at session start; update it before closing. Other agents shouldn't edit your lane — that's what shared project files are for.

**`projects/`** — Each project gets its own shared file (`projects/hoffman.md`, `projects/website.md`). Any agent on that project reads and updates the same file. One source of truth for project state across agents — no drift between Opie's view and CC's view.

Together they replicate the rule "**state at the top, rewritten — Mnemo for the why, Git for the who/when**." Personal lanes are owned. Project lanes are shared. Decisions go to `decisions.md` or to Mnemo memory. Don't let any of these become diaries.

For solo / single-project use, just use the root files (`project.md`, `active.md`, `decisions.md`) and skip the subdirectories. Remove what you don't need.

## Sync — pull at start, push at end

The `scripts/sync.sh` helper is a thin wrapper: `git add -A && git commit -m "..." && git push`, with a `git status` echo so failures are visible. Manual, not automated — run it deliberately at session end.

```bash
bash scripts/sync.sh                         # default commit message
bash scripts/sync.sh "wrap: shipped X feature"   # custom message
```

Pull at session start (`git pull`) to pick up updates from another machine or another agent. Brain transfer between home/work, between humans, or between agents = a fork or a clone away.

## Why a separate folder instead of a single file

Agents read selectively. Asking for `active.md` is cheaper than parsing a 200-page combined doc. The split also makes Git diffs readable and lets multiple humans / agents edit different files without merge conflicts.

## Why Git instead of a database

Version history. Branches. Pull requests. Diff-based collaboration with humans. A file is the universal interchange format — no migrations, no API, no schema. Cat it, edit it, commit it.

## License

MIT. Take it, fork it, do whatever.

---

*Part of the [Mnemo Cortex](https://github.com/GuyMannDude/mnemo-cortex) ecosystem by [Project Sparks](https://projectsparks.ai).*
