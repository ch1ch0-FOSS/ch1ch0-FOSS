# GIT COMPLETE REFERENCE GUIDE
**Version Control | CLI Workflow | Professional Standards**

---

## OVERVIEW

Git is a distributed version control system:
- Track changes across time
- Collaborate with teams
- Manage branches and merges
- Rewrite history responsibly
- Atomic commits
- Offline-first workflow
- Industry standard

---

## INITIAL SETUP

### Global Configuration
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global core.editor "nvim"
git config --global init.defaultBranch main
git config --global pull.rebase true

text

### Local Repository Configuration
cd /repo
git config user.name "Project Name" # Project-specific user
git config user.email "project@example.com"
git config core.ignorecase false # Case-sensitive

text

### View Configuration
git config --list # All settings
git config --list --global # Global only
git config --list --local # Local only
git config user.name # Specific value

text

---

## REPOSITORY INITIALIZATION

### Create New Repository
git init # Initialize in current dir
git init {directory} # Initialize new directory
git init --bare {name}.git # Bare repository (server)
git init --template={path} # Use template

text

### Clone Repository
git clone {url} # Clone to local dir
git clone {url} {directory} # Clone to specific dir
git clone --depth 1 {url} # Shallow clone (fast)
git clone --branch {branch} {url} # Clone specific branch
git clone --single-branch {url} # Single branch only
git clone --bare {url} # Bare clone

text

---

## STATUS & INFORMATION

### Check Repository Status
git status # Current status
git status -s # Short status
git status -sb # Short with branch
git status --porcelain # Machine-readable

text

### View Log
git log # Full commit history
git log --oneline # One line per commit
git log --graph --all --decorate # Graph visualization
git log -10 # Last 10 commits
git log -p # Show diffs
git log --stat # Show statistics
git log --author="name" # By author
git log --grep="pattern" # By message
git log --since="2 weeks ago" # Date range
git log --until="2025-11-01"
git log -S "string" # By content change
git log --follow {file} # File history (with renames)

text

### View Differences
git diff # Unstaged changes
git diff --staged # Staged changes
git diff HEAD # All changes vs HEAD
git diff {commit1} {commit2} # Between commits
git diff {branch1} {branch2} # Between branches
git diff --stat # Statistics
git diff --no-color | less # Paged output
git diff > patch.diff # Save diff

text

### Show Commit Details
git show {commit} # Show commit
git show {commit}:{file} # File at commit
git show HEAD # Latest commit
git show HEAD~1 # Previous commit
git show {branch}:{path} # File on branch

text

---

## STAGING & COMMITTING

### Stage Changes
git add {file} # Stage specific file
git add . # Stage all changes
git add -A # Stage all (including deletions)
git add -p # Interactive patch (hunk-by-hunk)
git add -u # Stage tracked modifications/deletions
git add --all # Stage everything

text

### Unstage Changes
git reset {file} # Unstage file
git reset # Unstage all
git reset HEAD~1 # Undo last commit (keep changes)
git reset --soft HEAD~1 # Undo commit, keep staged
git reset --hard HEAD~1 # Undo commit, discard changes
git reset --hard origin/main # Reset to remote

text

### Discard Changes
git checkout {file} # Discard file changes
git checkout . # Discard all changes
git restore {file} # Modern alternative (git 2.23+)
git restore --staged {file} # Unstage file
git clean -fd # Remove untracked files/dirs
git clean -fX # Remove ignored files

text

### Commit
git commit # Interactive commit
git commit -m "message" # Commit with message
git commit -am "message" # Stage+commit tracked
git commit --amend # Modify last commit
git commit --amend --no-edit # Amend without changing message
git commit -m "msg" --author="name <email>" # Override author
git commit --date="2025-11-10" # Set commit date
git commit --allow-empty -m "msg" # Empty commit (for triggers)

text

### Commit Best Practices
Format: <type>(<scope>): <subject>

<type>: feat, fix, refactor, docs, style, test, chore, perf
<scope>: component/area (optional)
<subject>: lowercase, imperative, no period, max 50 chars

feat(auth): add JWT token validation
fix(ui): correct button alignment on mobile
docs: update README installation steps

text

---

## BRANCHES

### List Branches
git branch # Local branches
git branch -a # All branches (local + remote)
git branch -v # With commit info
git branch -vv # With tracking info
git branch --list "pattern" # Filter by pattern
git branch -r # Remote branches only

text

