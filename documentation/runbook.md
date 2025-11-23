# System Runbook

## Overview

Production Linux infrastructure on Fedora Asahi M1 with <20-minute disaster recovery.
All system configurations are managed via `/mnt/data/git/system/toolkit/` and symlinked into home directory.

## Daily Operations

### Shell and Environment

Verify all shell configs are loaded:
exec zsh
echo $EDITOR # Should be: nvim
echo $TERM # Should be: foot
alias gs # Should resolve to: git status
alias zkf # Should resolve to: zk new --template fleeting.md

### Configuration Management

All personal configs are in `/mnt/data/git/system/toolkit/` and symlinked to:

- `~/.zshrc`, `~/.bashrc` → shell configs
- `~/.config/nvim/` → Neovim editor
- `~/.config/zk/` → Zettelkasten notebook
- `~/.config/sway/` → Window manager
- `~/.tmux.conf` → Terminal multiplexer

Any changes to source files automatically affect live system via symlinks.

## Toolkit Structure

### Shell Configuration

toolkit/shell/
├── .zshrc → ~/.zshrc
├── .bashrc → ~/.bashrc
├── .zshenv → ~/.zshenv
├── .bash_profile → ~/.bash_profile
├── aliases.sh (sourced by shells)
├── functions.sh (sourced by shells)
├── profile.sh (sourced by shells)
└── gitconfig → ~/.gitconfig

### Editors

toolkit/editors/
├── nvim/ → ~/.config/nvim
└── zk/
├── config.toml → ~/.config/zk/config.toml
└── templates/ → ~/.config/zk/templates

### Terminal and UI

toolkit/terminal/
├── foot/
│ └── foot.ini → ~/.config/foot/foot.ini
└── tmux/
└── .tmux.conf → ~/.tmux.conf

toolkit/terminal-ui/
├── fuzzel/
│ └── fuzzel.ini → ~/.config/fuzzel/fuzzel.ini
├── lazygit/
│ └── config.yml → ~/.config/lazygit/config.yml
└── vimb/
└── config → ~/.config/vimb/config

### Window Manager

toolkit/window-manager/
├── config → ~/.config/sway/config
└── colors.conf → ~/.config/sway/colors.conf

## Restoring Dotfile Symlinks (Disaster Recovery)

**Scenario:** System reinstall, corrupted symlinks, or config loss.
**Recovery time:** <5 minutes (automated).

### Step 1: Verify Source Toolkit Exists

ls -la /mnt/data/git/system/toolkit/

Should contain: editors, shell, terminal, terminal-ui, window-manager

### Step 2: Remove Broken Symlinks

Identify all broken symlinks in your home directory:

find ~ -xtype l -delete

### Step 3: Recreate All Symlinks

**Shell configs:**
ln -sf /mnt/data/git/system/toolkit/shell/.zshrc ~/.zshrc
ln -sf /mnt/data/git/system/toolkit/shell/.bashrc ~/.bashrc
ln -sf /mnt/data/git/system/toolkit/shell/.zshenv ~/.zshenv
ln -sf /mnt/data/git/system/toolkit/shell/.bash_profile ~/.bash_profile
ln -sf /mnt/data/git/system/toolkit/shell/gitconfig ~/.gitconfig

**Neovim:**
mkdir -p ~/.config
ln -sf /mnt/data/git/system/toolkit/editors/nvim ~/.config/nvim

**Zettelkasten:**
mkdir -p ~/.config/zk
ln -sf /mnt/data/git/system/toolkit/editors/zk/config.toml ~/.config/zk/config.toml
ln -sf /mnt/data/git/system/toolkit/editors/zk/templates ~/.config/zk/templates

**Tmux:**
ln -sf /mnt/data/git/system/toolkit/terminal/tmux/.tmux.conf ~/.tmux.conf

**Foot terminal:**
mkdir -p ~/.config/foot
ln -sf /mnt/data/git/system/toolkit/terminal/foot/foot.ini ~/.config/foot/foot.ini

