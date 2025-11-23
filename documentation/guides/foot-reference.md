# FOOT TERMINAL COMPLETE REFERENCE GUIDE
**Vi-like Universal Keybindings | Wayland-native Terminal Emulator**

---

## OVERVIEW

Foot is a fast, lightweight Wayland-native terminal emulator with:
- GPU-accelerated rendering
- Vi-like keybindings support
- URL detection and opening
- Search functionality
- Copy/paste modes
- Sixel image support
- Minimalist design (no distractions)

---

## LAUNCHING FOOT

foot - launch foot
foot -T {title} - launch with title
foot -S dark - launch with dark theme
foot -a {app-id} - set application ID
foot -w {cols}x{rows} - launch with size
foot -c {config} - use config file
foot & - background launch

text

---

## COMMAND MODE

### Basic Shortcuts
Ctrl+Alt+c - new window (creates new foot instance)
Ctrl+Alt+n - new tab (if tab support enabled)
Ctrl+Alt+w - close window/tab
Ctrl+Alt+q - quit foot

text

### Scrollback
Shift+Page-Up - scroll up
Shift+Page-Down - scroll down
Shift+Home - scroll to top
Shift+End - scroll to bottom
Ctrl+Shift+Home - scroll to top of buffer
Ctrl+Shift+End - scroll to end
Ctrl+Shift+l - clear screen

text

### Search in Scrollback
Ctrl+Shift+f - open search (forward)
Ctrl+Shift+r - open search (reverse)
Enter - next match
Shift+Enter - previous match
Esc - close search

text

---

## COPY & PASTE MODES

### Selection & Copy
Shift+Click - begin selection
Drag - select text
Double-Click - select word
Triple-Click - select line
Shift+Up/Down - extend selection
Shift+Left/Right - adjust selection
Ctrl+Shift+c - copy selection
Ctrl+Shift+x - cut selection

text

### Vi-Like Selection (if enabled via config)
v - start visual selection (vi-mode)
V - line selection (vi-mode)
Ctrl+V - block selection (vi-mode)
y - yank/copy (vi-mode)
d - delete selection (vi-mode)
Esc - cancel selection

text

### Paste Operations
Ctrl+Shift+v - paste from clipboard
Shift+Insert - paste from primary
Middle-Click - paste primary selection
Ctrl+Shift+v - paste from selection history (if enabled)

text

---

## KEYBOARD SHORTCUTS

### Text Manipulation
Ctrl+Shift+u - Unicode input mode
Ctrl+Shift+a - Select all
Ctrl+Shift+Equals - Increase font size
Ctrl+Shift+Minus - Decrease font size
Ctrl+Shift+0 - Reset font size

text

### Input Method
Ctrl+Shift+i - Input method menu (if configured)
Ctrl+; - Cycle input methods

text

### URL Handling
Ctrl+Click - open URL under cursor
Ctrl+Shift+o - open URL from scrollback

text

---

## CONFIGURATION (`~/.config/foot/foot.ini`)

### Main Section
[main]
term=xterm-256color # Terminal type
font=monospace:pixelsize=12 # Font
dpi-aware=yes # DPI awareness
initial-window-size-pixels=800x600
initial-window-size-chars=120x40
pad=10x10 # Padding (x, y)
letter-spacing=0 # Letter spacing
line-height=1.0 # Line height

text

### Colors Section
[colors]
foreground=a8a8a8 # Text color
background=000000 # Background
regular0=000000 # Black
regular1=cd3131 # Red
regular2=0dbc79 # Green
regular3=e5e510 # Yellow
regular4=2472c8 # Blue
regular5=bc3fbc # Magenta
regular6=11a8cd # Cyan
regular7=e5e5e5 # White

bright 0-7 also available
text

### Cursor Section
[cursor]
style=block # block, underline, beam
blink=no # yes/no

text

### Bell Section
[bell]
urgent=no # Flash on bell
notify=no # Desktop notification

text

### Mouse Section
[mouse]
hide-when-typing=yes # Hide cursor while typing
alternate-scroll-mode=yes # Alt scroll behavior

text

### Scrollback Section
[scrollback]
lines=10000 # Scrollback buffer size
multiplier=3.0 # Scroll multiplier

text

### Keyboard Section
[keyboard]

Custom keybindings
Format: keysym+mods=action
Actions: copy, paste, primary-paste, scrollback-up,
scrollback-down, select-all, font-increase,
font-decrease, font-reset, spawn, popup-url-handler
Example Vi-like bindings:
v+ctrl+shift=copy
p+ctrl+shift=paste
/ +ctrl+shift=search-start
text

