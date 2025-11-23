<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# repeat for lazygit

Create comprehensive lazygit reference guide in `/mnt/data/git/fa-srv-m1m/config/lazygit/LAZYGIT-REFERENCE.md`:

```bash
cat > /mnt/data/git/fa-srv-m1m/config/lazygit/LAZYGIT-REFERENCE.md << 'EOF'
# LAZYGIT COMPLETE REFERENCE GUIDE
**Git Terminal UI | Vi-like Interface | Git Operations Without Leaving Terminal**

---

## OVERVIEW

Lazygit is a simple, fast Git client with terminal UI:
- Vi-like keybindings throughout
- Visual branch/commit/stash management
- Fast staging/unstaging
- Interactive rebasing
- Merge/rebase conflict resolution
- No mouse required
- Integrates with system shell
- Minimal learning curve

---

## LAUNCHING LAZYGIT

```

lazygit                         \# Launch in current repo
lazygit -p /path/to/repo        \# Open specific repo
lazygit --help                  \# Show help
lazygit --version               \# Version info

```

### Launch from Git Directory
```

cd /path/to/repo
lazygit

```

### Integration with Nvim
```


# In nvim config or mapping:

:!lazygit

# Or with keybinding in init.lua

```

---

## MAIN SCREEN LAYOUT

```

┌─────────────────────────────────────────────────────────┐
│ Status  │                                               │
│─────────┼─────────────────────────────────────────────┤
│ Files   │           Commit Log / Details                │
│         │                                               │
│         │                                               │
├─────────┼─────────────────────────────────────────────┤
│Branches │           Main Content Area                   │
│Remotes  │                                               │
│Stash    │                                               │
└─────────┴─────────────────────────────────────────────┘

```

### Panels
```

Left Panel:

- Status
- Files/Diffs
- Branches/Remotes
- Stash
- Commits

Main Area:

- Commit details
- Diff view
- Branch logs
- Merge/Rebase info

```

---

## NAVIGATION

### Movement Keys (Vi-like)
```

j                               \# Down
k                               \# Up
h                               \# Left/Collapse
l                               \# Right/Expand
g                               \# Top
G                               \# Bottom
Ctrl+f                          \# Page down
Ctrl+b                          \# Page up

```

### Panel Navigation
```

Tab                             \# Next panel
Shift+Tab                       \# Previous panel
1                               \# Status panel
2                               \# Files panel
3                               \# Branches panel
4                               \# Commits panel
5                               \# Stash panel

```

### Jumping & Searching
```

/                               \# Search
?                               \# Search (reverse)
n                               \# Next match
N                               \# Previous match
Ctrl+g                          \# Go to line

```

---

## FILE MANAGEMENT

### File Operations
```

Space                           \# Stage/Unstage file
a                               \# Stage all
u                               \# Unstage all
c                               \# Commit (opens editor)
C                               \# Commit with custom message
A                               \# Amend commit
d                               \# Discard changes
D                               \# Discard (force)
e                               \# Edit file in \$EDITOR
o                               \# Open file externally
i                               \# Add to .gitignore
r                               \# Refresh

```

### File Viewing
```

Enter                           \# View file diff
m                               \# View merge/conflict
v                               \# View file in editor
y                               \# Copy filename to clipboard
x                               \# Delete file

```

### Selective Staging (Hunks)
```

Space                           \# Stage/unstage hunk
v                               \# Visual select lines
J                               \# Select down
K                               \# Select up
Enter                           \# Stage selected lines
d                               \# Discard selected lines

```

---

## STAGING & COMMITTING

### Staging Workflow
```


# In Files panel:

Space                           \# Stage file
a                               \# Stage all
u                               \# Unstage all
Ctrl+Space                      \# Stage individual hunks

```

### Committing
```

c                               \# Open commit message editor
C                               \# Commit with custom message
Ctrl+o                          \# Create commit object
Escape                          \# Cancel commit

```

### Amending
```

A                               \# Amend last commit

# Edit message in editor

# Save and close to apply

```

### Fix-up & Squash
```


# In commit panel:

f                               \# Create fixup commit
s                               \# Create squash commit

# Use during rebase to merge

```

---

## BRANCHING

### Branch Operations
```

n                               \# New branch
d                               \# Delete branch
D                               \# Force delete
r                               \# Rename branch
m                               \# Merge branch
R                               \# Rebase branch
t                               \# Create tag
T                               \# Delete tag
f                               \# Fetch
g                               \# Pull
P                               \# Push
u                               \# Set upstream

```

### Branch Navigation
```


# In Branches panel:

j k                             \# Navigate branches
Enter                           \# Checkout branch
Space                           \# Check branch (preview)
o                               \# Create from branch

```

### Create Branch
```

n                               \# New branch

# Type branch name

# Press Enter to confirm

```

### Checkout Branch
```


# Navigate to branch

Enter                           \# Switch branch

# Or:

o                               \# Checkout branch (same)

```

---

## REBASING & MERGING

### Interactive Rebase
```

r                               \# Start rebase

# In rebase editor:

# p - pick commit

# r - reword commit