**Fuzzel launcher:**
mkdir -p ~/.config/fuzzel
ln -sf /mnt/data/git/system/toolkit/terminal-ui/fuzzel/fuzzel.ini ~/.config/fuzzel/fuzzel.ini

**Lazygit:**
mkdir -p ~/.config/lazygit
ln -sf /mnt/data/git/system/toolkit/terminal-ui/lazygit/config.yml ~/.config/lazygit/config.yml

**Vimb browser:**
mkdir -p ~/.config/vimb
ln -sf /mnt/data/git/system/toolkit/terminal-ui/vimb/config ~/.config/vimb/config

**Sway window manager:**
mkdir -p ~/.config/sway
ln -sf /mnt/data/git/system/toolkit/window-manager/config ~/.config/sway/config
ln -sf /mnt/data/git/system/toolkit/window-manager/colors.conf ~/.config/sway/colors.conf

### Step 4: Verify All Symlinks

find ~ -type l -ls | grep system

Should show ~18 symlinks, all pointing to `/mnt/data/git/system/toolkit/`

### Step 5: Restart Shell and Applications

Restart shell to reload configs:
exec zsh

Restart Sway if running:
swaymsg reload

Restart Tmux if running:
tmux kill-server
tmux new -As main

### Step 6: Validate

Test key functionality:
nvim --version # Should work
tmux list-keys # Should show custom bindings
alias | grep git # Should show custom aliases
zk list # Should connect to Zettelkasten

## Git Workflow

### Committing Configuration Changes

All changes must use conventional commits (enforced by commitlint):

cd /mnt/data/git/system
git status
git add toolkit/shell/.zshrc
git commit -m "feat: add new shell alias"
git push origin master

Valid commit types: `feat`, `fix`, `docs`, `chore`, `refactor`, `style`, `test`, `perf`, `ci`, `build`, `revert`

### Syncing Across Systems

Changes pushed to Forgejo (localhost:PORT) are immediately available to pull on other systems.

## Service Management

### Core Services

- **Forgejo** (Git server): `http://localhost:PORT`
- **Vaultwarden** (Password manager): `http://localhost:8222`
- **Syncthing** (File sync): `http://localhost:8384`
- **Ollama** (LLM): `http://localhost:11434`

### Service Control

Check status
systemctl status forgejo vaultwarden syncthing ollama

Restart service
sudo systemctl restart forgejo

View logs
journalctl -u forgejo -f

## Backup Strategy

### Automated Backups

Forgejo backup script runs daily via cron:
/mnt/data/git/system/infrastructure/services/forgejo/scripts/backup_forgejo.sh

Backups stored in `/mnt/data/backups/forgejo/`

### Manual Backup

sudo -u git /usr/bin/forgejo dump -c /etc/forgejo/app.ini -w /tmp

### Restore from Backup

sudo systemctl stop forgejo
sudo -u git /usr/bin/forgejo restore --file /path/to/forgejo-dump.zip
sudo systemctl start forgejo

## Troubleshooting

### Broken Symlinks

Find broken symlinks
find ~ -xtype l

Remove and recreate (see Step 3 above)
find ~ -xtype l -delete

### Git Authentication Issues

Clear credential cache
git credential reject << EOF
protocol=http
host=localhost:PORT
EOF

Re-authenticate on next push
git push

### Service Won't Start

Check logs
journalctl -u service-name -n 50

Verify config
sudo service-name check-config

Check file permissions
ls -la /etc/service-name/

## Related Documentation

- **Architecture:** `/mnt/data/git/system/architecture/ARCHITECTURE.md`
- **Disaster Recovery:** `/mnt/data/git/system/automation/disaster-recovery/disaster-recovery.md`
- **System Setup:** `/mnt/data/git/system/documentation/SYSTEM-SETUPv6.0.md`
- **Tool References:** `/mnt/data/git/system/documentation/guides/*REFERENCE.md`
