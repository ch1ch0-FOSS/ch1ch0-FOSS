<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# system

Production infrastructure on Fedora Asahi Linux (Apple Silicon M1)

## Overview

Self-hosted platform with 20-minute disaster recovery, Git-backed configuration management, and zero data loss on OS failure. All services run on external SSDs, ensuring full portability across hardware and instant system rebuild from repository clone.

***

## Architecture

### Hardware

- **Compute**: Apple M1 Mac mini (8-core CPU @ 2.99 GHz, 8-core GPU @ 1.28 GHz, 16GB RAM)
- **OS Storage**: 162.7GB internal SSD (btrfs, ephemeral, reinstallable)
- **Data Storage**: 8TB external SSD mounted at `/mnt/data` (btrfs)
- **Processing Storage**: 2TB external SSD mounted at `/mnt/fastdata` (btrfs)
- **Network**: Gigabit Ethernet at 192.168.1.64/24


### Operating Environment

- **OS**: Fedora Asahi Remix 42 (aarch64)
- **Kernel**: 6.16.8-400.asahi.fc42.aarch64+16k
- **Display**: SAMSUNG 60" @ 1920x1080 60Hz
- **WM**: Sway 1.10.1 (Wayland)
- **Terminal**: Foot (vi-style keybindings)
- **Editor**: Neovim (capability-focused config)
- **Multiplexer**: Tmux 3.5a (universal vi navigation)
- **Shell**: zsh 5.9
- **Packages**: 1592 (rpm)


### Storage Layout

```
/mnt/data/          8TB persistent storage (btrfs, 1% used)
├── srv/            Service data (Forgejo, Vaultwarden, Syncthing, Ollama)
├── git/            Version-controlled repositories
│   ├── system/    System configuration (source of truth)
│   ├── user-GNOSIS/  Zettelkasten PKM
│   └── user-FOSS/    Portfolio projects
├── dev/            Portable toolchains (Rust, Go)
├── home/user/    User environment (symlinked to /home/user)
└── backups/        Automated service snapshots

/mnt/fastdata/      2TB processing storage (btrfs, 0% used)
```


### Service Architecture

| Service | Port | User | Data Path | Backup Schedule | Access Method |
| :-- | :-- | :-- | :-- | :-- | :-- |
| Forgejo | 3000 | git | `/mnt/data/srv/forgejo` | Daily | localhost / SSH tunnel |
| Vaultwarden | 8000 | vaultwarden | `/mnt/data/srv/vaultwarden` | Daily | localhost / SSH tunnel |
| Syncthing | 8384 | syncthing | `/mnt/data/srv/syncthing` | Continuous | localhost / SSH tunnel |
| Ollama | 11434 | ollama | `/mnt/data/srv/ollama` | On-demand | localhost / SSH tunnel |

All services bound to localhost. External access requires reverse proxy or SSH tunnel.

***

## Design Decisions

### External SSD Architecture

**Two-SSD Strategy**

- `/mnt/data`: Long-term storage, configs, repos (8TB)
- `/mnt/fastdata`: Compute-intensive workloads, temp processing (2TB)
- Separation prevents I/O contention during heavy processing

**OS/Data Separation**

- OS reinstall: 15 minutes
- Data recovery: symlink restoration only
- Hardware swap: plug SSD into new machine
- Testing: boot new OS, mount data, validate

**Trade-offs**

- Portability: Data survives hardware failure or migration
- Recovery speed: No data restoration needed during OS reinstall
- Backup simplicity: Single mount point backs up everything
- Cost-effectiveness: M1 internal storage expensive; external SSDs cheap/fast
- Performance cost: USB throughput vs NVMe (acceptable for workload)


### Git-Based Configuration

**Strategy**

- All configs version-controlled in `/mnt/data/git/system/`
- Home directory is symlinks only—no persistent state
- Toolkit directory sources canonical configs
- Conventional commits enforced via commitlint hooks

**Benefits**

