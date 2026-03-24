# NemoClaw Networking — Inspection Report

**Date:** 2026-03-23
**Sandbox:** sparks-nemo on THE VAULT (artforge)
**Status:** Recon only — no changes made

---

## Architecture

The infrastructure runs inside a single Docker container (`ghcr.io/nvidia/openshell/cluster:0.0.10`) that contains an embedded **k3s** Kubernetes cluster. Inside that cluster:

- **openshell-server** (gateway/API server, port 8080)
- **agent-sandbox-controller** (manages sandbox lifecycle)
- **openshell-sandbox** (per-sandbox sidecar, acts as network proxy at 10.200.0.1:3128)
- **coredns** (internal DNS at 10.43.0.10)
- **openclaw + openclaw-gateway** (the actual agent processes)

The sandbox pod gets its own network namespace with a veth pair (10.200.0.2/24). The `openshell-sandbox` sidecar sits at 10.200.0.1 and acts as both the default gateway and the HTTP(S) proxy. ALL outbound traffic is forced through it.

---

## 1. The Proxy (10.200.0.1:3128)

Not squid/nginx/envoy — it's **`openshell-sandbox`**, a single binary (14MB, Go/Rust) that acts as both the sandbox's default gateway and HTTP CONNECT proxy. It enforces the network allow-list inline with TLS MITM termination.

### Full Allow-List (all port 443 only)

| Policy | Destinations |
|---|---|
| `claude_code` | api.anthropic.com, statsig.anthropic.com, sentry.io |
| `nvidia` | integrate.api.nvidia.com, inference-api.nvidia.com |
| `github` | github.com, api.github.com |
| `clawhub` | clawhub.com |
| `openclaw_api` | openclaw.ai |
| `openclaw_docs` | docs.openclaw.ai |
| `npm_registry` / `npm_yarn` | registry.npmjs.org, registry.yarnpkg.com |
| `pypi` | pypi.org, files.pythonhosted.org |
| `telegram` | api.telegram.org |
| `discord` | discord.com, gateway.discord.gg, cdn.discordapp.com |

**Not in the list:** `host.docker.internal`, any port 50001, any private IP range.

---

## 2. Inside the Pod

### Proxy Environment

All traffic forced through proxy:
```
ALL_PROXY=http://10.200.0.1:3128
HTTP_PROXY=http://10.200.0.1:3128
HTTPS_PROXY=http://10.200.0.1:3128
NO_PROXY=127.0.0.1,localhost,::1
```

`NO_PROXY` does NOT include `host.docker.internal`.

### TLS MITM

Custom CA for proxy TLS termination:
```
CURL_CA_BUNDLE=/etc/openshell-tls/ca-bundle.pem
NODE_EXTRA_CA_CERTS=/etc/openshell-tls/openshell-ca.pem
SSL_CERT_FILE=/etc/openshell-tls/ca-bundle.pem
```

### DNS & Hosts

`/etc/hosts`:
```
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback
10.42.0.9       sparks-nemo
172.17.0.1      host.docker.internal    host.openshell.internal
```

`/etc/resolv.conf`: k3s CoreDNS at 10.43.0.10.

### Network

- Interface: `veth-s-d1eeb193` at `10.200.0.2/24`
- Default route: via `10.200.0.1` (the proxy)
- `host.docker.internal` resolves to `172.17.0.1` (Docker bridge)

### Connectivity Test Results (from inside pod)

| Test | Result |
|---|---|
| `curl http://10.200.0.1:3128` | Connected, **403 Forbidden** (proxy reachable, bare request denied) |
| `curl http://host.docker.internal:50001/health` | **403 Forbidden** (proxy intercepts and blocks) |
| `curl -x proxy http://host.docker.internal:50001/health` | **Empty response** (also blocked) |

---

## 3. Mnemo-Cortex on the Host

- **Listening:** `0.0.0.0:50001` (all interfaces) — Python process, pid 3882
- **Health:** `curl localhost:50001/health` → `{"status":"ok", "ollama_connected":true, ...}`
- **UFW rule:** `50001/tcp ALLOW IN 172.16.0.0/12` (comment: "mnemo-cortex from Docker/k3s")
- **iptables:** `ACCEPT tcp 172.16.0.0/12 → 0.0.0.0/0 dpt:50001`

**The host side is fully open.** Mnemo-cortex listens on all interfaces, firewall allows Docker subnets.

---

## 4. The Network Path & Where It Fails

```
Sparky process (10.200.0.2)
  → ALL_PROXY forces through proxy
  → openshell-sandbox proxy (10.200.0.1:3128)
  → ✗ BLOCKED: host.docker.internal:50001 not in allow-list
  ↓ (if allowed, would continue:)
  → 172.17.0.1:50001 (Docker bridge)
  → host UFW (ALLOW from 172.16.0.0/12)
  → mnemo-cortex (0.0.0.0:50001)
```

**Failure point:** The OpenShell proxy. It only allows connections to destinations explicitly listed in the network policy. Port 50001 and `host.docker.internal` are not in the list.

---

## 5. Policy Management

### Commands

- `openshell policy set --policy <file.yaml> sparks-nemo` — apply policy YAML to live sandbox
- `openshell policy get [--full] sparks-nemo` — show current policy
- `openshell policy list sparks-nemo` — show version history
- `nemoclaw sparks-nemo policy-add` — convenience wrapper for applying presets

### Available Presets

Located in `~/.nemoclaw/source/nemoclaw-blueprint/policies/presets/`:
- discord.yaml (applied)
- docker.yaml
- huggingface.yaml
- jira.yaml
- npm.yaml (applied as npm_yarn)
- outlook.yaml
- pypi.yaml (applied)
- slack.yaml
- telegram.yaml (applied)

**No mnemo-cortex preset exists.**

### Current Policy State

- Version: 3 (loaded)
- Hash: `462a3f55b4da...`
- 3 versions in history, all from sandbox creation

---

## 6. Key Concern: TLS vs Plain HTTP

All existing policy entries use **port 443 with `tls: terminate`**. Mnemo-cortex is **plain HTTP on port 50001**. It's unclear if the OpenShell proxy supports non-TLS pass-through. Every currently allowed endpoint goes through TLS MITM. A custom policy entry for `host.docker.internal:50001` may need special handling (e.g., `protocol: rest` without `tls: terminate`, or a different enforcement mode).

---

## 7. What Would Be Needed

A custom network policy entry like:
```yaml
network_policies:
  mnemo_cortex:
    name: mnemo_cortex
    endpoints:
      - host: host.docker.internal
        port: 50001
        protocol: rest
        enforcement: enforce
        rules:
          - allow: { method: "*", path: "/**" }
```

Applied via `openshell policy set --policy <file> sparks-nemo` (session-only, lost on restart) or as a permanent preset via `nemoclaw sparks-nemo policy-add`.

**Open questions:**
- Does the proxy handle plain HTTP (non-TLS) on non-443 ports?
- Can `openshell policy set` add entries incrementally, or does it replace the entire policy?
- If it replaces, we need the full current policy YAML plus the new entry.

---

*This is a recon report. No changes were made.*
