# Sparks Brain

**A self-maintaining memory system for Claude Code.**

CC reads your brain at session start. Learns during the session. Writes back what it discovered. Commits to Git. Next session — on any machine — that knowledge is there.

No database. No vector store. No SaaS. Just markdown and Git.

---

## The Problem

Every Claude Code session starts the same way:

> "We're using Next.js with Prisma..."
> "The auth is magic-link based..."
> "Last time we fixed the VPN middleware..."

You are the memory. The human context window. And it's exhausting.

## The Fix

Sparks Brain gives CC a structured set of markdown files it reads automatically. But unlike static docs, **CC writes back**. It fixes a gnarly bug? It logs the incident. It discovers a convention? It notes the pattern. It finishes a sprint? It updates the project state.

Your AI's memory compounds over time — through Git.

```
git log --oneline brain/incidents.md
a3f8b2c CC: added runbook for postgres connection pool exhaustion
7d1e4a9 CC: documented the silent env var ordering bug
2c8f3b1 CC: first session — baselined infrastructure
```

That's your AI's memory, version-controlled, reviewable, portable across machines.

---

## Quick Start

**60 seconds. One command.**

```bash
# Clone into your project (or home directory)
git clone https://github.com/GuyMannDude/sparks-brain.git .brain
cd .brain

# Run the setup — it walks you through it
chmod +x setup.sh
./setup.sh
```

The setup script:
1. Creates your brain files from templates
2. Adds a reference to your project's `CLAUDE.md` (creates one if needed)
3. Initializes Git tracking

Then start a CC session. That's it. CC reads the brain, works with you, and updates what it learns.

---

## What's In the Brain

```
sparks-brain/
├── CLAUDE.md            # CC's operating instructions (how to use the brain)
├── brain/
│   ├── machines.md      # Hardware, servers, hostnames, network topology
│   ├── stack.md         # Tech stack, services, ports, dependencies, configs
│   ├── incidents.md     # Bug runbooks — what broke, why, how it was fixed
│   ├── patterns.md      # Coding conventions, architectural decisions, preferences
│   ├── active.md        # Current sprint, priorities, blockers, next actions
│   └── people.md        # Collaborators, roles, contact context
├── setup.sh             # One-command setup
└── README.md
```

Each file has a clear purpose. CC knows what goes where. You can add files for your own categories — CC will discover and use them.

---

## How It Works

### Session Start
CC reads `CLAUDE.md` which points to the `brain/` directory. It loads the relevant files based on what you're working on. No cold start. No re-explaining.

### During the Session
You work normally. CC codes, debugs, builds. Nothing changes about your workflow.

### Session End (the magic)
CC reviews what it learned and updates the brain:
- New bug fix? → `incidents.md` gets a runbook entry
- Discovered a codebase pattern? → `patterns.md` gets updated
- Finished a task? → `active.md` gets current
- New service deployed? → `stack.md` reflects reality

CC commits with descriptive messages prefixed with `brain:` so you can filter them.

### Next Session
CC pulls the brain. Starts with full context. The knowledge compounds.

---

## Two Modes

### Solo Mode (most developers)
CC maintains its own brain. Self-contained loop. You code, CC remembers.

```
┌─────────────────────────────────────┐
│              Git Repo               │
│  ┌───────────┐    ┌──────────────┐  │
│  │   Brain   │◄──►│  Claude Code  │  │
│  │   Files   │    │  (reads +    │  │
│  │           │    │   writes)    │  │
│  └───────────┘    └──────────────┘  │
└─────────────────────────────────────┘
```

### Tandem Mode (multi-agent setups)
A planning AI (Claude chat, ChatGPT, etc.) handles architecture and strategy. CC handles execution. Both write to the same brain through Git.

```
┌──────────────────────────────────────────┐
│                 Git Repo                 │
│  ┌───────────┐                           │
│  │   Brain   │◄── Planning AI writes     │
│  │   Files   │    architecture/strategy  │
│  │           │                           │
│  │           │◄── Claude Code writes     │
│  │           │    fixes/discoveries      │
│  └───────────┘                           │
└──────────────────────────────────────────┘
```

---

## Brain File Reference

### `machines.md`
Your hardware topology. Hostnames, IPs, what runs where, SSH configs, network quirks.

### `stack.md`
Every service, tool, and dependency. Versions, ports, config file locations, API endpoints. The stuff you constantly re-explain.

### `incidents.md`
The runbook. Every bug that cost you time, documented so it never costs you time again. Format: what happened → why → how it was fixed → how to prevent it.

### `patterns.md`
How your codebase works. Naming conventions, architectural decisions, file organization, testing patterns, deployment procedures. The tribal knowledge.

### `active.md`
Living document. Current sprint, what's in progress, what's blocked, what's next. CC updates this as work completes.

### `people.md`
Collaborators and their context. Who owns what, who to ask about what, communication preferences. Keeps CC from being clueless about your team.

---

## Customizing

Add any `.md` file to `brain/` and CC will discover it. Some ideas:

- `clients.md` — client-specific context for agency/freelance work
- `apis.md` — external API quirks, rate limits, auth patterns
- `deploy.md` — deployment runbooks and environment configs
- `decisions.md` — architectural decision records (ADRs)
- `debt.md` — known tech debt and remediation plans

---

## Philosophy

**Memory should compound, not reset.** Every session should make the next one better.

**Git is the right backend.** Version history, branching, diffing, sync across machines — developers already have this infrastructure. Why build something else?

**AI should maintain its own memory.** You shouldn't be the human context window. CC learns, CC writes it down, CC remembers.

**Scream on failure, not silence.** If CC can't find or update a brain file, it says so. No silent degradation.

---

## Inspiration

The idea that AI assistants need persistent, compounding memory was articulated beautifully by [Nate B. Jones](https://natesnewsletter.substack.com/) in his Open Brain system. Sparks Brain adapts that philosophy specifically for developers using Claude Code — replacing vector databases and cloud services with markdown and Git.

---

## License

MIT — use it, fork it, make it yours.

---

*Built by [Project Sparks](https://projectsparks.ai) — a creative technology studio in Half Moon Bay, CA.*