- Version control: Every config change tracked
- Disaster recovery: Clone repository → symlink toolkit → functional system
- Documentation: Commit messages explain "why" behind every change
- Reproducible state: Single repository restores entire system configuration
- Collaboration: Share configs via Forgejo → GitHub mirror


### btrfs Filesystem

- Snapshots for instant rollback
- Transparent compression (saves ~20% disk on text-heavy data)
- Checksumming prevents silent corruption
- Subvolume management for service isolation


### Terminal-First Workflow

- **Performance**: Native ARM64 CLI tools faster than Electron apps
- **Consistency**: Same keybindings across all tools (vi-style)
- **Efficiency**: Keyboard-driven eliminates mouse context switching
- **Remote capability**: Full functionality via SSH session
- **Philosophy**: Muscle-memory optimized, keyboard-driven

***

## Operations

### Bootstrap Procedure

```bash
# 1. Mount external SSDs
sudo mount /dev/sdX1 /mnt/data
sudo mount /dev/sdX2 /mnt/fastdata

# 2. Symlink home directory
sudo ln -s /mnt/data/home/user /home/user

# 3. Restore configuration symlinks
ln -s /mnt/data/git/system/toolkit/nvim ~/.config/nvim
ln -s /mnt/data/git/system/toolkit/zsh/.zshrc ~/.zshrc
ln -s /mnt/data/git/system/toolkit/tmux ~/.config/tmux
ln -s /mnt/data/git/system/toolkit/sway ~/.config/sway
ln -s /mnt/data/git/system/toolkit/foot ~/.config/foot

# 4. Start services
systemctl --user start forgejo vaultwarden syncthing ollama
```

**Total time**: 20 minutes including OS install

### Service Control

```bash
# Start all services
systemctl --user start forgejo vaultwarden syncthing ollama

# Check service status
systemctl --user status forgejo

# View service logs
journalctl --user -u forgejo -n 50 -f

# Restart service
systemctl --user restart vaultwarden

# Stop all services
systemctl --user stop forgejo vaultwarden syncthing ollama
```


### Verification

```bash
# Verify mounts
df -h /mnt/data /mnt/fastdata

# Verify symlinks
ls -la ~/.config/nvim ~/.zshrc ~/.config/tmux

# Test service endpoints
curl -I localhost:PORT   # Forgejo
curl -I localhost:8000   # Vaultwarden
curl -I localhost:8384   # Syncthing
curl -I localhost:11434  # Ollama

# Check service processes
systemctl --user list-units --type=service --state=running | grep -E 'forgejo|vaultwarden|syncthing|ollama'
```


***

## Disaster Recovery

### Recovery Model

1. Wipe OS partition
2. Reinstall Fedora Asahi Remix
3. Mount `/mnt/data` and `/mnt/fastdata`
4. Execute bootstrap procedure
5. Services operational

### Metrics

- **Recovery Time Objective (RTO)**: 20 minutes
- **Recovery Point Objective (RPO)**: Zero (all data persisted to external SSDs)
- **Data Loss on OS Failure**: Zero
- **Config Drift Risk**: Zero (Git-backed)


### Data-Device Separation Principle

- **OS layer**: Lives on M1 SSD, contains no unique state
- **Data layer**: Lives on external SSDs, contains all persistent state
- **Recovery model**: Wipe OS → reinstall → remount data → restore services

***

## Related Documentation

- **Disaster Recovery**: [`automation/disaster-recovery/disaster-recovery.md`](../automation/disaster-recovery/disaster-recovery.md)
- **System Runbook**: [`documentation/RUNBOOK.md`](../documentation/RUNBOOK.md)
- **Setup Guide**: [`documentation/SYSTEM-SETUPv6.0.md`](../documentation/SYSTEM-SETUPv6.0.md)
- **Service READMEs**: [`infrastructure/services/*/README.md`](../infrastructure/services/)
<span style="display:none">[^1][^2]</span>

<div align="center">⁂</div>

[^1]: architecture.md

[^2]: system.md

