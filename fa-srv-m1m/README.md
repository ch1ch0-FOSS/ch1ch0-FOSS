# ch1ch0-FOSS: fa-srv-m1m
    **Fedora Asahi Server M1 Mac mini**

**Production Linux Infrastructure | Fedora Asahi Apple Silicon M1**

Proof-of-practice showcase for enterprise-grade system administration. 24/7 uptime, <20 minute disaster recovery, 100% FHS compliance.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Fedora Asahi](https://img.shields.io/badge/Fedora-Asahi_Remix-51A2DA?logo=fedora)](https://asahilinux.org)
[![System Setup](https://img.shields.io/badge/Documentation-v6.0-success)](SYSTEM-SETUP-v6.0.md)

---

## Quick Start

**Primary Documentation:** [SYSTEM-SETUP-v6.0.md](SYSTEM-SETUP-v6.0.md)

30+ page reference covering:
- Fedora Asahi M1 base system configuration
- vi-universal workflow toolchain (nvim, tmux, foot, sway)
- Self-hosted infrastructure (Forgejo, Vaultwarden, Syncthing)
- Zettelkasten PKM system (ch1ch0-GNOSIS)
- Disaster recovery procedures (<20 minute full restoration)

---

## Repository Structure

fa-srv-m1m/
├── 00-BOOTSTRAP/ # System initialization, package installation
├── 01-USERS-GROUPS/ # User/group management, privilege config
├── 02-CORE-INFRASTRUCTURE/ # Networking, storage, systemd services
├── 03-USER-ENVIRONMENT/ # Shell, terminal, window manager configs
├── 04-SERVICES/ # Self-hosted service deployment
│ ├── forgejo/ # Git forge (code.ch1ch0-FOSS.me)
│ ├── vaultwarden/ # Password management (vault.ch1ch0-FOSS.me)
│ └── syncthing/ # File synchronization
├── 05-DISASTER-RECOVERY/ # Backup scripts, restoration procedures
├── DOCUMENTATION/ # Tool-specific guides (nvim, tmux, git, zk)
├── VISUALS/ # System screenshots, architecture diagrams
└── SYSTEM-SETUP-v6.0.md # Master documentation


---

## Infrastructure Stats

| Metric | Value |
|--------|-------|
| **Uptime Target** | 24/7 self-hosted services |
| **Disaster Recovery** | <20 minutes full restoration |
| **Documentation** | 30+ pages, 10 tool guides |
| **Package Management** | 100% FHS compliance |
| **Architecture** | Apple Silicon M1 (ARM64) |
| **Base System** | Fedora Asahi Remix |

---

## Service Deployment

### Forgejo (Git Forge)
- **URL:** https://code.ch1ch0-FOSS.me
- **Setup:** [04-SERVICES/forgejo/](04-SERVICES/forgejo/)
- **Features:** Self-hosted GitHub alternative, CI/CD ready

### Vaultwarden (Password Manager)
- **URL:** https://vault.ch1ch0-FOSS.me
- **Setup:** [04-SERVICES/vaultwarden/](04-SERVICES/vaultwarden/)
- **Features:** Bitwarden-compatible, end-to-end encrypted

### Syncthing (File Sync)
- **Setup:** [04-SERVICES/syncthing/](04-SERVICES/syncthing/)
- **Features:** P2P synchronization, cross-device workflow

---

## Tool Mastery Guides

Located in `DOCUMENTATION/`:

- **[nvim.md](DOCUMENTATION/nvim.md)** - Neovim configuration, keybindings, plugin management
- **[tmux.md](DOCUMENTATION/tmux.md)** - Terminal multiplexing workflow
- **[foot.md](DOCUMENTATION/foot.md)** - Wayland-native terminal emulator
- **[zk.md](DOCUMENTATION/zk.md)** - Zettelkasten note-taking system
- **[git.md](DOCUMENTATION/git.md)** - Version control patterns
- **[lazygit.md](DOCUMENTATION/lazygit.md)** - TUI Git client
- **[sway.md](DOCUMENTATION/sway.md)** - Tiling window manager (Wayland)
- **[zsh.md](DOCUMENTATION/zsh.md)** - Shell configuration
- **[bash.md](DOCUMENTATION/bash.md)** - Shell scripting reference
- **[vimb.md](DOCUMENTATION/vimb.md)** - Vim-like web browser

---

## Key Achievements

- ✅ **Production-ready infrastructure** on Apple Silicon M1
- ✅ **Documented disaster recovery** with <20 minute RTO
- ✅ **Self-hosted services** replacing commercial SaaS
- ✅ **vi-universal workflow** across all tooling
- ✅ **FHS-compliant** package and configuration management
- ✅ **Zettelkasten PKM** with 7 specialized note templates

---

## Portfolio Context

This repository is part of the **[ch1ch0-FOSS](https://github.com/ch1ch0-FOSS)** professional portfolio.

**Website:** https://ch1ch0-FOSS.me  
**Position:** SysAdmin / DevOps / SRE  
**Focus:** Linux infrastructure, automation, self-hosted architecture

---

## License

MIT License - See [LICENSE](LICENSE) for details.

Documentation and configuration examples provided as-is for educational and professional demonstration purposes.