### Create Branch
git branch {branch-name} # Create branch
git branch {branch-name} {commit} # From specific commit
git branch -b {branch-name} # Create from current (git 2.23+)
git checkout -b {branch-name} # Create & switch
git switch -c {branch-name} # Modern alternative
git branch --orphan {name} # Orphan branch (no history)

text

### Switch Branches
git checkout {branch} # Switch branch
git switch {branch} # Modern alternative
git checkout - # Previous branch
git checkout -- {file} # Discard changes in file
git switch -c {branch} # Create & switch

text

### Rename Branch
git branch -m {old} {new} # Rename local branch
git branch -m {new} # Rename current branch
git push origin -{old} {new} # Push renamed (if remote exists)
git push origin -u {new} # Set upstream

text

### Delete Branch
git branch -d {branch} # Delete (safe)
git branch -D {branch} # Force delete
git push origin --delete {branch} # Delete remote
git branch -dr origin/{branch} # Delete remote tracking
git push origin :{branch} # Legacy delete remote

text

### Track Remote Branch
git branch -u origin/{branch} # Set upstream
git branch --set-upstream-to=origin/{branch}
git branch -vv # Show tracking

text

---

## REMOTES

### List Remotes
git remote # List remote names
git remote -v # With URLs
git remote show {name} # Details

text

### Add Remote
git remote add {name} {url} # Add remote
git remote add origin git@github.com:user/repo.git
git remote add upstream https://github.com/original/repo.git

text

### Remove Remote
git remote remove {name} # Remove remote
git remote rm {name} # Short form

text

### Modify Remote
git remote set-url {name} {new-url} # Change URL
git remote rename {old} {new} # Rename remote
git remote set-url --add {name} {url} # Add another URL

text

### Fetch Updates
git fetch # Fetch from default remote
git fetch {remote} # From specific remote
git fetch --all # From all remotes
git fetch --prune # Remove deleted remote branches
git fetch --tags # Fetch tags

text

---

## PULLING & PUSHING

### Pull Changes
git pull # Fetch + merge (default remote)
git pull {remote} {branch} # From specific remote/branch
git pull --rebase # Fetch + rebase (no merge commit)
git pull --squash # Squash commits before merge
git pull --no-ff # Force merge commit

text

### Push Changes
git push # Push to default remote
git push {remote} {branch} # Push to specific
git push -u origin {branch} # Push & set upstream
git push --all # Push all branches
git push --tags # Push all tags
git push {remote} --delete {branch} # Delete remote branch
git push origin :{branch} # Legacy delete remote
git push --force-with-lease # Force push (safer)
git push --force # Force push (dangerous)

text

### Push Tags
git push origin {tag} # Push specific tag
git push origin --tags # Push all tags
git push origin --delete {tag} # Delete remote tag

text

---

## MERGING

### Merge Branches
git merge {branch} # Merge into current
git merge --no-ff {branch} # Always create merge commit
git merge --squash {branch} # Squash commits
git merge --no-commit {branch} # Merge without committing
git merge -m "msg" {branch} # Custom merge message

text

### Merge Conflicts
After merge conflict:
git status # Show conflicts
git diff # Show diff

Edit files manually to resolve
After resolving:
git add {resolved-file}
git commit -m "Merge conflicts resolved"

text

### Abort Merge
git merge --abort # Undo merge
git reset --hard HEAD # Reset to before merge

text

---

## REBASING

### Rebase Branch
git rebase {branch} # Rebase onto branch
git rebase -i HEAD~3 # Interactive rebase last 3
git rebase -i {commit} # Interactive from commit
git rebase --continue # Continue after conflict
git rebase --abort # Undo rebase
git rebase --skip # Skip current commit

text

### Interactive Rebase Operations
pick - use commit
reword - use commit, edit message
edit - use commit, stop for editing
squash - use commit, meld into previous
fixup - like squash, discard message
drop - remove commit

text

### Rebase Onto Another Branch
git rebase --onto {new-base} {old-base} {branch}
git rebase --onto main feature develop # Rebase develop onto main

text

---

## CHERRY-PICKING

### Cherry-Pick Commits
git cherry-pick {commit} # Apply commit
git cherry-pick {commit1} {commit2} # Multiple commits
git cherry-pick {start}..{end} # Range (inclusive)
git cherry-pick {start}^..{end} # Range (exclusive start)

text

### Handle Conflicts
git cherry-pick --continue # Continue after resolving
git cherry-pick --abort # Abort cherry-pick
git cherry-pick --quit # Quit (keep changes)

text

