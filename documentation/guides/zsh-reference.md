<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# repeat for zsh

Create comprehensive zsh reference guide in `/mnt/data/git/fa-system/config/zsh/ZSH-REFERENCE.md`:

```bash
cat > /mnt/data/git/fa-system/config/zsh/ZSH-REFERENCE.md << 'EOF'
# ZSH COMPLETE REFERENCE GUIDE
**Z Shell | Advanced Interactive Shell | Command-Line Mastery**

---

## OVERVIEW

Zsh is a powerful interactive shell featuring:
- Advanced completion system
- Globbing patterns (extended)
- Command history (persistent, searchable)
- Prompt customization
- Vi-like keybindings (optional)
- Plugin ecosystem (oh-my-zsh, zim)
- Scripting capabilities
- Job control & background operations

---

## STARTUP & CONFIGURATION

### Configuration Files
```

~/.zshenv          - Environment variables (always sourced)
~/.zprofile        - Login shell initialization
~/.zshrc           - Interactive shell configuration
~/.zlogout         - Logout commands

```

### Startup Order
```

zsh login shell:

1. /etc/zsh/zshenv
2. ~/.zshenv
3. /etc/zsh/zprofile
4. ~/.zprofile
5. /etc/zsh/zshrc
6. ~/.zshrc

zsh non-login (interactive):

1. /etc/zsh/zshenv
2. ~/.zshenv
3. /etc/zsh/zshrc
4. ~/.zshrc
```

### Set Default Shell
```

chsh -s /usr/bin/zsh           \# Change shell to zsh
echo \$SHELL                     \# Verify shell

```

---

## HISTORY

### History Variables
```

HISTORY=5000                   \# Lines to save
SAVEHIST=5000                  \# Lines to load
HISTFILE=~/.zsh_history        \# History file location

```

### History Configuration
```


# In ~/.zshrc:

setopt EXTENDED_HISTORY         \# Save timestamp
setopt SHARE_HISTORY            \# Share between sessions
setopt HIST_IGNORE_DUPS         \# Don't save duplicates
setopt HIST_IGNORE_SPACE        \# Ignore lines starting with space
setopt HIST_FIND_NO_DUPS        \# Don't show duplicates in search
setopt HIST_SAVE_NO_DUPS        \# No duplicate saves
setopt INC_APPEND_HISTORY       \# Immediate append

```

### History Commands
```

history                         \# Show history
history -n 20                   \# Last 20 commands
history 10 20                   \# Lines 10-20
history | grep "pattern"        \# Search history
fc                              \# Edit last command
fc -l                           \# List recent commands
fc -l -20                       \# Last 20
fc {start} {end}                \# Edit range

```

### History Search
```


# Interactive history search:

Ctrl+r                          \# Search backward
Ctrl+s                          \# Search forward (if enabled)

# Type pattern, press Ctrl+r to find

# Keep pressing Ctrl+r for next match

# Press Enter to execute

# Press Esc to cancel

```

### History Shortcuts
```

!!                              \# Last command
!\$                              \# Last argument
!*                              \# All arguments
!{n}                            \# Command n
!-{n}                           \# n commands back
!{string}                       \# Last command starting with string
^old^new                        \# Replace old with new

```

---

## COMMAND COMPLETION

### Basic Completion
```


# Type partial command/path and press Tab

cd /home/us<Tab>               \# Completes to /home/user
ls file<Tab>                   \# Completes filename
git comm<Tab>                  \# Completes to git commit

```

### Advanced Completion
```


# Configure in ~/.zshrc:

autoload -Uz compinit
compinit

# Use menu selection:

zstyle ':completion:*' menu select

```

### Completion Types
```

command completion              \# Available commands
option completion              \# Command flags/options
path completion                \# File/directory paths
variable completion            \# \$VARIABLE names
function completion            \# Available functions
alias completion               \# Defined aliases

```

### Complete on Multiple Triggers
```

setopt MENU_COMPLETE            \# Start menu immediately
setopt AUTO_LIST                \# List on ambiguous completion

```

---

## KEYBINDINGS

### Vi-Mode
```


# In ~/.zshrc:

bindkey -v                      \# Enable vi-mode

