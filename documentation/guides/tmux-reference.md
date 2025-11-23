# TMUX COMPLETE REFERENCE GUIDE
**Vi-like Universal Keybindings | Terminal Multiplexer**

---

## MODES & STATES

| State | Enter | Exit | Description |
|-------|-------|------|-------------|
| **Command** | `Prefix + :` | `Enter`/`Esc` | Execute tmux commands |
| **Copy** | `Prefix + [` | `Esc` | Selection and navigation |
| **Normal** | Default | - | Standard pane/window navigation |
| **Command Prompt** | `:` | `Enter`/`Esc` | Search, find, filter |

---

## PREFIX KEY & BASICS

Prefix: Ctrl-a (default in this config)

Ctrl-a Ctrl-a - send Ctrl-a to application
Ctrl-a : - command prompt
Ctrl-a ? - list all keybindings
Ctrl-a r - reload config

text

---

## SESSION MANAGEMENT

### Create & Attach
tmux new-session -s {name} - new session
tmux new-session -s {name} -d - new session (detached)
tmux attach-session -t {name} - attach to session
tmux attach - attach to last session
tmux ls - list all sessions

text

### Within Tmux
Prefix + Ctrl-c - new session
Prefix + Ctrl-f - find and switch session
Prefix + s - switch session (interactive)
Prefix + $ - rename current session
Prefix + d - detach current session
Prefix + q - confirm and kill session
Prefix + Q - confirm and kill server

text

### Command Mode Sessions
:new-session -s {name}
:kill-session -t {name}
:rename-session -t {old} {new}
:list-sessions (or :ls)
:switch-client -t {name}

text

---

## WINDOW MANAGEMENT

### Create & Navigate
Prefix + c - new window
Prefix + Ctrl-h - previous window
Prefix + Ctrl-l - next window
Prefix + Tab - last active window
Prefix + {n} - goto window n (0-9)
Prefix + w - interactive window select
Prefix + l - last window (same as Tab)

text

### Window Operations
Prefix + , - rename window
Prefix + X - kill window
Prefix + & - kill window (with confirm)
:kill-window
:rename-window {name}
:swap-window -t {window-index}

text

### Window Display
Prefix + f - find window (search)
:list-windows
:show-window-options

text

---

## PANE MANAGEMENT

### Create & Navigate
Prefix + | - split vertical (new right pane)
Prefix + - - split horizontal (new bottom pane)
Prefix + h - select pane left
Prefix + j - select pane down
Prefix + k - select pane up
Prefix + l - select pane right
Prefix + {arrow} - navigate with arrow keys
Prefix + o - next pane (cycle)
Prefix + ; - last active pane
Prefix + {digit} - select pane by index

text

### Pane Operations
Prefix + x - kill pane
Prefix + z - zoom pane (fullscreen)
Prefix + ! - break pane into window
Prefix + m - mark pane
Prefix + M - unmark pane
Prefix + S - synchronize-panes toggle

text

### Pane Resizing
Prefix + H - resize left (-5 width)
Prefix + J - resize down (+5 height)
Prefix + K - resize up (-5 height)
Prefix + L - resize right (+5 width)
Prefix + Ctrl-h - resize more left
Prefix + Ctrl-j - resize more down
Prefix + Ctrl-k - resize more up
Prefix + Ctrl-l - resize more right

text

### Pane Arrangements
:select-layout even-horizontal
:select-layout even-vertical
:select-layout main-horizontal
:select-layout main-vertical
:select-layout tiled
:next-layout
:previous-layout

text

---

## COPY MODE (VI-LIKE)

### Enter Copy Mode
Prefix + [ - enter copy mode
Prefix + ] - paste from buffer
Prefix + p - paste last buffer
Prefix + P - paste from history

text

### Navigation in Copy Mode
h j k l - left down up right (vi-style)
w W b B e E - word navigation
^ $ 0 g - line start/end
/ ? - search forward/backward
n N - next/previous match
Ctrl-h j k l - switch panes while in copy mode

text