---

## STASHING

### Stash Changes
git stash # Stash current changes
git stash save "description" # With description
git stash push -m "msg" # With message
git stash push {file} # Specific file
git stash -u # Include untracked

text

### Manage Stashes
git stash list # Show all stashes
git stash show # Show latest stash
git stash show -p # Show diff
git stash show stash@{2} # Specific stash
git stash drop # Delete latest
git stash drop stash@{2} # Delete specific
git stash clear # Delete all

text

### Apply Stashes
git stash pop # Apply & delete
git stash apply # Apply (keep)
git stash apply stash@{2} # Apply specific
git stash branch {branch-name} # Create branch from stash

text

---

## TAGGING

### Create Tags
git tag {tag-name} # Lightweight tag
git tag -a {tag-name} -m "msg" # Annotated tag
git tag -a {tag-name} {commit} -m "msg" # Tag specific commit
git tag {tag-name} HEAD~1 # Tag previous commit

text

### List Tags
git tag # List all tags
git tag -l "pattern" # Filter tags
git tag -l -n3 # With annotations (3 lines)
git show {tag} # Show tag details

text

### Push Tags
git push origin {tag} # Push specific
git push origin --tags # Push all tags
git push origin --follow-tags # Push commits & tags

text

### Delete Tags
git tag -d {tag} # Delete local
git push origin --delete {tag} # Delete remote
git push origin :{tag} # Legacy delete

text

---

## HISTORY REWRITING

### Amend Last Commit
git commit --amend # Modify last commit
git commit --amend --no-edit # Keep message
git commit --amend --author="name <email>" # Change author

text

### Reset Commits
git reset --soft HEAD~1 # Undo, keep staged
git reset --mixed HEAD~1 # Undo, unstage
git reset --hard HEAD~1 # Undo, discard
git reset --hard {commit} # Reset to commit

text

### Revert Commits
git revert {commit} # Create undo commit
git revert HEAD # Revert latest
git revert -m 1 {commit} # Revert merge (keep first parent)
git revert {commit1}..{commit2} # Multiple commits

text

### Clean History
git filter-branch # Rewrite history (advanced)
git filter-repo # Modern alternative

Use with caution on shared repos
text

---

## SEARCHING & INSPECTING

### Search Commits
git log --grep="pattern" # By message
git log -S "string" # By content
git log -G "regex" # By regex content
git log --author="name" # By author
git log --before="2025-11-01" # Date range
git log --oneline | grep "search"

text

### Find Commits
git bisect start # Binary search for issue
git bisect bad HEAD # Mark current as bad
git bisect good {commit} # Mark known good

Then test and mark as bad/good until found
git bisect reset # End bisect

text

### Blame & History
git blame {file} # Show who changed each line
git blame -L {start},{end} {file} # Specific lines
git log --follow -p {file} # File history with diffs
git log --stat {file} # File statistics

text

### Find Deleted Content
git log -p -S "deleted content" --all # Find deletion
git reflog # Find lost commits
git fsck --lost-found # Recover lost objects

text

---

## WORKFLOWS

### Feature Branch Workflow
git checkout -b feature/login-system # Create feature branch

Make changes
git add .
git commit -m "feat(auth): implement login"
git push -u origin feature/login-system # Push feature

Create pull request on GitHub
git pull origin main # Sync main
git rebase main # Rebase feature
git push --force-with-lease # Force push after rebase

Merge PR and delete remote branch
git checkout main
git pull
git branch -d feature/login-system # Delete local

text

### Hotfix Workflow
git checkout -b hotfix/critical-bug # From main

Fix bug
git add .
git commit -m "fix: critical bug in payment"
git push -u origin hotfix/critical-bug

Merge to main & develop
git checkout main
git merge --no-ff hotfix/critical-bug
git push origin main
git tag -a v1.0.1 -m "Release 1.0.1"
git push --tags

text

### Release Workflow
git checkout -b release/1.1.0 # From develop

Update version, changelog
git commit -a -m "chore: bump version to 1.1.0"
git push -u origin release/1.1.0

Merge to main
git checkout main
git merge --no-ff release/1.1.0 -m "Release 1.1.0"
git tag -a v1.1.0
git push origin main --follow-tags

Merge back to develop
git checkout develop
git merge --no-ff release/1.1.0
git push origin develop

text

---

## COLLABORATION

### Work with Forks
git clone {your-fork-url} # Clone your fork
git remote add upstream {original-url} # Add upstream
git fetch upstream # Sync fork
git rebase upstream/main # Update fork
git push origin main # Push updates

