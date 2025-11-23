# SYSTEM-SETUP v6.0
## Vi-like Universal Keybindings | Complete Reference Documentation | Terminal Mastery

**Date:** 2025-11-19  
**Maintainer:** user  
**System:** fa-srv-m1m (Fedora Asahi - Apple Silicon M1)  
**Status:** Production-Ready (Reference Documentation Complete)  
**Last Updated:** 2025-11-19 12:30 PM EST

---

## Document Purpose

Complete infrastructure documentation with:
- **NEW:** Comprehensive reference guides for all tools (nvim, tmux, foot, zk, git, vimb, zsh, bash, lazygit, sway)
- Terminal-first workflow with vi-like universal keybindings
- Git-backed configuration with symlink strategy
- Production-grade Zettelkasten PKM (user-GNOSIS)
- Modular Neovim with integrated tools
- Portable development environment (Rust, Go)
- Professional career portfolio infrastructure

**Version Evolution:**
- **v3.1 → v4.0:** Portable dev environment + Zettelkasten PKM + dotfiles
- **v4.0 → v5.0:** Terminal-first unification, universal muscle memory, nvim refactor, shell consolidation
- **v5.0 → v6.0:** **Complete reference documentation system, template refinements, tmux best-in-class config** ✨

---

## Table of Contents