### Selection in Copy Mode
v - start character selection
V - start line selection
Ctrl-v - start block/rectangle selection
o - toggle selection end
y - yank/copy selection
Esc - cancel/exit copy mode
Space - toggle selection (legacy)

text

### Copy Mode Marks
text
              - enter copy mode command prompt
{mark} - set marks

text

---

## BUFFER & PASTE OPERATIONS

### Buffer Management
Prefix + = - choose buffer to paste
:list-buffers - show all buffers
:choose-buffer - choose buffer interactive
:show-buffer -b {n} - show buffer content
:delete-buffer -b {n} - delete buffer
:capture-pane -p - capture pane content

text

### Paste Operations
Prefix + ] - paste latest buffer
Prefix + p - paste latest buffer
:paste-buffer
:send-keys "text" Enter - send text to pane

text

---

## SEND KEYS & COMMANDS TO PANES

Prefix + :send-keys "{text}" Enter
Prefix + !send-keys -t {pane} "text" Enter
:send-keys -t {window}:{pane} "command" C-m

Examples:
:send-keys -t 0 "ls -la" Enter
:send-keys -t 1:2 "nvim file.txt" Enter

text

---

## SCREEN & DISPLAY

### Clear & Reset
Prefix + C-k - clear pane and history
Prefix + C-l - clear screen (scroll)
:clear-history

text

### Display Settings
:set status on/off
:set status-position top/bottom
:set pane-border-status off/top/bottom
:set display-time {milliseconds}
:set display-panes-time {milliseconds}

text

### Display Active Panes
Prefix + q - display pane numbers (2 sec)
Prefix + Ctrl-o - rotate panes down
Prefix + Alt-o - rotate panes up

text

---

## COMMAND MODE

### Syntax & Execution
Prefix + : - command prompt
:command {args} - execute command
:list-commands - list all commands
:show-options - show current options
:show-options -g - show global options
:set {option} {value} - set option
:set -g {option} {value} - set global option

text

### Common Commands
:new-window
:new-pane
:split-window
:kill-window
:kill-pane
:list-windows
:list-panes
:rename-window
:select-window
:select-pane
:set-option
:bind-key
:unbind-key
:source-file {file} - reload config
:send-keys
:display-message

text

---

## SEARCH & FIND

### In Copy Mode
/pattern - search forward
?pattern - search backward
n - next match
N - previous match

text

### Window/Session Search
Prefix + f - find window by name
Prefix + Ctrl-f - find and switch session (command)
:find-window
:list-windows

text

---

## CUSTOMIZATION & CONFIGURATION

### Loading Config
tmux source-file ~/.tmux.conf - load config
Prefix + r - reload config (mapped)
:source-file /path/to/config

text

### Key Bindings
:bind-key -n Prefix+Key command - global binding
:bind-key -t copy-mode-vi v send -X begin-selection
:unbind-key Key
:list-keys - show all bindings

text

### Options Format
set -g option value - global option
setw -g option value - global window option
set -t session:window option value - target specific
set -p pane option value - pane option

text

---

## MOUSE OPERATIONS (if enabled)

set -g mouse on - enable mouse
set -g mouse off - disable mouse

text

When enabled:
Click pane - select pane
Drag separator - resize panes
Scroll wheel - scroll in copy mode
Click window tab - select window
Right-click pane - show menu

text

---

## STATUS BAR

### Status Bar Structure
Left Center Right
[Session] Windows Time

text

### Customization
:set status-left "{format}"
:set status-right "{format}"
:set status-justify left/center/right
:set status-position top/bottom
:set window-status-format "{format}"
:set window-status-current-format "{format}"

text

### Format Codes
#S - session name
#I - window index
#W - window name
#P - pane index
#H - hostname
#{time} - time
#{pane_width} - pane width
#{window_width} - window width
#(command) - execute command
#{client_width} - client width

text

---

## ADVANCED OPERATIONS

### Pane Layouts
:list-windows - show current layout
:select-layout {name}
:next-layout - cycle layout
:previous-layout

