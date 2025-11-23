# Automation

Executable automation for srv-m1m infrastructure deployment and management.

## Purpose

- System bootstrapping and baseline configuration
- Service installation with idempotent scripts
- Configuration deployment and synchronization from git
- Reproducible infrastructure provisioning

## Contents

**system/**
- `fedora_bootstrap.sh` - Complete OS baseline setup (FHS structure, SSH hardening, firewall, user environment)

**services/**
- `install_forgejo.sh` - Forgejo Git service (port 3000)
- `install_ollama.sh` - Ollama LLM inference (port 11434)
- `install_postgresql.sh` - PostgreSQL 16 database (port 5432)
- `install_syncthing.sh` - Syncthing file sync (port 8384, 22000)
- `install_vaultwarden.sh` - Vaultwarden password manager (port 8000, 3012)
- `install_wlogout.sh` - wlogout logout menu (Wayland, built from source)
- `install_zk.sh` - zk Zettelkasten CLI (knowledge management)

**deployment/**
- `deploy-system-config.sh` - Pull latest srv-m1m repo, deploy system configs
- `deploy-toolkit-config.sh` - Pull latest srv-m1m repo, symlink toolkit configs to user environment
- `sync-to-public.sh` - Sanitized repository sync to public showcase

## Usage

**Bootstrap new Fedora system:**

cd automation/system
sudo bash fedora_bootstrap.sh

**Install infrastructure services:**

cd automation/services

Database (install first - required by forgejo and vaultwarden)
sudo bash install_postgresql.sh

Git service
sudo bash install_forgejo.sh

LLM inference
sudo bash install_ollama.sh

File synchronization
sudo bash install_syncthing.sh

Password manager
sudo bash install_vaultwarden.sh

Wayland logout menu
sudo bash install_wlogout.sh

Zettelkasten CLI
sudo bash install_zk.sh

**Deploy configuration updates:**

cd automation/deployment

System-level configs (run as root)
sudo bash deploy-system-config.sh

User toolkit configs (run as user)
bash deploy-toolkit-config.sh

**Sync to public repository:**

cd automation/deployment
bash sync-to-public.sh


## Design Principles

- **Idempotency**: Safe to re-run without side effects
- **Validation**: Pre-flight checks and post-execution verification
- **Backup**: Configuration and data preservation before modifications
- **Logging**: Timestamped, categorized output to `/var/log/`
- **Error handling**: Fail fast with `set -euo pipefail`
- **FHS compliance**: Standard Linux directory hierarchy
- **Security**: Localhost-only services, credential isolation, proper permissions

## Service Architecture

**Database Layer:**
- PostgreSQL 16 (native package, systemd managed)
- Credentials: `/etc/srv/secrets/db-credentials.txt` (600 permissions)
- Databases: `forgejo`, `vaultwarden`

**Application Layer:**
- Forgejo (native binary, systemd managed)
- Ollama (native binary, systemd managed)
- Syncthing (podman container, systemd managed)
- Vaultwarden (podman container, systemd managed)

**CLI Tools:**
- zk (native binary, user-level)
  - Config: `~/.config/zk/` (symlinked to toolkit)
  - Notebook: `/mnt/data/git/user-GNOSIS`
  - Database: SQLite (embedded in notebook `.zk/` directory)
- wlogout (native binary, user-level, meson/ninja build)
  - Config: `~/.config/wlogout/`, `/usr/local/etc/wlogout/`
  - Keybind: `$mod+Shift+x` in sway

**Data Locations:**
- `/mnt/data/srv/` - Service data directories
- `/srv/` - Symlinks to service directories (FHS compliance)
- `/mnt/data/git/` - Git repositories (notebooks, configurations, srv-m1m source of truth)

## Deployment Workflow

**deploy-toolkit-config.sh** syncs toolkit directory from `/mnt/data/git/srv-m1m/toolkit` to user config locations:
- Pulls latest commits from git
- Symlinks toolkit configs to `~/.config/` (nvim, sway, zk, tmux, foot, fuzzel, etc.)
- Reloads affected services (e.g., sway)
- Enables rapid deployment of identical toolkit setup to any machine with srv-m1m cloned

**deploy-system-config.sh** deploys system-level configurations (adjust as implementation evolves).

## Installation Order

**Required sequence for clean deployment:**

1. **System Bootstrap**: `fedora_bootstrap.sh`
2. **Database**: `install_postgresql.sh` (required by forgejo, vaultwarden)
3. **Services** (any order):
   - `install_forgejo.sh`
   - `install_ollama.sh`
   - `install_syncthing.sh`
   - `install_vaultwarden.sh`
4. **Tools** (any order):
   - `install_zk.sh`
   - `install_wlogout.sh`

## Next Steps

- Convert deployment scripts to systemd timers for scheduled execution
- Implement automated backup scripts for service data
- Add integration testing for service installation scripts
- Document disaster recovery procedures using these scripts

