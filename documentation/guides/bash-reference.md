<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# re peat for BASH

Create comprehensive bash reference guide in `/mnt/data/git/fa-system/config/bash/BASH-REFERENCE.md`:

```bash
cat > /mnt/data/git/fa-system/config/bash/BASH-REFERENCE.md << 'EOF'
# BASH COMPLETE REFERENCE GUIDE
**Bourne-Again Shell | POSIX-compatible Shell | Scripting & Automation**

---

## OVERVIEW

Bash is the standard shell on most Linux systems:
- POSIX-compliant scripting
- Job control & background operations
- Command history
- Prompt customization
- Parameter expansion
- Pattern matching (globbing)
- Scripting capabilities
- Command redirection & piping

---

## STARTUP & CONFIGURATION

### Configuration Files (Login Shell)
```

/etc/profile                    - System-wide login config
/etc/bash.bashrc                - System-wide interactive config
~/.bash_profile                 - User login config
~/.bashrc                       - User interactive config
~/.bash_logout                  - Logout commands

```

### Startup Order

**Login Shell:**
```

1. /etc/profile
2. ~/.bash_profile (or ~/.bash_login or ~/.profile)
3. ~/.bashrc (if sourced from .bash_profile)
```

**Non-login Interactive Shell:**
```

1. /etc/bash.bashrc
2. ~/.bashrc
```

**Non-interactive (Scripts):**
```

1. BASH_ENV file (if set)
```

### Source Configuration
```

source ~/.bashrc                \# Load config
. ~/.bashrc                     \# Alternate syntax
exec bash                       \# Restart shell with new config

```

---

## HISTORY

### History Variables
```

HISTSIZE=1000                   \# Lines to save in memory
SAVEHIST=1000                   \# Lines to save to file
HISTFILE=~/.bash_history        \# History file location
HISTTIMEFORMAT='%F %T '         \# Include timestamps

```

### History Configuration
```


# In ~/.bashrc:

shopt -s histappend             \# Append, don't overwrite
shopt -s cmdhist                \# Multi-line commands as one
shopt -s histverify             \# Verify expansion before execute
PROMPT_COMMAND="history -a; \$PROMPT_COMMAND"  \# Write after each command

```

### History Commands
```

history                         \# Show all history
history 20                      \# Last 20 commands
history -c                      \# Clear history (memory only)
history -w                      \# Write history to file
history -r                      \# Read history from file
history -a                      \# Append new entries
fc                              \# Edit and re-execute
fc -l                           \# List recent commands

```

### History Expansion
```

!!                              \# Last command
!\$                              \# Last argument
!*                              \# All arguments
!n                              \# Command n
!-n                             \# n commands back
!string                         \# Last command starting with string
^old^new                        \# Replace old with new in last command
!:p                             \# Print without executing

```

### History Search
```


# Reverse search:

Ctrl+r                          \# Search backward

# Type pattern, Ctrl+r for next match

# Enter to execute, Esc to cancel

# Requires: set -o vi or set -o emacs (default)

```

---

## KEYBINDINGS

### Emacs-Mode (Default)
```

Ctrl+a                          \# Beginning of line
Ctrl+e                          \# End of line
Ctrl+k                          \# Kill to end of line
Ctrl+u                          \# Kill to start of line
Ctrl+d                          \# Delete character
Ctrl+h                          \# Backspace
Ctrl+r                          \# Search history backward
Ctrl+s                          \# Search history forward
Alt+f                           \# Forward word
Alt+b                           \# Backward word
Alt+d                           \# Delete word
Ctrl+y                          \# Paste (yank)

```

### Vi-Mode
```


# Enable:

set -o vi

# Normal Mode:

h l                 - left/right
j k                 - previous/next in history
A a I i             - append/insert
x                   - delete character
dd                  - delete line
yy                  - copy line
p P                 - paste after/before
u                   - undo
/                   - search
?                   - reverse search
n N                 - next/previous match
Escape              - exit insert mode

```

### Custom Keybindings
```


# In ~/.bashrc:

bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'
bind '"\C-w": backward-kill-word'