Available:
even-horizontal
even-vertical
main-horizontal
main-vertical
tiled

text

### Breakout & Join
Prefix + ! - break pane into new window
:join-pane -s src -t dst - merge pane into window
:move-pane -t {target}

text

### Capture Pane Output
:capture-pane -p - show pane content
:capture-pane -p -S -{lines} - show last N lines
:capture-pane -p > {file} - save to file

text

### Pipe to Command
:pipe-pane '{command}' - pipe to command
:pipe-pane 'cat >> ~/output.txt' - log pane output

text

---

## SCRIPTING & AUTOMATION

### From Command Line
tmux new-session -d -s work
tmux send-keys -t work "cd /path" Enter
tmux send-keys -t work "nvim" Enter
tmux attach -t work

text

### Within Tmux Scripts
#!/bin/bash
tmux new-session -d -s dev
tmux send-keys -t dev "cd ~/projects" Enter
tmux new-window -t dev -n editor
tmux send-keys -t dev:editor "nvim" Enter
tmux attach -t dev

text

---

## ENVIRONMENT & VARIABLES

#{session_name}
#{session_id}
#{window_name}
#{window_id}
#{window_index}
#{pane_id}
#{pane_index}
#{host}
#{client_width}
#{client_height}
#{socket_path}

text

Use in status bar:
:set status-right "#[fg=blue]#{session_name} #[fg=white]#{pane_index}"

text

---

## DEBUGGING & HELP

:list-keys - show all bindings
:list-keys -T copy-mode-vi - copy mode bindings
:show-options - show current options
:show-options -g - show global options
:show-environment - show env vars
:list-commands - list all commands
tmux list-keys -T copy-mode-vi - check vi keybinds

text

---

## INTEGRATION WITH VI-LIKE TOOLS

### With Vim/Neovim
:set-option -g mouse on - enable mouse
:bind-key -n C-h select-pane -L - pane nav
:bind-key -n C-j select-pane -D
:bind-key -n C-k select-pane -U
:bind-key -n C-l select-pane -R

text

### With Sway
Sway config: avoid prefix conflicts
bindsym $mod+Control+h select_window left
bindsym $mod+Control+l select_window right

text

### With Foot Terminal
Foot inherits tmux keybindings, no special config needed
Uses same hjkl navigation, same copy mode
text

---

## COMMON WORKFLOWS

### Development Session
tmux new-session -s dev -n editor
tmux send-keys -t dev "cd ~/project" Enter
tmux new-window -t dev -n server
tmux send-keys -t dev:server "npm start" Enter
tmux select-window -t dev:editor
tmux attach -t dev

text

### Monitor Multiple Logs
tmux new-window -n logs
tmux split-window -h -t logs
tmux send-keys -t logs:0 "tail -f /var/log/app.log" Enter
tmux send-keys -t logs:1 "tail -f /var/log/system.log" Enter

text

### Split & Sync
Prefix + - - horizontal split
Prefix + | - vertical split
Prefix + S - synchronize panes (type once, all panes execute)

text

---

## KEY NOTATION

C-x - Ctrl+x
M-x - Alt+x
S-x - Shift+x
Prefix - tmux prefix (Ctrl+a in this config)

text

---

## STATUS & REFERENCES

:display-message "{message}" - show message
:new-session -c /path - start in directory
:new-window -c /path - window in directory
:send-keys -t pane "echo test" Enter - send commands

text

---

**Last Updated:** 2025-11-19  
**System:** Fedora Asahi | M1 Mac Mini | ncurses green theme  
**Integration:** sway, foot, nvim, vimb, vifm | Vi-like universal keybindings

EOF
Usage reference alias:

bash
# Add to ~/.zshrc
alias tmuxref='nvim /mnt/data/git/fa-system/config/tmux/TMUX-REFERENCE.md'
This reference covers all tmux operations organized by task, synchronized with your vi-like universal keybindings system (hjkl for navigation, copy mode vi-style, prefix Ctrl+a).