1. [System Architecture Overview](#1-system-architecture-overview)
2. [Reference Documentation System](#2-reference-documentation-system) ✨ **NEW**
3. [Terminal Stack & Integration](#3-terminal-stack--integration)
4. [Shell Configuration (Zsh)](#4-shell-configuration-zsh)
5. [Neovim Configuration (Modular)](#5-neovim-configuration-modular)
6. [Universal Vi-like Keybindings](#6-universal-vi-like-keybindings)
7. [Zettelkasten (zk) System](#7-zettelkasten-zk-system)
8. [Tmux Configuration](#8-tmux-configuration) ✨ **UPDATED**
9. [Git Repository Management](#9-git-repository-management)
10. [Core Services](#10-core-services)
11. [Portable Development Environment](#11-portable-development-environment)
12. [Filesystem Hierarchy](#12-filesystem-hierarchy)
13. [Disaster Recovery](#13-disaster-recovery)
14. [Daily Workflows](#14-daily-workflows)

---

## 1. System Architecture Overview

### Hardware
- **Host:** Mac Mini M1 (Apple Silicon - ARM64)
- **OS:** Fedora Asahi Remix 40-42 (Linux native)
- **Kernel:** 6.16.8-400.asahi.fc42
- **Memory:** 16GB unified
- **Primary Shell:** Zsh
- **Window Manager:** Sway (Wayland)

### Storage Layout
```

/mnt/data/              (7.3TB portable SSD)
├── git/                (Version-controlled configs + repos)
│   ├── fa-srv-m1m/config/        → System config (source of truth)
│   │   ├── nvim/
│   │   ├── tmux/
│   │   ├── foot/
│   │   ├── sway/
│   │   ├── zsh/
│   │   ├── bash/
│   │   ├── zk/
│   │   ├── vimb/
│   │   ├── lazygit/
│   │   └── [reference guides] ✨
│   ├── user-GNOSIS/            → Zettelkasten PKM
│   ├── user-FOSS/              → Portfolio projects
│   └── [other repos]
├── dev/                (Development toolchains)
│   ├── rust/           (Cargo + Rustup)
│   └── go/             (GOPATH + cache)
└── srv/                (Service data)
├── forgejo/
├── vaultwarden/
└── syncthing/

```

### Design Principles
- ✅ **Terminal-first:** Keyboard-driven, no mouse required
- ✅ **Vi-like everywhere:** hjkl, /, :, Esc universal
- ✅ **Git-backed:** All configs version-controlled
- ✅ **Reference-driven:** Complete documentation for every tool ✨
- ✅ **Reproducible:** 15-minute bootstrap on new hardware
- ✅ **Portable:** Entire infrastructure on external SSD
- ✅ **Professional:** Portfolio-grade, demonstrable mastery

---

## 2. Reference Documentation System ✨ NEW

### Complete Tool Reference Guides

All reference guides stored in:  
`/mnt/data/git/fa-srv-m1m/config/{tool}/`

| Tool | Reference File | Alias | Status |
|------|----------------|-------|--------|
| **Nvim** | `nvim/NVIM-REFERENCE.md` | `nvimref` | ✅ Complete |
| **Tmux** | `tmux/TMUX-REFERENCE.md` | `tmuxref` | ✅ Complete |
| **Foot** | `foot/FOOT-REFERENCE.md` | `footref` | ✅ Complete |
| **Zk** | `zk/ZK-REFERENCE.md` | `zkref` | ✅ Complete |
| **Git** | `git/GIT-REFERENCE.md` | `gitref` | ✅ Complete |
| **Vimb** | `vimb/VIMB-REFERENCE.md` | `vimbref` | ✅ Complete |
| **Zsh** | `zsh/ZSH-REFERENCE.md` | `zshref` | ✅ Complete |
| **Bash** | `bash/BASH-REFERENCE.md` | `bashref` | ✅ Complete |
| **Lazygit** | `lazygit/LAZYGIT-REFERENCE.md` | `lgref` | ✅ Complete |
| **Sway** | `sway/SWAY-REFERENCE.md` | `swayref` | ✅ Complete |

### Access Reference Guides

**Aliases in `~/.zshrc`:**
```

alias nvimref='nvim /mnt/data/git/fa-srv-m1m/config/nvim/NVIM-REFERENCE.md'
alias tmuxref='nvim /mnt/data/git/fa-srv-m1m/config/tmux/TMUX-REFERENCE.md'
alias footref='nvim /mnt/data/git/fa-srv-m1m/config/foot/FOOT-REFERENCE.md'
alias zkref='nvim /mnt/data/git/fa-srv-m1m/config/zk/ZK-REFERENCE.md'
alias gitref='nvim /mnt/data/git/fa-srv-m1m/config/git/GIT-REFERENCE.md'
alias vimbref='nvim /mnt/data/git/fa-srv-m1m/config/vimb/VIMB-REFERENCE.md'
alias zshref='nvim /mnt/data/git/fa-srv-m1m/config/zsh/ZSH-REFERENCE.md'
alias bashref='nvim /mnt/data/git/fa-srv-m1m/config/bash/BASH-REFERENCE.md'
alias lgref='nvim /mnt/data/git/fa-srv-m1m/config/lazygit/LAZYGIT-REFERENCE.md'
alias swayref='nvim /mnt/data/git/fa-srv-m1m/config/sway/SWAY-REFERENCE.md'

```

### Reference Guide Features

**Each guide contains:**
- Complete keybindings reference
- Command syntax & examples
- Configuration options
- Integration with other tools
- Common workflows
- Troubleshooting
- Best practices
- Vi-like keybinding alignment

**Universal format:**
- Organized by task/operation
- Quick-lookup tables
- Code examples with output
- Integration notes
- Performance tips

---

## 3. Terminal Stack & Integration

### The Complete Stack

| Layer | Tool | Keybindings | Status |
|-------|------|-------------|--------|
| **Display Server** | Wayland | - | ✅ |
| **Window Manager** | Sway | $mod+hjkl | ✅ |
| **Terminal** | Foot | Wayland-native | ✅ |
| **Multiplexer** | Tmux | Prefix+hjkl | ✅ |
| **Shell** | Zsh | Vi-mode | ✅ |
| **Editor** | Nvim | hjkl | ✅ |
| **Browser** | Vimb | hjkl | ✅ |
| **File Manager** | oil.nvim | hjkl | ✅ |
| **Git UI** | Lazygit | hjkl | ✅ |
| **PKM** | Zk | CLI + nvim | ✅ |

### Navigation Flow
```

Sway (\$mod+hjkl)
↓
Foot terminal
↓
Tmux (Prefix+hjkl)
↓
Zsh (vi-mode hjkl)
↓
Nvim/Vimb/Lazygit (hjkl)

```

### Color Scheme (Universal)
```

Background:   \#000000 (black)
Foreground:   \#a8a8a8 (grey)
Highlight:    \#00ff00 / colour2 (green)
Warning:      \#ff0000 (red)
Active:       \#00ff00 (green)
Inactive:     \#888888 (dark grey)

```

---

## 4. Shell Configuration (Zsh)

### Zsh as Default Shell

```


# Verify

echo \$SHELL  \# Should be /bin/zsh

# Set if needed

chsh -s /usr/bin/zsh

```

### Config Location

**Source of truth:**  
`/mnt/data/git/fa-srv-m1m/config/zsh/.zshrc`

**Symlink:**
```

~/.zshrc → /mnt/data/git/fa-srv-m1m/config/zsh/.zshrc

```

### Core Features

**Vi-mode enabled:**
```

bindkey -v

```

**Zk aliases:**
```

alias zkf='zk new --template fleeting.md'
alias zkz='zk new --template zettel.md'
alias zkp='zk new --template permanent.md'
alias zkm='zk new --template moc.md'
alias zkd='zk new --template decision.md'
alias zkj='zk new --template project.md'
alias zkr='zk new --template reference.md'
alias zkl='zk list'
alias zks='zk list --interactive'
alias zke='zk edit --interactive'
alias zklf='zk list --tag fleeting'
alias zklp='zk list --tag permanent'
alias zklm='zk list --tag moc'

```

**Reference guide aliases:**  
(See section 2)

---

## 5. Neovim Configuration (Modular)

### Directory Structure

```

/mnt/data/git/fa-srv-m1m/config/nvim/
├── init.lua
├── lazy-lock.json
├── NVIM-REFERENCE.md ✨
└── lua/
├── config/
│   ├── keymaps.lua
│   ├── lazy.lua
│   └── options.lua
└── plugins/
├── oil.lua
├── treesitter.lua
├── which-key.lua
├── zk.lua
└── [others]

```

### Symlink
```

~/.config/nvim → /mnt/data/git/fa-srv-m1m/config/nvim

```

### Core Keybindings
```

<leader>e       - oil.nvim (file explorer)
<leader>gg      - lazygit
<leader>zn      - zk new note
<leader>zi      - zk insert link
<leader>zs      - zk search
<C-h/j/k/l>     - window navigation

```

---

## 6. Universal Vi-like Keybindings

### Movement (hjkl)

**Works in:**
- Sway: `$mod+hjkl` (window focus)
- Tmux: `Prefix+hjkl` (pane nav)
- Zsh: Vi-mode `hjkl` (history/line)
- Nvim: `hjkl` (navigation)
- Vimb: `hjkl` (scroll)
- Lazygit: `hjkl` (navigate)

### Search (/)

**Works in:**
- Nvim: `/pattern`
- Vimb: `/pattern`
- Zsh: `Ctrl+r` (history)
- Tmux copy mode: `/`
- Lazygit: `/`
- Git: `git log --grep`

### Command Mode (:)

**Works in:**
- Nvim: `:command`
- Vimb: `:command`
- Tmux: `Prefix :`
- Zsh: command line (native)

### Escape

**Works in:**
- All modes: `Esc` returns to normal/default
- Caps Lock mapped to Escape (sway input config)

---

## 7. Zettelkasten (zk) System

### Repository
**Location:** `/mnt/data/git/user-GNOSIS/`

### Templates (Updated v6.0)

**Location:**  
`/mnt/data/git/fa-srv-m1m/config/zk/zk/templates/`

**All templates use `{{format-date now}}`** ✨ (not `{{date}}`)

**Available templates:**
- `fleeting.md` - Quick capture (48h review)
- `zettel.md` - Atomic developing notes
- `permanent.md` / `wiki.md` - Evergreen knowledge
- `moc.md` - Maps of Content
- `decision.md` - Decision logs
- `project.md` - Project tracking
- `reference.md` - External sources

### YAML Frontmatter Standard ✨

**Correct format (bracket arrays):**
```


***
title: "Note Title"
uid: "unique-id"
created: "2025-11-19T12:00:00-05:00"
tags: [linux, reference, permanent]
status: "developing"
type: "zettel"
***
```

**Common errors fixed:**
- ❌ `tags: #linux #reference` (bare hashtags)
- ✅ `tags: [linux, reference]` (bracket arrays)
- ❌ `{{date}}` (deprecated helper)
- ✅ `{{format-date now}}` (current helper)

### Workflow
```

cd /mnt/data/git/user-GNOSIS

# Quick capture

zkf --title "Quick thought"

# Develop idea

zkz --title "Concept name"

# Search

zk list --match "keyword"
zk list --tag linux

# Git sync

git add .
git commit -m "Daily sync \$(date +%Y-%m-%d)"
git push

```

---

## 8. Tmux Configuration ✨ UPDATED

### Config Location

**Source of truth:**  
`/mnt/data/git/fa-srv-m1m/config/tmux/tmux.conf`

**Symlinks:**
```

~/.config/tmux/tmux.conf → /mnt/data/git/fa-srv-m1m/config/tmux/tmux.conf
~/.tmux.conf → /mnt/data/git/fa-srv-m1m/config/tmux/tmux.conf

```

### Best-in-Class Features (v6.0)

**Prefix:** `Ctrl-a` (screen-style, muscle memory)

**Vi-mode throughout:**
```

set -g status-keys vi
setw -g mode-keys vi

```

**Pane navigation (vi-style):**
```

Prefix+h/j/k/l      - navigate panes
Prefix+H/J/K/L      - resize panes
Prefix+|            - split vertical
Prefix+-            - split horizontal

```

**Copy mode (vi-style):**
```

Prefix+[            - enter copy mode
v                   - start selection
y                   - yank selection
Escape              - exit copy mode
/                   - search forward
?                   - search backward

```

**Ncurses green theme:**
```


# Status bar: green background, black text

set -g status-style fg=colour0,bg=colour2

# Active pane: green border

set -g pane-active-border-style fg=colour2

# Copy mode: green selection

set -g mode-style bg=colour2,fg=colour0

```

**Mouse disabled** (keyboard-only workflow)

### Reference Guide
See `TMUX-REFERENCE.md` for complete documentation.

---

## 9. Git Repository Management

### Structure
```

/mnt/data/git/
├── fa-srv-m1m/config/              (Source of truth)
│   ├── nvim/
│   ├── tmux/
│   ├── foot/
│   ├── sway/
│   ├── zsh/
│   ├── bash/
│   ├── zk/
│   ├── vimb/
│   ├── lazygit/
│   ├── git/
│   └── [reference guides] ✨
├── user-GNOSIS/                  (Zettelkasten)
├── user-FOSS/                    (Portfolio)
└── [other repos]

```

### Symlink Strategy

**All configs symlinked:**
```

~/.config/nvim → /mnt/data/git/fa-srv-m1m/config/nvim
~/.config/tmux → /mnt/data/git/fa-srv-m1m/config/tmux
~/.config/foot → /mnt/data/git/fa-srv-m1m/config/foot
~/.config/sway → /mnt/data/git/fa-srv-m1m/config/sway
~/.config/zk → /mnt/data/git/fa-srv-m1m/config/zk
~/.config/vimb → /mnt/data/git/fa-srv-m1m/config/vimb
~/.zshrc → /mnt/data/git/fa-srv-m1m/config/zsh/.zshrc

```

### Dual Remotes
```

origin  → Forgejo (local, primary)
github  → GitHub (public mirror)

```

---

## 10. Core Services

| Service | Stack | Database | Port | Status |
|---------|-------|----------|------|--------|
| **Forgejo** | Go 1.21 | SQLite | 3000 | ✅ Prod |
| **Vaultwarden** | Rust | SQLite | 8000 | ✅ Prod |
| **Syncthing** | Go | Internal | 8384 | ✅ Prod |
| **Ollama** | Go + LLM | Internal | 11434 | ✅ Prod |

**Control:**
```

systemctl --user start forgejo vaultwarden syncthing ollama
systemctl --user status forgejo
journalctl --user -u forgejo -n 50

```
---
## 10.5 Public Repository Synchronization (NEW v6.1)

**Purpose**: Maintain sanitized public GitHub portfolio while developing in private Forgejo.

### Architecture

Private Development (Forgejo) Public Portfolio (GitHub)
┌─────────────────────────┐ ┌──────────────────────┐
│ srv-m1m repository │ │ user-FOSS │
│ localhost:3000/user │ ──sync──> │ github.com/user │
│ │ │ │
│ - Full credentials │ │ - Sanitized paths │
│ - Local hostnames │ │ - Generic users │
│ - Service configs │ │ - No secrets │
│ - Private workflows │ │ - Professional docs │
└─────────────────────────┘ └──────────────────────┘


### Sanitization Script

**Location**: `/automation/deployment/sync-to-public-v2.sh`

**What it removes**:
- Sensitive directories: `secrets/`, `keys/`, `certs/`, `backups/`, `credentials/`, `private/`
- Cryptographic material: `*.key`, `*.pem`, `*.p12`, `*.pfx`, `*_rsa`, `*_dsa`, `*_ecdsa`, `*_ed25519`
- Environment files: `*.env`, `*.env.local`, `.env.*`
- Node artifacts: `node_modules/`

**What it sanitizes**:
- Personal paths: `/home/user` → `/home/user`
- Hostnames: `user@system` → `user@system`
- Service URLs: `system.local` → `system.local`
- Local ports: `localhost:3000` → `localhost:PORT`

### Sync Workflow


. Ensure private repo is committed and pushed
cd /mnt/data/git/srv-m1m
git status # Should be clean
git push origin master

2. Execute sanitization and sync
/mnt/data/git/srv-m1m/automation/deployment/sync-to-public-v2.sh

Output shows:
- Cloning to temporary directory
- Removing sensitive files (count displayed)
- Sanitizing paths (replacements shown)
- Copying to public repository
3. Review changes in public repo
cd /mnt/data/git/user-FOSS
git status
git diff HEAD

4. Commit and push to both remotes
git add -A
git commit -m "sync: sanitized update from srv-m1m $(date +%Y-%m-%d)"
git push origin main # Forgejo mirror
git push github main # GitHub public


### Repository Structure

**Public repo location**: `/mnt/data/git/user-FOSS`

**Dual remotes**:

origin http://localhost:3000/user/user-foss.git # Forgejo (staging)
github https://github.com/user-FOSS/user-FOSS.git # GitHub (public)


### GitHub Authentication

**Token management**: Stored in `/mnt/data/PAT-tokens/github-PAT-sync-v2.md` (600 permissions)

**Current token**: Expires 2025-12-23 (30-day rotation policy)

**Scopes required**: `repo`, `workflow`, `read:org`

**Setup**:

Authenticate GitHub CLI
echo "<token>" | gh auth login --with-token
gh auth status

Configure git to use gh CLI credentials
gh auth setup-git


### Verification Checklist

After each sync:

- [ ] **No sensitive data leaked**:

cd /mnt/data/git/user-FOSS
grep -r "user@system" . 2>/dev/null | wc -l # Should be 0
grep -r "srv-m1m" --include=".md" --include=".sh" . 2>/dev/null | wc -l # Should be 0
grep -r "localhost:3000" . 2>/dev/null | wc -l # Should be 0


- [ ] **Both remotes synchronized**:

cd /mnt/data/git/user-FOSS
git log origin/main --oneline -1
git log github/main --oneline -1

Should show identical commit hash

- [ ] **GitHub visible**:

gh repo view user-FOSS/user-FOSS --web

Opens browser to verify content

---

## 11. Portable Development Environment

### Rust Toolchain
```

export CARGO_HOME=/mnt/data/dev/rust/cargo
export RUSTUP_HOME=/mnt/data/dev/rust/rustup
export PATH="$PATH:$CARGO_HOME/bin"

```

### Go Workspace
```

export GOPATH=/mnt/data/dev/go/workspace
export GOCACHE=/mnt/data/dev/go/cache
export PATH="$PATH:$GOPATH/bin"

```

---

## 12. Filesystem Hierarchy

### Home (Minimal)
```

/home/user/
├── .config/ → symlinks to git repo
├── .ssh/
├── .cache/
├── Sync/ → syncthing
└── Downloads/

```

**No persistent data in `/home/user/`—only symlinks**

### Data (Persistent)
```

/mnt/data/git/
├── fa-srv-m1m/config/ ← SOURCE OF TRUTH
├── user-GNOSIS/     ← Zettelkasten
└── user-FOSS/       ← Portfolio

```

---

## 13. Disaster Recovery

### Phase 1: System Bootstrap (15 min)
```


# 1. Install Fedora Asahi

# 2. Mount SSD

sudo mount /dev/sdX1 /mnt/data

# 3. Symlink home

sudo ln -s /mnt/data/home/user /home/user

# 4. Set shell

chsh -s /usr/bin/zsh

```

### Phase 2: Verify (5 min)
```


# Verify symlinks

ls -la ~/.zshrc ~/.config/nvim

# Verify zk

cd /mnt/data/git/user-GNOSIS
zk list

# Verify services

systemctl --user start forgejo vaultwarden syncthing ollama

```

**Total recovery: ~20 minutes**

---

## 14. Daily Workflows

### Morning
```


# Terminal opens in zsh automatically

# Check recent work

cd /mnt/data/git/user-GNOSIS
zk list --sort modified | head -10

```

### Throughout Day
```


# Quick capture

zkf --title "Thought"

# Search knowledge

zk list --match "topic"

# Create permanent note

zkp --title "Important Concept"

```

### Evening
```


# Sync everything

cd /mnt/data/git/user-GNOSIS
git add .
git commit -m "Daily sync \$(date +%Y-%m-%d)"
git push

```

---

## Installation Checklist

### Core Setup
- [ ] Mount `/mnt/data/` SSD
- [ ] Symlink home: `sudo ln -s /mnt/data/home/user /home/user`
- [ ] Set zsh: `chsh -s /usr/bin/zsh`
- [ ] Create config symlinks (see section 9)
- [ ] Test shell: new terminal should be zsh
- [ ] Verify vi-mode: `bindkey -v` in zsh

### Zk System
- [ ] Symlink zk config & templates
- [ ] Test templates: `zkf --title "Test"`
- [ ] Verify YAML: check frontmatter renders correctly
- [ ] Test aliases: `zkl`, `zks`, `zke`

### Tmux
- [ ] Symlink tmux config
- [ ] Test prefix: `Ctrl-a ?` shows help
- [ ] Verify vi-mode: copy mode uses `hjkl`
- [ ] Check colors: green theme active

### Reference Guides
- [ ] Verify all reference files exist
- [ ] Test aliases: `nvimref`, `tmuxref`, etc.
- [ ] Confirm nvim opens each guide

### Services
- [ ] Start services: `systemctl --user start forgejo vaultwarden syncthing ollama`
- [ ] Verify status: `systemctl --user status forgejo`
- [ ] Check logs: `journalctl --user -u forgejo -n 20`

---

## Verification Commands

```


# Shell

echo \$SHELL                     \# /bin/zsh

ps -p \$\$                         \# zsh

# Nvim

nvim --version
nvimref                          \# Opens reference guide

# Tmux

tmux -V
tmuxref                          \# Opens reference guide

# Zk

cd /mnt/data/git/user-GNOSIS
zk list --limit 5
zkref                            \# Opens reference guide

# Services

systemctl --user status forgejo vaultwarden syncthing ollama

# Development

rustc --version
go version

# Git

cd /mnt/data/git/user-GNOSIS
git log --oneline -1

```

---

## Performance Notes

- **Shell startup:** <100ms (zsh optimized)
- **Nvim startup:** <200ms (lazy.nvim)
- **Tmux startup:** <50ms (minimal config)
- **Zk search:** <50ms (SQLite index)
- **Git operations:** <500ms (local)
- **Reference access:** Instant (nvim alias)

---

## Quick Reference

### Aliases
```

zkf, zkz, zkp, zkm, zkd, zkj, zkr  - Create notes
zkl, zks, zke                       - List/search/edit notes
nvimref, tmuxref, footref, etc.     - Open reference guides

```

### Keybindings
```

hjkl        - movement (everywhere)
/           - search (everywhere)
- command mode
Esc         - exit/cancel (everywhere)
Prefix+hjkl - tmux panes
\$mod+hjkl   - sway windows

```

### Directories
```

/mnt/data/git/user-GNOSIS/              - Knowledge base
/mnt/data/git/fa-srv-m1m/config/          - System configs
/mnt/data/git/fa-srv-m1m/config/*/REF*    - Reference guides ✨
~/.config/                                 - Symlinks

```

---

## Document History

| Version | Date | Changes |
|---------|------|---------|
| v6.0 | 2025-11-19 | **Complete reference documentation system, tmux config refinement, zk template fixes, YAML standards** ✨ |
| v5.0 | 2025-11-18 | Terminal-first unification, universal muscle memory, nvim refactor |
| v4.0 | 2025-11-16 | Portable dev env, Zettelkasten PKM, professional dotfiles |
| v3.1 | 2025-11-15 | Disaster recovery procedures |

---

## What's New in v6.0 ✨

### Reference Documentation System
- **10 complete reference guides** covering every tool
- Quick-access aliases for all guides
- Uniform format across all documentation
- Integration notes between tools
- Best practices and workflows documented

### Template System Refinements
- Fixed `{{date}}` → `{{format-date now}` across all zk templates
- Standardized YAML frontmatter (bracket array format)
- 7 production-ready templates with unified headers
- Template validation and testing procedures

### Tmux Configuration
- Best-in-class keyboard-only config
- Vi-mode throughout (status, copy, navigation)
- Ncurses green theme matching system aesthetic
- Comprehensive keybinding reference

### System Maturity
- All tools have complete documentation
- Troubleshooting guides for common issues
- Platform-specific notes (Fedora Asahi/ARM/Wayland)
- Professional-grade infrastructure demonstrating mastery

---

**Status:** ✅ **Production-Ready, Reference-Complete, Portfolio-Grade Infrastructure**

This system demonstrates senior-level:
- Infrastructure engineering (reproducible, portable, version-controlled)
- Terminal mastery (keyboard-only, vi-like universal workflow)
- Documentation excellence (comprehensive reference system)
- Knowledge management (production Zettelkasten with strict discipline)
- Professional tooling (best-in-class configs for every component)

**Total infrastructure value:** Immediate productivity on any machine, 20-minute disaster recovery, complete self-documenting system with reference guides for every tool.