# e - edit commit

# s - squash commit

# f - fixup commit (no message)

# x - exec command

# d - drop commit

```

### Rebase Actions
```


# In Commits panel during rebase:

Space                           \# Pick/unpick commit
e                               \# Edit commit
m                               \# Move commit up
M                               \# Move commit down
d                               \# Drop commit
J                               \# Join with previous
r                               \# Reword commit
c                               \# Revert commit

```

### Continue/Abort Rebase
```

m                               \# Continue rebase
Esc                             \# Abort rebase

# Or in status:

:git rebase --abort

```

### Merge Branch
```


# In Branches panel:

m                               \# Merge selected branch

# Or in status:

:git merge {branch}

```

---

## CONFLICT RESOLUTION

### Detect Conflicts
```


# Conflicts shown in red in Files panel

# Lazygit shows merge status

```

### Resolve Conflicts
```


# Open conflicted file in editor:

e                               \# Edit file

# Manually resolve conflicts

# Save file

Space                           \# Stage resolved file
c                               \# Commit merge

```

### Conflict Markers
```

<<<<<<<                         \# Start of conflict
=======                         \# Separator
>>>>>>>                         \# End of conflict

```

### Use Ours/Theirs
```


# In conflict resolution view:

o                               \# Use ours (current branch)
t                               \# Use theirs (incoming)
b                               \# Use both

```

---

## STASHING

### Stash Operations
```


# In Files panel with uncommitted changes:

s                               \# Stash changes

# Or:

:git stash

```

### Stash Management
```


# In Stash panel:

Space                           \# Apply stash
Enter                           \# Apply \& pop stash
d                               \# Delete stash
g                               \# Pop stash
z                               \# Apply stash (from main)

```

### View Stash Content
```


# Navigate to stash in left panel

Enter                           \# View stash diff

# Space to apply

```

---

## COMMITS

### Commit Inspection
```


# In Commits panel:

j k                             \# Navigate commits
Enter                           \# View commit details
d                               \# View commit diff
o                               \# Open commit in browser (if URL)

```

### Copy Commit Info
```

y                               \# Copy commit hash
Y                               \# Copy commit URL

```

### Cherry-Pick
```


# Navigate to commit

c                               \# Cherry-pick commit

# Confirm action

```

### Revert Commit
```


# Navigate to commit

t                               \# Create revert commit

# Or:

r                               \# Revert (alternative)

```

### Mark Commits
```

m                               \# Mark commit

# Use during rebase operations

```

---

## REMOTES & TRACKING

### Remote Operations
```


# In Remotes panel:

f                               \# Fetch from remote
F                               \# Force fetch
P                               \# Push to remote
U                               \# Pull from remote

```

### Upstream Tracking
```


# In Branches panel:

u                               \# Set upstream

# Or auto-set on first push

```

### Track Remote Branch
```


# Navigate to remote branch

Enter                           \# Create local tracking branch

```

### Delete Remote Branch
```


# In Remotes panel:

d                               \# Delete remote branch

# Confirm action

```

---

## TAGS

### Tag Operations
```


# In Commits panel:

t                               \# Create tag
T                               \# Delete tag
g                               \# View tag
p                               \# Push tag

```

### Tag Management
```


# In left panel, Tags section:

Enter                           \# Checkout tag
d                               \# Delete tag
o                               \# Open tag info

```

---

## SEARCH & FILTER

### Search Commits
```

/                               \# Search forward
?                               \# Search backward
n                               \# Next match
N                               \# Previous match
Escape                          \# Exit search

```

### Search in Files
```


# In Files panel:

/                               \# Filter files

# Type pattern

# Only matching files shown

```

### Search History
```


# In Commits panel:

/                               \# Search commit messages

# Type search term

# Matches highlighted

```

---

## COMMAND PALETTE

### Access Commands
```

                              # Command palette
    
# Type command name

# Suggestions appear

Enter                           \# Execute command

```

### Common Commands
```

:git {git-command}              \# Execute git command
:reset                          \# Reset changes
:revert                         \# Revert changes
:stash                          \# Stash changes
:help                           \# Show help
:config                         \# Show config

```

### Git Commands in Palette
```

:git status
:git log
:git diff
:git show
:git fetch
:git push
:git pull

```

---

## STATUS & INFO

### Status Panel
```


# Shows:

- Current branch
- Tracking status
- Upstream status
- Merge/Rebase state
- Work in progress info

```

### View Status Details
```


# Select Status panel

Enter                           \# View details
o                               \# Open status file

```

---

## CONFIGURATION

### Config File Location
```

~/.config/lazygit/config.yml

```

### Basic Configuration
```

gui:
theme:
activeTextColor:
- bold
- green
authorColors:
"*": "magenta"

keybinding:
universal:
quit: "q"
search: "/"
scrollUpMain: "<c-u>"
scrollDownMain: "<c-d>"

```

### Custom Keybindings
```

keybinding:
commits:
squashDown: "z"
moveDown: "<c-j>"
moveUp: "<c-k>"
branches:
rebaseBranch: "r"
mergeIntoCurrentBranch: "m"

