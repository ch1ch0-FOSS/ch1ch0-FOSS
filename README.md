# srv-m1m

**Production Fedora Asahi Infrastructure on Apple Silicon M1**

Self-hosted infrastructure with git-based configuration management, automated disaster recovery, and terminal-first workflow. All system configurations version-controlled and reproducible.

---

## Quick Start

Clone repository
git clone http://localhost:3000/user/srv-m1m.git /mnt/data/git/srv-m1m

Restore dotfiles (see RUNBOOK.md for full procedure)
cd /mnt/data/git/srv-m1m
./scripts/restore-symlinks.sh


## Core Capabilities

- **<20-minute disaster recovery**: Complete system restoration from git repository
- **Git-based configuration**: All dotfiles, service configs, and scripts version-controlled
- **Self-hosted services**: Forgejo (git), Vaultwarden (passwords), Syncthing (files), Ollama (LLM)
- **Terminal-first workflow**: Vi-style keybindings unified across all tools
- **Automated backups**: Daily service snapshots to external storage

## Repository Structure

srv-m1m/
├── architecture/ # System architecture and design decisions
├── automation/ # Disaster recovery and provisioning scripts
├── documentation/ # Runbooks, guides, and reference documentation
├── infrastructure/ # Service configurations and deployment
└── toolkit/ # Dotfiles and configuration templates
├── shell/ # Zsh/Bash configs, aliases, functions
├── editors/ # Neovim, zk (Zettelkasten)
├── terminal/ # Foot, tmux
├── terminal-ui/ # Fuzzel, lazygit, vimb
└── window-manager/ # Sway configuration


## Documentation

- **[ARCHITECTURE.md](architecture/ARCHITECTURE.md)**: System design and capabilities
- **[RUNBOOK.md](documentation/RUNBOOK.md)**: Daily operations and disaster recovery
- **[SYSTEM-SETUPv6.0.md](documentation/SYSTEM-SETUPv6.0.md)**: Complete setup guide
- **[Tool References](documentation/guides/)**: Keybinding cheatsheets for all tools

## Services

| Service      | Port  | Purpose                     | Data Location              |
|--------------|-------|-----------------------------|----------------------------|
| Forgejo      | 3000  | Private git server          | /mnt/data/srv/forgejo      |
| Vaultwarden  | 8222  | Password manager            | /mnt/data/srv/vaultwarden  |
| Syncthing    | 8384  | File synchronization        | /mnt/data/srv/syncthing    |
| Ollama       | 11434 | Local LLM inference         | /mnt/data/srv/ollama       |

## System Requirements

- Fedora Asahi Linux (ARM64) on Apple Silicon M1/M2
- External SSD mounted at `/mnt/data` (recommended 1TB+)
- Git, systemd, and basic development tools

## Installation

See [fedora-asahi-minimal-install.md](fedora-asahi-minimal-install.md) for initial OS setup, then follow [SYSTEM-SETUPv6.0.md](documentation/SYSTEM-SETUPv6.0.md) for complete system configuration.

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Maintainer

user - Fedora Asahi srv-m1m infrastructure