# Default is emacs-mode (like bash)

bindkey -e                      \# Enable emacs-mode

```

### Vi-Mode Keybindings
```

Normal Mode:
h l                 - move cursor left/right
j k                 - move cursor down/up (history)
I A                 - insert at start/end
x                   - delete character
dd                  - delete line
yy                  - copy line
p P                 - paste after/before
u                   - undo
Ctrl+r              - redo
/                   - search forward
?                   - search backward
n N                 - next/previous match
v                   - visual mode (edit)
Escape              - exit mode

Insert Mode:
Escape              - exit to normal mode

```

### Emacs-Mode (Default)
```

Ctrl+a              - beginning of line
Ctrl+e              - end of line
Ctrl+k              - kill to end of line
Ctrl+u              - kill to start of line
Ctrl+d              - delete character
Ctrl+h              - backspace
Ctrl+r              - search history backward
Ctrl+s              - search history forward
Alt+f               - forward word
Alt+b               - backward word
Alt+d               - delete word

```

### Custom Keybindings
```


# In ~/.zshrc:

bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Vi-mode specific:

bindkey -M viins 'Ctrl+e' end-of-line
bindkey -M vicmd 'v' edit-command-line

```

---

## PROMPT CUSTOMIZATION

### Simple Prompt
```


# In ~/.zshrc:

PROMPT='%n@%m:%~ \$ '            \# user@host:cwd \$
PROMPT='%F{green}%n%f:%~ \$ '    \# Colored username

```

### Prompt Variables
```

%n              - username
%m              - hostname
%M              - full hostname
~               - home directory (expands to ~)
%~              - current directory (~ for home)
%d              - current directory (full path)
%/              - current directory (full path)
%T              - time HH:MM
%D              - date YY-MM-DD
%w              - day
%*              - time HH:MM:SS

```

### Colored Prompts
```


# 8 colors available:

%F{red}     red
%F{green}   green
%F{yellow}  yellow
%F{blue}    blue
%F{magenta} magenta
%F{cyan}    cyan
%F{white}   white
%F{black}   black
%f          reset color

PROMPT='%F{cyan}[%T]%f %F{green}%n%f:%F{blue}%~%f \$ '

```

### Git in Prompt (with vcs_info)
```


# In ~/.zshrc:

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT='\${vcs_info_msg_0_}'
zstyle ':vcs_info:git:*' formats '%b'

```

### Multi-line Prompt
```

PROMPT='%F{green}%n@%m%f
%F{blue}%~%f
%F{yellow}❯%f '

```

---

## ALIASES

### Create Aliases
```


# In ~/.zshrc:

alias ll='ls -lah'
alias la='ls -la'
alias l='ls -CF'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias cp='cp -i'
alias rm='rm -i'

```

### Global Aliases (work anywhere on line)
```


# In ~/.zshrc:

alias -g G='| grep'
alias -g H='| head'
alias -g T='| tail'
alias -g L='| less'

# Usage:

cat logfile G error L

# = cat logfile | grep error | less

```

### Suffix Aliases
```


# In ~/.zshrc:

alias -s md=nvim
alias -s pdf='mupdf'
alias -s zip='unzip -l'

# Usage:

README.md                       \# Opens in nvim
document.pdf                    \# Opens with mupdf

```

### List & Remove Aliases
```

alias                           \# List all aliases
unalias {alias-name}            \# Remove alias
unalias -a                      \# Remove all aliases

```

---

## FUNCTIONS

### Define Functions
```


# In ~/.zshrc or as separate file:

function {name} {
\# commands
}

# Or using () syntax:

{name}() {
\# commands
}

```

### Function Examples
```


# Create and cd in one go:

mkcd() {
mkdir -p "\$1"
cd "\$1"
}

# Search and replace in files:

replace() {
grep -rl "\$1" . | xargs sed -i "s/\$1/\$2/g"
}

# Extract archives:

extract() {
case "\$1" in
*.tar.gz)  tar xzf "\$1" ;;
*.tar.bz2) tar xjf "\$1" ;;
*.zip)     unzip "\$1" ;;
*.rar)     unrar x "\$1" ;;
*)         echo "Unknown format" ;;
esac
}