### Search Section
[search]

Placeholder for future search config
text

---

## VI-MODE CONFIGURATION

Enable vi-like keybindings in `~/.config/foot/foot.ini`:

[main]

Enable vi mode for scrollback navigation
scrollback-lines=10000

[keyboard]

Copy/paste vi-style (if not using tmux)
These override default bindings
Scrollback navigation
Page_Up+shift=scrollback-up
Page_Down+shift=scrollback-down
Home+shift=scrollback-home
End+shift=scrollback-end

Search
f+ctrl+shift=search-start
r+ctrl+shift=search-reverse

Font sizing
plus+ctrl+shift=font-increase
minus+ctrl+shift=font-decrease
0+ctrl+shift=font-reset

Copy/Paste
c+ctrl+shift=copy
v+ctrl+shift=paste
x+ctrl+shift=primary-paste

text

---

## SCROLLBACK NAVIGATION

### Without Vi-Mode
Shift+Page-Up - scroll up
Shift+Page-Down - scroll down
Shift+Home - scroll to top
Shift+End - scroll to end

text

### Within Tmux (Primary workflow)
Foot respects tmux copy mode
Prefix+[ - enter tmux copy mode
hjkl - navigate (vi-style, from tmux)
/ - search forward
? - search backward
v - select (tmux copy mode)
y - yank (tmux copy mode)
Esc - exit copy mode

text

---

## SPECIAL FEATURES

### URL Detection & Opening
Ctrl+Click - open URL under cursor
Ctrl+Shift+o - open URL from recent scrollback

Requires URL handler configured in system
text

### Sixel Graphics Support
Foot supports sixel image protocol
Use with tools like:
- fzf --preview with sixel
- chafa (image to sixel conversion)
- lsix (image viewer)
echo -e '\033]8;;file:///path/to/image.png\033\' # Create link

text

### CSD (Client-Side Decorations) in Wayland
Foot draws its own window decorations (no titlebar from WM)
Integrated with sway window manager seamlessly
text

---

## FONTS & RENDERING

### Font Configuration
[main]
font=monospace:pixelsize=12

Or specify by name:
font=Hack:pixelsize=12
font=Inconsolata:pixelsize=11
font=Source Code Pro:pixelsize=11

text

### Font Fallback
[main]
font=Monospace:pixelsize=12
font-fallbacks=DejaVu Sans Mono,Noto Color Emoji

text

### Font Features (OpenType)
[main]
font=monospace:pixelsize=12:features=liga

text

---

## COLORS & THEMES

### Built-in Color Schemes
Foot uses CSS-like color definitions
256-color palette support
True color (24-bit) support
text

### Setting Colors
[colors]

Can use:
- hex: #ffffff
- rgb: rgb(255, 255, 255)
- named: white, black, red
- 256-color indices: 1-256
foreground=#a8a8a8
background=#000000
regular0=#000000

text

### Color Schemes Directory
~/.config/foot/colors/

Place .ini files here for color themes
Reference in config: colors=theme-name
text

---

## INTEGRATION WITH SWAY

### Sway Keybindings for Foot
~/.config/sway/config
Open foot terminal
bindsym $mod+Return exec foot

Open foot in floating
bindsym $mod+Shift+Return exec foot --class=floating-foot

Scratchpad
bindsym $mod+grave scratchpad show

Or with title
exec foot -T "My Terminal"

text

---

## INTEGRATION WITH TMUX

### Recommended Setup
Launch tmux inside foot
foot tmux

Or attach to existing session
foot tmux attach-session -t work

From foot command line:
Ctrl+Alt+c # New foot window
Prefix+c # New tmux window (inside foot)
Prefix+% # New tmux pane (vertical split)
Prefix+- # New tmux pane (horizontal split)

text

### Synchronization
Vi-keybindings flow through:
foot (terminal) -> tmux (multiplexer) -> nvim/vimb/vifm (applications)
hjkl - navigation (foot scrollback → tmux panes → nvim)
/ - search (foot → tmux → nvim)
v y p - selection (foot → tmux → nvim)

text

---

## CLIPBOARD INTEGRATION

### With System Clipboard
Wayland clipboard handling:
- Primary selection: Middle-click or Shift+Insert
- Clipboard: Ctrl+Shift+c/v
Integration with wl-clipboard:
Ctrl+Shift+c - copy to wl-copy
Ctrl+Shift+v - paste from wl-paste

text

### With Tmux Clipboard
Within tmux in foot:
Prefix+[ - enter copy mode
y - yank to tmux buffer
Prefix+] - paste from tmux buffer

Tmux can also read system clipboard:
Requires: bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
text

---

## PERFORMANCE & OPTIMIZATION

### GPU Acceleration
[main]

GPU acceleration enabled by default on Wayland
If issues occur:
export FOOT_NOGL=1 # Disable GPU acceleration
text

### Memory Usage
[scrollback]
lines=10000 # Adjust for memory constraints

Higher values = more memory, larger scrollback
text

### Rendering
[main]
unfocused-title-format=[%t]

Minimal updates when unfocused
text

---

## ENVIRONMENT VARIABLES

FOOT_NOGL # Set to 1 to disable GPU acceleration
TERM # Set to xterm-256color (auto by foot)
COLORTERM # Set to truecolor (auto by foot)

text

---

## SYSTEMD USER SERVICE (Optional)

Create `~/.config/systemd/user/foot-socket.service`:

[Unit]
Description=Foot Terminal Server
Documentation=man:foot(1)

[Service]
Type=simple
ExecStart=/usr/bin/foot --server
StandardInput=socket
StandardOutput=inherit
StandardError=inherit

text

Then start client with:
footclient -T "New Window"

text

---

## TROUBLESHOOTING

### Colors Not Rendering
Check TERM variable
echo $TERM

Should be: xterm-256color
Force truecolor
export COLORTERM=truecolor

text

### Font Issues
List available monospace fonts
fc-list | grep -i monospace

Set in config:
font=FontName:pixelsize=12

text

### Copy/Paste Not Working
Ensure wl-clipboard is installed:
sudo dnf install wl-clipboard

Or use xclip if on X11 (legacy)
sudo dnf install xclip

text

### Wayland Session Detection
Check if running on Wayland:
echo $WAYLAND_DISPLAY

Should output socket path (usually: wayland-0)
If empty, you're on X11
text

---

## CONFIGURATION EXAMPLES

### Minimal Config
[main]
term=xterm-256color
font=monospace:pixelsize=12
dpi-aware=yes

[colors]
foreground=#a8a8a8
background=#000000

text

### Development Config
[main]
term=xterm-256color
font=Source Code Pro:pixelsize=11
initial-window-size-chars=200x50
pad=15x15
letter-spacing=0
line-height=1.1

[scrollback]
lines=50000

[colors]
foreground=#ffffff
background=#1a1a1a
regular2=#00dd00 # Green for status

[keyboard]

No custom bindings (use tmux instead)
text

### Minimal Sway Integration
[main]
term=xterm-256color
font=Hack:pixelsize=11
pad=8x8

[mouse]
hide-when-typing=yes

[scrollback]
lines=5000

text

---

## COMMON WORKFLOWS

### Development Session
foot tmux

Inside tmux:
Prefix+c # new window
Prefix+% # split vertical

hjkl navigation, vim keybindings flow through all apps
text

### Quick Terminal
foot -T "scratch" -w 80x30

Quick task, close when done
text

### Multi-Pane Development
foot tmux

Inside tmux session:
Prefix+- # horizontal split (editor top, output bottom)

Left pane: nvim
Right pane: build output or testing
Navigate with Prefix+hjkl
text

---

## INTEGRATION SUMMARY

### With sway Window Manager
sway (Wayland WM) → foot (Wayland terminal) → tmux (multiplexer) → nvim/vimb/vifm

text

### Navigation Flow
sway: $mod+hjkl (window navigation)
tmux: Prefix+hjkl (pane navigation)
nvim: hjkl (vi navigation)
vimb: hjkl (vi navigation)
Copy mode: hjkl (vi navigation)

text

### Unified Keybindings
hjkl - movement (everywhere)
/ - search (everywhere)
v y p - select/copy/paste (tmux/nvim)
- command mode (tmux/nvim)
Esc - exit modes (everywhere)

text

---

## RESOURCES

man foot - foot manual
man foot.ini - configuration manual
man footclient - socket client
man foot-ctlseqs - control sequences

text

---

**Last Updated:** 2025-11-19  
**System:** Fedora Asahi | M1 Mac Mini | Wayland | sway WM  
**Integration:** sway → foot → tmux → nvim/vimb/vifm | Vi-like universal keybindings

EOF
Usage reference alias:

bash
# Add to ~/.zshrc
alias footref='nvim /mnt/data/git/fa-srv-m1m/config/foot/FOOT-REFERENCE.md'
This reference covers foot terminal operations, keybindings, configuration, and integration with your sway/tmux/nvim workflow while maintaining vi-like universal keybindings throughout the entire stack.