```

---

## PROMPT CUSTOMIZATION

### Simple Prompt
```


# In ~/.bashrc:

PS1='\u@\h:\w\$ '                \# user@host:cwd\$
PS1='[\u@\h \W]\$ '             \# [user@host dirname]\$

```

### Prompt Escape Sequences
```

\u                              \# Username
\h                              \# Hostname (short)
\H                              \# Hostname (full)
\w                              \# Current directory
\W                              \# Current directory (basename)
\d                              \# Date (weekday month date)
\t                              \# Time (HH:MM:SS)
\T                              \# Time (12-hour HH:MM:SS)
\@                              \# Time (12-hour HH:MM AM/PM)
\A                              \# Time (24-hour HH:MM)
\$                              \# \# for root, \$ for user
\!                              \# History number
\#                              \# Command number

```

### Colored Prompts
```


# Color codes:

\e[0;31m                       \# Red
\e[0;32m                       \# Green
\e[0;33m                       \# Yellow
\e[0;34m                       \# Blue
\e[0;35m                       \# Magenta
\e[0;36m                       \# Cyan
\e[0m                          \# Reset

PS1='\e[0;32m\u\e[0m:\e[0;34m\w\e[0m\$ '  \# Green user, blue dir

```

### Dynamic Prompt
```


# Show git branch:

PS1='\u@\h:\w\$(__git_ps1 " (%s)") \$ '

# Show exit status:

PS1='$$
$([[ $? -eq 0 ]] && echo "\e[0;32m" || echo "\e[0;31m")
$$\$$$
\e[0m
$$ '

```

---

## ALIASES

### Create Aliases
```


# In ~/.bashrc:

alias ll='ls -lah'
alias la='ls -la'
alias l='ls -CF'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'

```

### List & Remove
```

alias                           \# List all aliases
alias grep                      \# Show specific alias
unalias grep                    \# Remove alias
unalias -a                      \# Remove all

```

---

## FUNCTIONS

### Define Functions
```


# In ~/.bashrc or script:

function name() {
\# commands
}

# Or:

name() {
\# commands
}

```

### Function Examples
```


# Directory and CD:

mkcd() {
mkdir -p "\$1"
cd "\$1"
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

# Function with return:

return_value() {
echo "result"
return 0
}

result=\$(return_value)

```

### Function Arguments
```

\$0                              \# Function name
\$1, \$2, etc.                    \# Positional arguments
\$@                              \# All arguments (array)
\$*                              \# All arguments (string)
\$\#                              \# Number of arguments

```

---

## VARIABLES

### Environment Variables
```

export VAR=value                \# Set \& export
export PATH=\$PATH:/new/path     \# Extend PATH
echo \$VAR                       \# Access variable
echo \${VAR}                     \# Explicit access

```

### Variable Assignment
```

var=value                       \# Simple assignment
var="value with spaces"         \# Quoted string
var='$literal'                  # Single quotes (literal)
var=$((10 + 5))                 \# Arithmetic
var=\$(command)                  \# Command substitution

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

### Special Variables
```

\$0                              \# Script name
\$1, \$2, etc.                    \# Script arguments
\$@                              \# All arguments (array)
\$*                              \# All arguments (string)
\$\#                              \# Number of arguments
\$?                              \# Last exit code

\$\$                              \# Process ID (PID)
\$!                              \# Last background PID
\$_                              \# Last argument
```

---

## GLOBBING \& PATTERN MATCHING

### Basic Globbing

```
*                               # Any characters
?                               # Single character
[abc]                           # Character class
[a-z]                           # Range
[^abc]                          # Negation (not these)
```


### Extended Globbing

```
# Enable:
shopt -s extglob

?(pattern)                      # Zero or one match
*(pattern)                      # Zero or more
+(pattern)                      # One or more
@(pattern)                      # Exactly one
!(pattern)                      # Not this
```


### Examples

```
ls *.txt                        # All .txt files
ls file?.txt                    # file1.txt, fileA.txt
ls file[0-9].txt               # file0.txt - file9.txt
ls !(*.txt)                     # Everything but .txt
```


---

## CONDITIONALS

### If Statements

```
if [[ condition ]]; then
    # commands
elif [[ condition ]]; then
    # commands
else
    # commands
fi
```


### Test Operators

```
[[ $var == value ]]             # String equality
[[ $var != value ]]             # String inequality
[[ $var =~ regex ]]             # Regex match
[[ -z $var ]]                   # Empty string
[[ -n $var ]]                   # Non-empty
[[ -f file ]]                   # File exists
[[ -d dir ]]                    # Directory exists
[[ -r file ]]                   # Readable
[[ -w file ]]                   # Writable
[[ -x file ]]                   # Executable
[[ -s file ]]                   # Non-empty file
[[ num1 -eq num2 ]]             # Numeric equal
[[ num1 -lt num2 ]]             # Less than
[[ num1 -gt num2 ]]             # Greater than
[[ -o option ]]                 # Option enabled
```


### Case Statements

```
case $var in
    pattern1)
        # commands
        ;;
    pattern2|pattern3)
        # commands
        ;;
    *)
        # default
        ;;
esac
```


---

## LOOPS

### For Loop

```
for var in list; do
    echo $var
done

for file in *.txt; do
    echo $file
done

# C-style:
for ((i=0; i<10; i++)); do
    echo $i
done
```


### While Loop

```
while [[ condition ]]; do
    # commands
done

# Read file line by line:
while read line; do
    echo $line
done < file.txt

# Read from command:
while read line; do
    echo $line
done < <(command)
```


### Until Loop

```
until [[ condition ]]; do
    # commands
done
```


### Break \& Continue

```
for i in {1..10}; do
    if [[ $i -eq 5 ]]; then
        continue                # Skip iteration
    fi
    if [[ $i -eq 8 ]]; then
        break                   # Exit loop
    fi
    echo $i
done
```


---

## ARRAYS

### Array Basics

```
arr=(item1 item2 item3)         # Create array
arr=value                    # Index assignment
arr+=("new")                    # Append
echo ${arr}                  # First element
echo ${arr[@]}                  # All elements
echo ${#arr[@]}                 # Array length
```


### Iterate Array

```
for item in "${arr[@]}"; do
    echo $item
done

for i in "${!arr[@]}"; do
    echo "[$i]=${arr[$i]}"
done
```


### Associative Arrays (Bash 4+)

```
declare -A dict
dict[key]=value
echo ${dict[key]}
for key in "${!dict[@]}"; do
    echo "$key = ${dict[$key]}"
done
```


---

## ARITHMETIC

### Arithmetic Expansion

```
$((expression))                 # Evaluate math
echo $((10 + 5))               # 15
echo $((2 ** 8))               # 256
x=$((x + 1))                   # Increment
```


### Operators

```
+, -, *, /, %                   # Basic math
**, ^                           # Exponentiation
++, --                          # Increment/decrement
+=, -=, *=, /=                  # Compound assignment
```


### Let Command

```
let x=10+5                      # x=15
let x++                         # x=11
let y=$x*2                      # y=22
```


---

## STRING OPERATIONS

### String Length

```
${#var}                         # Length
expr length "$var"             # Alternative
```


### Substring

```
${var:start:length}             # Extract substring
${var:0:5}                      # First 5 chars
${var:5}                        # From char 5 onward
```


### String Replacement

```
${var/old/new}                  # Replace first
${var//old/new}                 # Replace all
${var/#old/new}                 # Replace at start
${var/%old/new}                 # Replace at end
```


### Case Conversion

```
${var^^}                        # Uppercase
${var,,}                        # Lowercase
${var^}                         # First char uppercase
```


---

## REDIRECTIONS

### Basic Redirections

```
command > file                  # Stdout to file
command >> file                 # Append to file
command < file                  # File to stdin
command 2> file                 # Stderr to file
command &> file                 # Both stdout/stderr
```


### Redirect to Multiple

```
command 2>&1                    # Stderr to stdout
command 1>&2                    # Stdout to stderr
command > /dev/null             # Discard output
command 2> /dev/null            # Discard errors
```


### Here Documents

```
cat << EOF
Multi-line text
With variables: $var
EOF

# No expansion (literal):
cat << 'EOF'
$var not expanded
EOF
```


### Process Substitution

```
<(command)                      # Input substitution
>(command)                      # Output substitution

# Example:
diff <(ls dir1) <(ls dir2)
```


---

## PIPES \& COMMAND CHAINS

### Pipes

```
command1 | command2             # Pipe stdout
command1 |& command2            # Pipe both (bash 4+)
```


### Command Chains

```
cmd1 && cmd2                    # Execute if cmd1 succeeds
cmd1 || cmd2                    # Execute if cmd1 fails
cmd1; cmd2                      # Execute both
cmd1 & cmd2                     # Background both
```


---

## JOB CONTROL

### Background \& Foreground

```
command &                       # Run in background
Ctrl+z                          # Suspend current job
fg                              # Foreground job
bg                              # Continue in background
jobs                            # List jobs
kill %1                         # Kill job 1
disown %1                       # Detach job
wait %1                         # Wait for job
```


---

## QUOTING \& ESCAPING

### Quote Types

```
'string'                        # Single: literal (no expansion)
"string"                        # Double: expands variables
$'string'                       # ANSI-C: escape sequences
```


### Escape Characters

```
\$                              # Literal $
\"                              # Literal quote
\\                              # Literal backslash
\n                              # Newline (in $'...')
\t                              # Tab (in $'...')
```


---

## COMMAND SUBSTITUTION

### Modern Syntax

```
$(command)                      # Replace with output
year=$(date +%Y)
files=$(ls *.txt)
```


### Legacy Syntax

```
`command`                       # Backticks (avoid)
```


---

## PARAMETER EXPANSION

### Common Expansions

```
${parameter}                    # Simple expansion
${parameter:-word}              # Default if unset
${parameter:+word}              # Alternate if set
${parameter:=word}              # Set and use default
${#parameter}                   # Length
${parameter:offset:length}      # Substring
${parameter/pattern/string}     # Replace
${parameter%suffix}             # Remove suffix
${parameter#prefix}             # Remove prefix
```


---

## BUILTINS \& SPECIAL COMMANDS

### Common Builtins

```
echo                            # Print text
read                            # Read input
test / [[ ]]                    # Conditionals
[ ]                             # POSIX test
true / false                    # Return codes
exit                            # Exit script
return                          # Return from function
break / continue                # Loop control
source / .                      # Load file
eval                            # Execute string
exec                            # Replace shell
command                         # Run external
type                            # Show command type
which                           # Locate command
```


### Input/Output

```
echo "text"                     # Print
printf "%s\n" "text"            # Formatted print
read var                        # Read input
read -p "Prompt: " var          # Read with prompt
read -a array                   # Read into array
```


---

## SCRIPTS

### Script Structure

```
#!/bin/bash                     # Shebang (must be first)

# Comments start with #

# Variables
VAR="value"

# Functions
function my_func() {
    echo "Hello"
}

# Main script
my_func
echo $VAR
```


### Execute Scripts

```
bash script.sh                  # Execute with bash
./script.sh                     # Direct execute (if executable)
chmod +x script.sh              # Make executable
source script.sh                # Source in current shell
```


### Script Arguments

```
#!/bin/bash

echo "Script: $0"
echo "First arg: $1"
echo "All args: $@"
echo "Arg count: $#"

for arg in "$@"; do
    echo "Processing: $arg"
done
```


---

## ERROR HANDLING

### Exit Codes

```
$?                              # Last exit code
echo $?                         # 0 = success, non-zero = failure
```


### Set Options

```
set -e                          # Exit on error
set -u                          # Error on undefined
set -x                          # Print commands (debug)
set -o pipefail                 # Error if any pipe fails
```


### Trap Errors

```
trap 'echo "Error on line $LINENO"' ERR
trap cleanup EXIT               # Run cleanup on exit
```


---

## DEBUGGING

### Debug Mode

```
bash -x script.sh               # Trace execution
bash -v script.sh               # Print input
set -x                          # Enable in script
set +x                          # Disable
PS4='${BASH_SOURCE}:${LINENO}: ' # Debug prompt format
```


### Print Statements

```
echo "Debug: $var"
echo "Reached line" >&2         # Print to stderr
```


---

## OPERATORS

### Logical Operators

```
&&                              # AND
||                              # OR
!                               # NOT
```


### Comparison Operators

```
-eq                             # Numeric equal
-ne                             # Numeric not equal
-lt                             # Less than
-gt                             # Greater than
-le                             # Less than or equal
-ge                             # Greater than or equal
```


### File Test Operators

```
-f                              # File exists
-d                              # Directory exists
-r                              # Readable
-w                              # Writable
-x                              # Executable
-s                              # Non-empty
-z                              # Empty string
-n                              # Non-empty string
```


---

## OPTIONS (SHOPT)

### Set Options

```
shopt -s OPTION                 # Enable
shopt -u OPTION                 # Disable
shopt                           # List all
```


### Useful Options

```
nocaseglob                      # Case-insensitive globbing
nullglob                        # Empty glob expands to nothing
failglob                        # Error on no glob match
dotglob                         # Include hidden files in glob
extglob                         # Extended globbing
histappend                      # Append to history
cmdhist                         # Multi-line as single
```


---

## COMMONLY USED PATTERNS

### Check File Exists

```
if [[ -f "$file" ]]; then
    echo "File exists"
fi
```


### Check Directory

```
if [[ -d "$dir" ]]; then
    echo "Directory exists"
fi
```


### Parse Arguments

```
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done
```


### Safe Variable Use

```
# Always quote variables:
rm "$file"                      # Good
rm $file                        # Bad (word splitting)

# Use array for arguments:
cmd_args=("-option" "$file")
command "${cmd_args[@]}"
```


---

## BASH VERSION CHECK

### Version Information

```
echo $BASH_VERSION              # Current version
bash --version                  # Full version info
```


### Version-Specific Features

```
# Bash 4+ features:
# - Associative arrays
# - ${var^^}, ${var,,}
# - &>, |&

# Use conditionals:
if [[ ${BASH_VERSINFO} -ge 4 ]]; then
    # Bash 4+ code
fi
```


---

## SYSTEM ALIASES FOR BASH

### Quick Reference Aliases

```
alias nvimref='nvim /mnt/data/git/fa-system/config/nvim/NVIM-REFERENCE.md'
alias tmuxref='nvim /mnt/data/git/fa-system/config/tmux/TMUX-REFERENCE.md'
alias gitref='nvim /mnt/data/git/fa-system/config/git/GIT-REFERENCE.md'
alias zkref='nvim /mnt/data/git/fa-system/config/zk/ZK-REFERENCE.md'
alias bashref='nvim /mnt/data/git/fa-system/config/bash/BASH-REFERENCE.md'
```


---

## BEST PRACTICES

### Script Quality

```
1. Use shebang (#!/bin/bash)
2. Add comments for clarity
3. Use functions for organization
4. Handle errors (set -e, trap)
5. Quote variables ("$var")
6. Use [[ ]] instead of [ ]
7. Use $() instead of backticks
8. Avoid eval
9. Test thoroughly
10. Make scripts portable
```


### Code Organization

```
#!/bin/bash
set -euo pipefail

# Constants
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"

# Functions
function main() {
    # script logic
}

# Script execution
main "$@"
```


---

## RESOURCES \& HELP

```
man bash                        # Main manual
help {builtin}                  # Builtin help
bash --help                     # Command help
type {command}                  # Command type
which {command}                 # Command location
```


---

**Last Updated:** 2025-11-19
**System:** Fedora Asahi | M1 Mac Mini
**Integration:** tmux → bash → git/zk | Shell scripting \& automation

EOF

```

Usage reference alias:
```bash
# Add to ~/.bashrc
alias bashref='nvim /mnt/data/git/fa-system/config/bash/BASH-REFERENCE.md'
```

This reference covers all bash operations—variables, conditionals, loops, functions, scripting, job control, and system integration—organized for quick lookup and practical use.