```

### Function Arguments
```

\$0              - function name
\$1, \$2, etc.    - positional arguments
\$@              - all arguments (array)
\$*              - all arguments (string)
\$\#              - number of arguments

```

---

## GLOBBING & PATTERN MATCHING

### Basic Globbing
```

*               - any characters
    
?               - single character
[abc]           - character class (a, b, or c)
[a-z]           - range (a through z)
[^abc]          - negation (not a, b, or c)

```

### Advanced Globbing
```


# Enable extended globbing:

setopt EXTENDED_GLOB

**              - recursive directory match
(pattern1|pattern2)  - alternation
~pattern        - negation

```

### Globbing Examples
```

ls *.txt                        \# All .txt files
cd /home/**/*.config            \# Recursive find
echo file.[0-9]{1,3}.txt        \# Numbered files

```

---

## JOB CONTROL

### Background & Foreground
```

command \&                       \# Run in background
Ctrl+z                          \# Suspend current job
fg                              \# Bring to foreground
bg                              \# Continue in background
jobs                            \# List jobs
jobs -l                         \# With process IDs

```

### Job Specifications
```

fg %1                           \# Foreground job 1
bg %{name}                      \# Background job by name
kill %2                         \# Kill job 2
wait %1                         \# Wait for job 1
disown %1                       \# Detach job

```

---

## PROCESS SUBSTITUTION

### Process Substitution
```

<(command)                      \# Input substitution
>(command)                      \# Output substitution

```

### Examples
```


# Compare outputs of two commands:

diff <(ls dir1) <(ls dir2)

# Tee to multiple commands:

command | tee >(cmd1) >(cmd2)

# Use as input:

sort <(cat file1) <(cat file2)

```

---

## REDIRECTIONS

### Basic Redirections
```

command > file                  \# Redirect stdout to file
command >> file                 \# Append stdout to file
command < file                  \# Redirect file to stdin
command 2> file                 \# Redirect stderr to file
command \&> file                 \# Redirect both stdout/stderr

```

### Advanced Redirections
```

command 2>\&1                    \# Stderr to stdout
command 1>\&2                    \# Stdout to stderr
exec 3< file                    \# Open file as FD 3
exec 3>\&1                       \# Copy FD 1 to 3
command >\&3                     \# Redirect to FD 3
command {fd}> file              \# Redirect specific FD

```

### Here Documents
```

cat << EOF
Multi-line
text here
EOF

command << 'EOF'                \# No variable expansion
EOF

```

---

## PIPES & COMMAND CHAINS

### Pipes
```

command1 | command2             \# Pipe stdout
command1 |\& command2            \# Pipe both stdout/stderr

```

### Command Chains
```

cmd1 \&\& cmd2                    \# Execute if cmd1 succeeds
cmd1 || cmd2                    \# Execute if cmd1 fails
cmd1; cmd2                      \# Execute both (sequential)
cmd1 \& cmd2                     \# Execute both (parallel)

```

---

## VARIABLES

### Environment Variables
```

export VAR=value                \# Set \& export
export PATH=\$PATH:/new/path     \# Add to PATH
echo \$VAR                       \# Access variable

```

### Variable Expansion
```

