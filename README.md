# ch1ch0-FOSS

Production Infrastructure Architect • Linux SysAdmin • FOSS-First

I design and operate **self-hosted, vendor-agnostic infrastructure** on bare metal and ARM64, with a focus on:

- Linux (Fedora / RHEL family) on ARM64
- Git-centric workflows (Forgejo → mirrored to GitHub)
- Agentic tooling (OpenCode + Beads) for reproducible automation

---

## 🔧 Current Portfolio System

**srv-m1m Asahi Stack** (Apple M1, Fedora Asahi)

- PostgreSQL for data
- Forgejo for Git + CI/CD entrypoint
- Forgejo Actions for pipelines (Woodpecker CI as a potential shift later)
- Prometheus + Grafana for observability
- Vaultwarden for secrets
- Local LLMs via Ollama (ARM64) for on-box AI assistance

All infrastructure is defined as **code** and managed from my ThinkPad T480 control plane using:

- `~/iac` for Ansible, ADRs, and runbooks
- Beads (`bd`) for deterministic task tracking
- OpenCode as my AI-assisted editor, grounded only in local repos and docs

---

## 🧠 How I Work

- **Control plane**: T480 (Ansible, OpenCode, Beads, vi-centric)
- **Service/data hub**: srv-m1m (databases, Git, monitoring, LLM services)
- **Docs**: ADRs, runbooks, and troubleshooting guides – written in Markdown, versioned in git, and safe to publish

I avoid SaaS lock-in wherever possible and treat every system as something I must be able to **operate, recover, and explain** without external platforms.

---

## 📂 Key Repositories

- [`srv-m1m-asahi`](https://github.com/ch1ch0-FOSS/srv-m1m-asahi) — single-node Apple M1 home lab + portfolio system
- [`ch1ch0-foss`](https://github.com/ch1ch0-FOSS/ch1ch0-FOSS) — this landing page (mirrored from my self-hosted Forgejo)
- (Add more as they become ready for public consumption)

---

## 🗺️ What I’m Building Next

- Dual-local LLM workflow (T480 + srv-m1m) using Ollama
- MCP-backed context over infra docs
- Phase 2: RAG over **local copies of vendor docs** (PostgreSQL, Prometheus, Forgejo) so AI agents follow upstream best practices without touching the public internet

---

## 📫 Contact

- Website: https://ch1ch0-FOSS.me
- LinkedIn: https://www.linkedin.com/in/chicho-foss-42b676165

