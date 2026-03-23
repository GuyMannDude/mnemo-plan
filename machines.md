# Machines

Your hardware topology. Hostnames, roles, network details, and quirks that CC needs to know.

<!-- 
  Fill this in with your actual machines. Example entries below.
  Delete the examples and replace with your own.
-->

---

## Example: Dev Laptop
- **Hostname:** dev-laptop
- **OS:** Ubuntu 24.04
- **Role:** Primary development machine
- **Key paths:**
  - Projects: `~/projects/`
  - Scripts: `~/scripts/`
- **Notes:** Claude Code runs here. Main workspace.

## Example: Server
- **Hostname:** homeserver
- **IP:** 192.168.1.100 (local) / accessible via Tailscale
- **OS:** Ubuntu 22.04
- **Role:** Runs databases and background services
- **Key specs:** 64GB RAM, 12-core
- **Services:** PostgreSQL (5432), Redis (6379), Ollama (11434)
- **Notes:** Network hostname resolves via Tailscale. SSH key-based auth only.

---

*Delete everything above and add your own machines. CC will keep this updated as infrastructure changes.*