text

### Pull Request Workflow
git checkout -b feature/new-feature # Create branch

Make changes
git push -u origin feature/new-feature

Create PR on GitHub/GitLab
Address review comments
git push # Auto-updates PR

Merge via UI
git checkout main
git pull
git branch -d feature/new-feature

text

### Sync Local Repository
git fetch origin # Get updates
git merge origin/main # Or rebase
git pull --rebase # Fetch + rebase

text

---

## CLEANUP & MAINTENANCE

### Clean Repository
git clean -fd # Remove untracked files
git clean -fX # Remove ignored files
git gc # Garbage collection
git reflog expire --expire=now --all
git fsck --unreachable

text

### Prune Branches
git remote prune origin # Remove stale remote refs
git branch -d merged-branch # Delete merged branches
for branch in $(git branch | grep -v main); do
git branch -d $branch 2>/dev/null
done

text

### Archive Repository
git archive --format=tar HEAD > snapshot.tar # Create archive
git archive --format=zip HEAD > snapshot.zip
git archive -o snapshot.tar v1.0.0 # Archive tag

text

---

## ADVANCED OPERATIONS

### Submodules
git submodule add {url} {path} # Add submodule
git clone --recursive {url} # Clone with submodules
git submodule update --recursive # Update all submodules
git submodule foreach git pull # Pull all submodules

text

### Worktrees
git worktree list # List work trees
git worktree add {path} {branch} # Create worktree
git worktree remove {path} # Remove worktree

text

### Hooks
ls -la .git/hooks/ # View hooks
cat .git/hooks/pre-commit.sample # Example hook

Hooks: pre-commit, commit-msg, post-commit, pre-push, etc.
text

---

## GIT ALIASES

### Create Aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual 'log --graph --oneline --all --decorate'
git config --global alias.amend 'commit --amend --no-edit'
git config --global alias.undo 'reset --soft HEAD~1'

text

### Common Aliases
git co {branch} # Checkout
git br -a # List branches
git ci -m "msg" # Commit
git st # Status
git unstage {file} # Unstage
git last # Last commit
git visual # Graph log
git amend # Amend last
git undo # Undo last commit

text

---

## DEBUGGING

### Find Issues
git status # Current status
git diff # Unstaged changes
git log --oneline # Commit history
git reflog # Reference logs
git fsck # Integrity check
git gc --aggressive # Optimize repo

text

### Get Help
git help {command} # Command help
git {command} -h # Short help
man git-{command} # Manual
git help -a # All commands

text

---

## INTEGRATION WITH SYSTEM

### With Tmux/Zsh
Status in prompt:
Add git branch to PS1
Example: git-prompt.sh
Useful in workflows:
git add . && git commit -m "msg" && git push

text

### With Nvim
Git integration plugins:
vim-fugitive, neogit, git-worktree.nvim
Built-in keybindings possible
Direct integration:
:!git log --oneline -10 # Run git in nvim
:read !git status # Insert git output

text

### With Foot Terminal
Git output colorization:
git config --global color.ui true
git log --graph --pretty --all --abbrev-commit

Within foot + tmux:
All git commands work seamlessly
Copy/paste colored output via tmux
text

---

## BEST PRACTICES

### Commit Quality
Atomic commits (one logical change per commit)

Clear, descriptive messages

Avoid mixing concerns

Test before committing

Sign commits: git commit -S

text

### Branch Strategy
main: production-ready, always stable

develop: integration branch

feature/*: new features

hotfix/*: critical fixes

release/*: prepare release

text

### Collaboration
Pull before push

Use descriptive branch names

Request reviews before merge

Rebase when needed, never force-push to main

Clean up merged branches

text

---

## SYSTEM INTEGRATION

### .gitignore
*.log
*.o
*.so
*.a
node_modules/
.venv/
dist/
build/
.DS_Store

text

### .gitattributes
*.md text
*.json text
*.bin binary
*.png binary

text

---

**Last Updated:** 2025-11-19  
**System:** Fedora Asahi | M1 Mac Mini  
**Integration:** nvim → zk → git | Version control & collaboration

EOF
Usage reference alias:

bash
# Add to ~/.zshrc
alias gitref='nvim /mnt/data/git/fa-system/config/git/GIT-REFERENCE.md'
This reference covers all git operations—initialization, staging, branching, merging, history management, collaboration workflows, and integration with your nvim/tmux/zk ecosystem.