\${var}                          \# Explicit expansion
\${var:-default}                 \# Default value
\${var:=default}                 \# Set \& use default
\${var:?error}                   \# Error if unset
\${var:+alternate}               \# Use if set
\${\#var}                         \# Length
\${var:start:length}             \# Substring
\${var//old/new}                 \# Replace all
\${var/old/new}                  \# Replace first
\${var\#pattern}                  \# Remove prefix
\${var%pattern}                  \# Remove suffix

```

---

## ARRAYS

### Array Basics
```

arr=(item1 item2 item3)         \# Create array
arr=value                    \# Index assignment
echo \${arr[@]}                  \# All elements
echo \${arr}                  \# First element
echo \${\#arr[@]}                 \# Array length

```

### Array Operations
```

arr+=(new)                      \# Append
arr=(\${arr[@]:1})               \# Slice
for item in \${arr[@]}; do       \# Iterate
echo \$item
done

```

---

## CONDITIONAL EXPRESSIONS

### If Statements
```

if [[ condition ]]; then
\# commands
elif [[ condition ]]; then
\# commands
else
\# commands
fi

```

### Test Operators
```

[[ \$var == value ]]             \# String equality
[[ \$var != value ]]             \# String inequality
[[ \$var =~ regex ]]             \# Regex match
[[ -z \$var ]]                   \# Empty string
[[ -n \$var ]]                   \# Non-empty
[[ -f file ]]                   \# File exists
[[ -d dir ]]                    \# Directory exists
[[ -r file ]]                   \# Readable
[[ -w file ]]                   \# Writable
[[ -x file ]]                   \# Executable
[[ num1 -eq num2 ]]             \# Numeric equal
[[ num1 -lt num2 ]]             \# Less than
[[ num1 -gt num2 ]]             \# Greater than

```

---

## LOOPS

### For Loops
```

for item in list; do
echo \$item
done

for ((i=0; i<10; i++)); do
echo \$i
done

for file in *.txt; do
echo \$file
done

```

### While Loops
```

while [[ condition ]]; do
\# commands
done

while read line; do
echo \$line
done < file

```

### Until Loops
```

until [[ condition ]]; do
\# commands
done

```

---

## COMMAND SUBSTITUTION

### Modern Syntax (Preferred)
```

\$(command)                      \# Replace with output
\$(echo hello)                   \# hello

```

### Legacy Syntax
```

`command`                       \# Backticks (avoid)

```

### Examples
```

files=$(ls *.txt)
date=$(date +%Y-%m-%d)
result=\$((10 + 20))

```

---

## ARITHMETIC

### Arithmetic Expansion
```

\$((expression))                 \# Evaluate expression
echo \$((10 + 5))               \# 15
echo $((2 ** 8))               # 256
x=$((x + 1))                   \# Increment

```

### Operators
```

+, -, *, /, %                   \# Basic math
**, ^                           \# Exponentiation
++, --                          \# Increment/decrement
+=, -=, *=, /=                  \# Compound assignment

```

---

## PARAMETER EXPANSION

### Common Expansions
```

\${parameter}                    \# Simple expansion
\${parameter:-word}              \# Use word if unset
\${parameter:+word}              \# Use word if set
\${parameter:=word}              \# Assign and expand
\${\#parameter}                   \# Length
\${parameter:offset:length}      \# Substring
\${parameter/pattern/string}     \# Replace
\${parameter%suffix}             \# Remove suffix
\${parameter\#prefix}             \# Remove prefix

```

---

## SPECIAL VARIABLES

### Shell Variables
```

\$0                              \# Script/shell name
\$1, \$2, etc.                    \# Script arguments
\$@                              \# All arguments (array)
\$*                              \# All arguments (string)
\$\#                              \# Number of arguments
\$?                              \# Last exit code

\$\$                              \# Process ID
\$!                              \# Last background PID
\$-                              \# Current shell options
```

---

## OPTIONS

### Set Options

```
setopt OPTION                   # Enable option
unsetopt OPTION                 # Disable option
set -o OPTION                   # Enable (alternative)
set +o OPTION                   # Disable (alternative)
```


### Common Options

```
EXTENDED_GLOB                   # Enable ** globbing
HIST_IGNORE_DUPS               # No duplicate history
SHARE_HISTORY                  # Share history between sessions
AUTO_CD                        # cd without typing cd
PUSHD_IGNORE_DUPS              # Unique directories in stack
NOMATCH                        # Error on no glob match
NULL_GLOB                      # Empty glob expands to nothing
```


### Check Options

```
setopt                          # Show enabled options
unsetopt                        # Show disabled options
[[ -o OPTION ]]                 # Check if enabled
```


---

## PLUGINS \& EXTENSIONS

### Oh-My-Zsh Installation

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```


### Useful Plugins

```
git             - Git aliases
docker          - Docker completion
python          - Python utilities
node            - Node.js utilities
npm             - NPM completion
sudo            - Prefix with sudo (press Esc twice)
z               - Fast directory jumping
```


### Enable Plugins (in ~/.zshrc)

```
plugins=(git docker python npm z)
source $ZSH/oh-my-zsh.sh
```


---

## ALIASES FOR COMMON WORKFLOWS

### Zk Aliases

```
alias zkf='zk new --template fleeting.md'
alias zkz='zk new --template zettel.md'
alias zkp='zk new --template permanent.md'
alias zks='zk list --interactive'
alias zke='zk edit --interactive'
```


### Git Aliases

```
alias g='git'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
```


### Tmux Aliases

```
alias tm='tmux'
alias tma='tmux attach'
alias tmn='tmux new-session -s'
alias tmls='tmux list-sessions'
```


### System Aliases

```
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
```


---

## INTEGRATION WITH NVIM/TMUX

### Zsh in Tmux

```
# Tmux respects zsh config
# Aliases and functions available
# Vi-mode works seamlessly
```


### Launch Editors

```
alias e='nvim'
alias v='nvim'
function zk() { /usr/bin/zk "$@"; }
```


### Quick Navigation

```
# Using CDPATH:
export CDPATH=".:~:~/projects:/mnt/data/git"
cd gnosis                       # Works from anywhere
```


---

## DEBUGGING SHELL SCRIPTS

### Enable Debugging

```
set -x                          # Print commands
set -v                          # Print input lines
set -e                          # Exit on error
set -u                          # Error on undefined var
set -o pipefail                 # Error if pipe fails
```


### Debug Functions

```
# At script top:
#!/bin/zsh -x

# Or use:
PS4='${LINENO}: '              # Show line numbers
```


---

## PERFORMANCE OPTIMIZATION

### Lazy Load Functions

```
autoload -Uz {function}         # Load on first use
```


### Compile Config

```
# Zsh auto-compiles ~/.zshrc
# Speed up startup with:
zcompile ~/.zshrc
```


### Check Startup Time

```
time zsh -i -c exit
```


---

## SYSTEM ALIASES \& REFERENCES

### All Reference Aliases

```
alias nvimref='nvim /mnt/data/git/fa-system/config/nvim/NVIM-REFERENCE.md'
alias tmuxref='nvim /mnt/data/git/fa-system/config/tmux/TMUX-REFERENCE.md'
alias footref='nvim /mnt/data/git/fa-system/config/foot/FOOT-REFERENCE.md'
alias zkref='nvim /mnt/data/git/fa-system/config/zk/ZK-REFERENCE.md'
alias gitref='nvim /mnt/data/git/fa-system/config/git/GIT-REFERENCE.md'
alias vimbref='nvim /mnt/data/git/fa-system/config/vimb/VIMB-REFERENCE.md'
alias zshref='nvim /mnt/data/git/fa-system/config/zsh/ZSH-REFERENCE.md'
```


---

## BEST PRACTICES

### Configuration Organization

```
~/.zshenv       - Minimal env vars (always loaded)
~/.zshrc        - Main config (interactive only)
~/.zsh/         - Functions and completions subdirs
~/.zsh/functions/
~/.zsh/completions/
```


### Load Order in ~/.zshrc

```
# 1. Set options
setopt EXTENDED_GLOB
setopt SHARE_HISTORY

# 2. Set variables
export EDITOR=nvim
export PATH=$PATH:/custom/path

# 3. Load completions
autoload -Uz compinit && compinit

# 4. Aliases
alias ll='ls -lah'

# 5. Functions
function mkcd() { mkdir -p "$1" && cd "$1"; }

# 6. Plugins (oh-my-zsh)
source $ZSH/oh-my-zsh.sh
```


---

## RESOURCES \& HELP

```
man zsh                         # Main manual
man zshbuiltins                 # Built-in commands
man zshexpn                     # Expansions
man zshoptions                  # Options
zsh -f                          # Start without config
```


---

**Last Updated:** 2025-11-19
**System:** Fedora Asahi | M1 Mac Mini
**Integration:** tmux → zsh → nvim/zk/git | Interactive shell mastery

EOF

```

Usage reference alias:
```bash
# Add to ~/.zshrc
alias zshref='nvim /mnt/data/git/fa-system/config/zsh/ZSH-REFERENCE.md'
```

This reference covers all zsh operations—history management, completion, prompt customization, functions, variables, job control, and integration with your nvim/tmux/zk ecosystem while maintaining consistency with your system-wide workflow.