```

### Theme Configuration
```

gui:
theme:
selectedLineBgColor:
- "reverse"
selectedRangeBgColor:
- "blue"

```

---

## QUICK WORKFLOWS

### Daily Workflow
```

lazygit

# 1. View Files panel

# 2. Stage changes (Space)

# 3. Commit (c)

# 4. Push (P)

```

### Feature Branch Workflow
```


# 1. Create branch (n)

# 2. Make changes

# 3. Stage \& commit

# 4. Push (P)

# 5. Merge back (m)

```

### Rebase & Cleanup
```


# 1. Navigate to branch

# 2. Rebase onto main (R)

# 3. Interactive rebase (r)

# 4. Squash/reword commits

# 5. Push with force-with-lease (P)

```

### Conflict Resolution
```


# 1. Merge branch (m)

# 2. View conflicts (Files panel, red)

# 3. Edit conflicted files (e)

# 4. Resolve conflicts

# 5. Stage (Space)

# 6. Commit (c)

```

---

## INTEGRATION WITH OTHER TOOLS

### With Nvim
```


# From nvim:

:!lazygit

# Or use keybinding:

nnoremap <leader>gg :!lazygit<CR>

```

### With Tmux
```


# In tmux pane:

lazygit

# All git operations in terminal

# hjkl navigation matches tmux

```

### With Zsh
```


# Alias in ~/.zshrc:

alias lg='lazygit'

# Or function:

lazygit_session() {
cd "\$1" \&\& lazygit
}

```

### With Foot Terminal
```


# Launch lazygit in foot:

foot lazygit

# Or within foot:

lazygit

```

---

## ADVANCED OPERATIONS

### Worktrees
```


# View worktrees in left panel

# Switch between worktrees (Space)

# Create new worktree

```

### Submodules
```


# View submodules in Branches panel

# Update submodules

# Navigate into submodule

```

### Bisect
```


# Use git bisect through command palette:

:git bisect start
:git bisect bad
:git bisect good {commit}

# Mark commits as bad/good

```

### Notes
```


# View git notes

# Add notes to commits

# Edit commit notes

```

---

## TROUBLESHOOTING

### View Git Output
```


# Status panel shows git state

# Press Enter for details

# Check branch/remote info

```

### Common Issues

**Changes not showing:**
```

r                               \# Refresh

# Or exit and reopen

```

**Merge/Rebase stuck:**
```

:git status                     \# Check state
:git merge --abort              \# Abort merge
:git rebase --abort             \# Abort rebase

```

**Push fails:**
```


# Fetch first:

f                               \# Fetch

# Pull if behind:

U                               \# Pull

# Then push:

P                               \# Push

```

---

## KEYBOARD REFERENCE

### Universal Keys
```

Tab                             \# Next panel
Shift+Tab                       \# Previous panel
?                               \# Help/keybindings
q                               \# Quit
Esc                             \# Cancel/Back

```

### Common Keys by Context
```

Status Panel:

- View status details

Files Panel:
Space       - Stage/unstage
d           - Discard
e           - Edit
c           - Commit

Branches Panel:
n           - New branch
d           - Delete
m           - Merge
r           - Rebase

Commits Panel:
d           - Delete
r           - Reword
s           - Squash
c           - Cherry-pick

```

---

## SYSTEM ALIASES

### Quick Launch
```


# In ~/.zshrc or ~/.bashrc:

alias lg='lazygit'
alias lgd='lazygit -p ~/project'
alias lgc='lazygit -p ~/.config'

```

### Reference Aliases
```

alias gitref='nvim /mnt/data/git/fa-srv-m1m/config/git/GIT-REFERENCE.md'
alias lgref='nvim /mnt/data/git/fa-srv-m1m/config/lazygit/LAZYGIT-REFERENCE.md'

```

---

## VI-LIKE INTEGRATION

### Unified Keybindings
```

Across all tools:
hjkl        - navigation
/           - search
- command mode
Space       - select/action
Esc         - cancel/exit

Lazygit fits seamlessly into:
nvim (hjkl editing)
↓
lazygit (hjkl + git operations)
↓
tmux (hjkl pane switching)
↓
zsh (command execution)

```

---

## RESOURCES & HELP

```

lazygit --help                  \# Command help
?                               \# In-app help (keybindings)
man lazygit                     \# Manual (if installed)
https://github.com/jesseduffield/lazygit  \# GitHub
~/.config/lazygit/config.yml    \# Your config

```

---

**Last Updated:** 2025-11-19  
**System:** Fedora Asahi | M1 Mac Mini  
**Integration:** nvim → lazygit → git | Terminal Git UI

EOF
```

Usage reference alias:

```bash
# Add to ~/.zshrc or ~/.bashrc
alias lgref='nvim /mnt/data/git/fa-srv-m1m/config/lazygit/LAZYGIT-REFERENCE.md'
```

This reference covers all lazygit operations—navigation, staging, committing, branching, rebasing, conflict resolution, and integration with your nvim/tmux/zsh ecosystem while maintaining vi-like keybindings throughout.

