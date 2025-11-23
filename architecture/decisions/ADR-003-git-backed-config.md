# ADR-003: Git-Backed Configuration Management

**Status**: Accepted  
**Date**: 2025-11-21  
**Deciders**: user  
**Last Validated**: 2025-11-23

## Context

System configuration must be:
- Version-controlled for auditability
- Reproducible across hardware migrations
- Recoverable from single repository clone
- Portable between OS reinstalls

Traditional approaches (manual edits, `/etc` modifications) create configuration drift and prevent rapid disaster recovery.

## Decision

All user-space configuration stored in `/mnt/data/git/srv-m1m/toolkit/` and symlinked to home directory. OS partition contains zero unique configuration state.

### Implementation Details

**Repository Structure**

toolkit/
├── editors/ (nvim, zk)
├── shell/ (zsh, bash, git)
├── terminal/ (foot, tmux)
├── terminal-ui/ (fuzzel, vimb)
└── window-manager/ (sway)


**Symlink Strategy**
- Home directory symlinks point to canonical toolkit files
- No configuration files stored outside Git repository
- Toolkit directory itself symlinked to `~/toolkit` for direct access

**Enforcement**
- Conventional commits enforced via commitlint hooks
- Pre-commit validation prevents non-compliant messages
- All changes documented with type/scope/subject format

## Consequences

### Positive

- **Instant recovery**: Clone repo → restore symlinks → functional system
- **Zero drift**: Configuration changes tracked via Git history
- **Auditability**: Every config modification has commit message explaining "why"
- **Portability**: Same config deployable across multiple machines
- **Collaboration**: Can share configs via Forgejo → GitHub mirror

### Negative

- **Initial complexity**: Symlink management requires discipline
- **Merge conflicts**: Simultaneous edits on multiple machines require resolution
- **Learning curve**: Team members must understand Git workflow

### Validation Metrics

| Metric                      | Value  | Last Verified |
|-----------------------------|--------|---------------|
| Total commits               | 27     | 2025-11-23    |
| Commits since 2025-01-01    | 27     | 2025-11-23    |
| Contributors                | 1      | 2025-11-23    |
| Files under version control | 46     | 2025-11-23    |
| Total config size           | 264 KB | 2025-11-23    |
| Active symlinks             | 14     | 2025-11-23    |
| Clone test result           | PASS   | 2025-11-23    |

### Symlink Coverage

/home/user/.config/nvim → toolkit/editors/nvim
/home/user/.config/zk/ → toolkit/editors/zk/
/home/user/.zshrc → toolkit/shell/.zshrc
/home/user/.zshenv → toolkit/shell/.zshenv
/home/user/.bashrc → toolkit/shell/.bashrc
/home/user/.bash_profile → toolkit/shell/.bash_profile
/home/user/.gitconfig → toolkit/shell/gitconfig
/home/user/.tmux.conf → toolkit/terminal/tmux/tmux.conf
/home/user/.config/foot/ → toolkit/terminal/foot/
/home/user/.config/fuzzel/ → toolkit/terminal-ui/fuzzel/
/home/user/.config/vimb/ → toolkit/terminal-ui/vimb/
/home/user/.config/sway/ → toolkit/window-manager/
/home/user/toolkit → /mnt/data/git/srv-m1m/toolkit


## Recovery Procedure

1. Clone repository
git clone /mnt/data/git/srv-m1m /tmp/srv-m1m

2. Restore symlinks
ln -s /mnt/data/git/srv-m1m/toolkit/editors/nvim ~/.config/nvim
ln -s /mnt/data/git/srv-m1m/toolkit/shell/.zshrc ~/.zshrc

[repeat for all 14 symlinks]
3. Verify
find ~ -maxdepth 3 -type l -ls | grep /mnt/data/git/srv-m1m | wc -l

Expected: 14


**Total time**: <5 minutes (validated 2025-11-23)

## Related Decisions

- ADR-001: External SSD Strategy (data persistence requirement)
- ADR-002: btrfs Filesystem (snapshot capability for config rollback)

## References:

- Repository: `/mnt/data/git/srv-m1m/`
- Toolkit directory: `/mnt/data/git/srv-m1m/toolkit/`
- Commitlint config: `/mnt/data/git/srv-m1m/commitlint.config.js`

