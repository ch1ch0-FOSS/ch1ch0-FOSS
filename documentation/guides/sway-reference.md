<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# repeat for sway

Create comprehensive sway reference guide in `/mnt/data/git/fa-srv-m1m/config/sway/SWAY-REFERENCE.md`:

```bash
cat > /mnt/data/git/fa-srv-m1m/config/sway/SWAY-REFERENCE.md << 'EOF'
# SWAY COMPLETE REFERENCE GUIDE
**i3wm-compatible Wayland Compositor | Window Manager | Tiling Display Server**

---

## OVERVIEW

Sway is a tiling window manager for Wayland:
- Drop-in i3 replacement (Wayland native)
- Keyboard-driven window management
- Tiling & floating windows
- Vi-like keybindings compatible
- Workspaces & virtual desktops
- Minimal configuration
- Fast & lightweight
- No mouse required (possible)

---

## LAUNCHING SWAY

### Start Sway Session
```

sway                            \# Launch sway
sway -c /path/to/config         \# Custom config
WAYLAND_DEBUG=1 sway            \# Debug mode
swaymsg --help                  \# Message command

```

### From Login Manager
```


# Select "Sway" from display manager

# Or manually in .xinitrc (if using X)

```

### Nested Sway (for testing)
```

sway -d                         \# Debug mode

```

---

## CONFIGURATION

### Config File Location
```

~/.config/sway/config
/etc/sway/config.d/
/usr/share/sway/config.d/

```

### Basic Configuration Structure
```


# Variables

set \$mod Mod4
set \$term foot

# Keybindings

bindsym \$mod+Return exec \$term

# Input settings

input * {
xkb_layout us
}

# Output settings

output * resolution 1920x1080

# Workspaces

workspace 1 output eDP-1
workspace 2 output HDMI-A-1

# Startup applications

exec_always --no-startup-id dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway

```

---

## WINDOW MANAGEMENT

### Focus & Navigation
```

\$mod+h                          \# Focus left
\$mod+j                          \# Focus down
\$mod+k                          \# Focus up
\$mod+l                          \# Focus right

\$mod+Left                       \# Focus left (arrow)
\$mod+Down                       \# Focus down
\$mod+Up                         \# Focus up
\$mod+Right                      \# Focus right

\$mod+Tab                        \# Focus last window
\$mod+u                          \# Focus child container
\$mod+a                          \# Focus parent container

```

### Move Windows
```

\$mod+Shift+h                    \# Move left
\$mod+Shift+j                    \# Move down
\$mod+Shift+k                    \# Move up
\$mod+Shift+l                    \# Move right

\$mod+Shift+Left                 \# Move left (arrow)
\$mod+Shift+Down                 \# Move down
\$mod+Shift+Up                   \# Move up
\$mod+Shift+Right                \# Move right

```

### Window Operations
```

\$mod+Return                     \# Open terminal
\$mod+d                          \# Launcher (dmenu/wofi)
\$mod+q                          \# Close window
\$mod+Shift+e                    \# Exit sway
\$mod+r                          \# Resize mode
\$mod+f                          \# Fullscreen
\$mod+Shift+f                    \# Toggle floating
\$mod+space                      \# Toggle focus (tile/float)

```

### Layout & Arrangement
```

\$mod+e                          \# Toggle split (horiz/vert)
\$mod+s                          \# Stacking layout
\$mod+w                          \# Tabbed layout
\$mod+o                          \# Toggle orientation

```

---

## WORKSPACES

### Workspace Navigation
```

\$mod+1                          \# Go to workspace 1
\$mod+2                          \# Go to workspace 2
...
\$mod+9                          \# Go to workspace 9
\$mod+0                          \# Go to workspace 10

```

### Move Window to Workspace
```

\$mod+Shift+1                    \# Move to workspace 1
\$mod+Shift+2                    \# Move to workspace 2
...
\$mod+Shift+9                    \# Move to workspace 9
\$mod+Shift+0                    \# Move to workspace 10

```

### Workspace Management
```

\$mod+Left                       \# Previous workspace
\$mod+Right                      \# Next workspace
\$mod+a                          \# Focus parent
\$mod+n                          \# Move to next workspace
\$mod+p                          \# Move to previous workspace

```

### Rename Workspace
```

bindsym \$mod+Shift+r mode "rename"
mode "rename" {
bindsym Return mode "default"
bindsym Escape mode "default"
}

```

---

## CONTAINERS & LAYOUT

### Container Focus
```

\$mod+a                          \# Focus parent
\$mod+u                          \# Focus child
\$mod+Tab                        \# Focus last

```

### Split Container
```

\$mod+v                          \# Split vertical
\$mod+h                          \# Split horizontal (default)
\$mod+e                          \# Toggle split

```

### Layout Modes
```

\$mod+s                          \# Stacking (layers)
\$mod+w                          \# Tabbed (tabs)
\$mod+e                          \# Toggle split (default)

```

### Floating Windows
```

\$mod+Shift+space                \# Toggle floating
\$mod+space                      \# Focus floating/tiling
\$mod+Shift+h/j/k/l             \# Resize floating

```

---

## SCRATCHPAD

### Scratchpad Operations
```

\$mod+minus                      \# Move to scratchpad
\$mod+plus                       \# Show scratchpad

```

### Configuration
```

for_window [title="^scratch"]   move scratchpad
bindsym \$mod+Shift+minus        move scratchpad
bindsym \$mod+grave              scratchpad show

```

---

## INPUT CONFIGURATION

### Keyboard Settings
```

input * {
xkb_layout us
xkb_variant dvorak
xkb_options ctrl:nocaps     \# Caps Lock to Ctrl
xkb_options caps:escape     \# Caps Lock to Escape
xkb_numlock enabled
repeat_delay 200
repeat_rate 30
}

input type:keyboard {
xkb_file /usr/share/X11/xkb/keymaps/us
}

```

### Mouse/Touchpad Settings
```

input type:pointer {
accel_profile flat
pointer_accel 0.5
}

input type:touchpad {
tap enabled
natural_scroll enabled
click_method clickfinger
dwt enabled
}

```

### Custom Key Bindings
```

bindsym \$mod+p exec pavucontrol
bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle

```

---

## OUTPUT CONFIGURATION

### Display Settings
```

output eDP-1 resolution 1920x1080 position 0,0
output HDMI-A-1 resolution 2560x1440 position 1920,0
output * background \#000000 solid_color

```

### Multiple Monitors
```

output HDMI-A-1 on
output eDP-1 on
output HDMI-A-1 pos 0 0
output eDP-1 pos 1920 0

# Mirror displays:

output HDMI-A-1 resolution 1920x1080
output eDP-1 resolution 1920x1080

```

### Rotation & Scaling
```

output eDP-1 rotation 90        \# Rotate 90 degrees
output HDMI-A-1 scale 1.5       \# Scale output
output * transform rotate-90    \# Transform

```

---

## STARTUP & AUTOSTART

### Execute Commands
```


# Execute once (at startup)

exec application

# Execute always (on reload)

exec_always application

# Delayed execution

exec sleep 2 \&\& application

```

### Common Startup Applications
```


# Status bar

exec_always waybar

# Background

exec_always swaybg -i ~/.config/sway/bg.png

# Compositor effects

exec_always picom

# Notification daemon

exec mako

# Clipboard manager

exec wl-paste -t text -w clipman store

```

---

## MODES & CUSTOM KEY MODES

### Resize Mode
```

mode "resize" {
bindsym h resize shrink width 10 px or 10 ppt
bindsym j resize grow height 10 px or 10 ppt
bindsym k resize shrink height 10 px or 10 ppt
bindsym l resize grow width 10 px or 10 ppt

    bindsym Return mode "default"
    bindsym Escape mode "default"
    }

bindsym \$mod+r mode "resize"

```

### Power Menu
```

set \$power "Power: (l)ock (e)xit (r)eboot (h)ibernate (s)hutdown"
mode \$power {
bindsym l exec swaylock, mode "default"
bindsym e exec swaymsg exit
bindsym r exec systemctl reboot
bindsym h exec systemctl hibernate
bindsym s exec systemctl poweroff
bindsym Escape mode "default"
bindsym Return mode "default"
}

bindsym \$mod+Escape mode \$power

```

---

## SWAYMSG & IPC

### Query Window Information
```

swaymsg -t get_tree               \# Get window tree
swaymsg -t get_workspaces         \# List workspaces
swaymsg -t get_outputs            \# List outputs
swaymsg -t get_seats              \# List seats
swaymsg -t get_config             \# Get running config

```

### Send Commands
```

swaymsg 'focus left'              \# Change focus
swaymsg 'move right'              \# Move window
swaymsg 'workspace 1'             \# Switch workspace
swaymsg 'split vertical'          \# Change split
swaymsg 'floating toggle'         \# Toggle floating

```

### IPC Socket
```

\$SWAYSOCK                         \# IPC socket path

# Use with swaymsg to send commands

```

---

## WINDOW RULES

### For Floating Windows
```

for_window [window_role="pop-up"] floating enable
for_window [window_type="dialog"] floating enable
for_window [class="Firefox" window_role="About"] floating enable

```

### By Application
```

for_window [class="Pavucontrol"] floating enable
for_window [class="Galculator"] floating enable
for_window [title="Terminator Preferences"] floating enable

```

### By Window Title
```

for_window [title="^scratch"] move scratchpad
for_window [title="Help"] floating enable

```

### Sticky Windows
```

for_window [class="mpv"] sticky enable
for_window [title="^.* - VLC\$"] sticky enable

```

### Fullscreen
```

for_window [class="mpv"] fullscreen enable

```

---

## GAPS & BORDERS

### Gap Configuration
```

gaps inner 10
gaps outer 5

# Per workspace gaps:

workspace 1 gaps inner 0
workspace 1 gaps outer 0

# Smart gaps:

smart_gaps on
smart_borders on

```

### Border & Colors
```

default_border pixel 2
default_floating_border pixel 2

# Color scheme:

client.focused          \#00ff00 \#00ff00 \#000000
client.focused_inactive \#222222 \#222222 \#ffffff
client.unfocused        \#222222 \#222222 \#888888
client.urgent           \#900000 \#900000 \#ffffff

```

---

## STATUS BAR & NOTIFICATIONS

### Waybar Integration
```


# In config:

exec_always waybar

# Waybar config:

~/.config/waybar/config
~/.config/waybar/style.css

```

### Notifications (Mako)
```


# Launch notification daemon:

exec_always mako

# Configure mako:

~/.config/mako/config

```

### Custom Status
```


# Use swaystatus or custom scripts

exec_always custom_status_script.sh

```

---

## MEDIA & BRIGHTNESS

### Volume Control
```

bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle

# Alternative (amixer):

bindsym XF86AudioRaiseVolume exec amixer -q set Master 5%+

```

### Brightness Control
```

bindsym XF86MonBrightnessUp exec brightnessctl set +5%
bindsym XF86MonBrightnessDown exec brightnessctl set 5%-

# Or using light:

bindsym XF86MonBrightnessUp exec light -A 5
bindsym XF86MonBrightnessDown exec light -U 5

```

---

## LAUNCHER & MENUS

### Application Launcher
```


# Wofi (recommended):

bindsym \$mod+d exec wofi --show drun

# Dmenu:

bindsym \$mod+d exec dmenu_run

# Rofi:

bindsym \$mod+d exec rofi -show drun

```

### Power Menu (Custom)
```

bindsym \$mod+p exec ~/.config/sway/powermenu.sh

```

---

## FOCUS & MOUSE INTEGRATION

### Focus Follows Mouse
```

focus_follows_mouse yes          \# Focus on hover
focus_follows_mouse no           \# Manual focus
mouse_warping output             \# Warp to output

```

### Click to Focus
```

focus_on_window_activation smart \# or focus, or none

```

---

## ANIMATION & EFFECTS

### Disable Animations
```


# In sway config:

# Sway has limited animation support

# Use external compositor for effects

```

### Use Wayout for Effects
```

exec_always wayout

```

---

## LOGGING & DEBUGGING

### Enable Debug Logging
```

sway -d                         \# Debug mode
WAYLAND_DEBUG=1 sway            \# Wayland debug
WLR_DRM_NO_ATOMIC=1 sway        \# Disable atomic

# View logs:

tail -f ~/.local/share/sway/logs

```

### Check Configuration
```

sway -C                         \# Check config syntax
sway -c ~/.config/sway/config   \# Use specific config

```

---

## INTEGRATION WITH OTHER TOOLS

### With Foot Terminal
```

set \$term foot
bindsym \$mod+Return exec \$term
bindsym \$mod+Shift+Return exec foot --class=floating

```

### With Tmux
```

bindsym \$mod+Return exec foot tmux

# Sway pane switching + tmux pane switching

```

### With Nvim
```


# Nvim in sway window

bindsym \$mod+e exec foot nvim

# Edit files from sway

bindsym \$mod+Shift+e exec foot nvim /path/to/file

```

### With Lazygit
```

bindsym \$mod+g exec foot lazygit

# Or with tmux:

bindsym \$mod+g exec foot tmux new-window -n git 'lazygit'

```

---

## VI-LIKE KEYBINDINGS SETUP

### Configure in Sway
```

set \$mod Mod4

# Vi-like navigation

bindsym \$mod+h focus left
bindsym \$mod+j focus down
bindsym \$mod+k focus up
bindsym \$mod+l focus right

# Vi-like movement

bindsym \$mod+Shift+h move left
bindsym \$mod+Shift+j move down
bindsym \$mod+Shift+k move up
bindsym \$mod+Shift+l move right

# Vi-like resizing

bindsym \$mod+r mode "resize"
mode "resize" {
bindsym h resize shrink width 10 px
bindsym j resize grow height 10 px
bindsym k resize shrink height 10 px
bindsym l resize grow width 10 px
bindsym Escape mode "default"
bindsym Return mode "default"
}

```

### Unified Workflow
```

sway (Wayland):         \$mod+hjkl navigation
↓
foot terminal:          \$mod+Return
↓
tmux (terminal):        Prefix+hjkl pane nav
↓
nvim/zk/git:           hjkl movement

All tools use hjkl consistently

```

---

## KEYBOARD REFERENCE

### Navigation
```

\$mod+h/j/k/l            - Move focus (vi-style)
\$mod+Left/Down/Up/Right - Move focus (arrows)
\$mod+Tab                - Focus last

```

### Movement
```

\$mod+Shift+h/j/k/l      - Move window (vi-style)
\$mod+Shift+arrow        - Move window (arrows)

```

### Workspaces
```

\$mod+1-9                - Switch workspace
\$mod+Shift+1-9          - Move to workspace

```

### Windows
```

\$mod+d                  - Launcher
\$mod+Return             - Terminal
\$mod+q                  - Close window
\$mod+f                  - Fullscreen
\$mod+Shift+f            - Floating toggle
\$mod+r                  - Resize mode

```

---

## CONFIGURATION EXAMPLES

### Minimal Config
```

set \$mod Mod4
set \$term foot

# Core keybindings

bindsym \$mod+Return exec \$term
bindsym \$mod+d exec wofi --show drun
bindsym \$mod+q kill

# Vi navigation

bindsym \$mod+h focus left
bindsym \$mod+j focus down
bindsym \$mod+k focus up
bindsym \$mod+l focus right

# Exit

bindsym \$mod+Shift+e exec swaymsg exit

# Include default config

include /etc/sway/config.d/*

```

### Full-Featured Config
```


# See ~/.config/sway/config for complete example

```

---

## COMMON WORKFLOWS

### Workspace Management
```

\$mod+1                  \# Jump to workspace 1
\$mod+Shift+1            \# Move window to workspace 1

# Work on projects in separate workspaces

```

### Multi-Monitor Workflow
```


# Primary monitor: coding

\$mod+2 on primary

# Secondary monitor: documentation

\$mod+3 on secondary

# Drag windows between monitors:

\$mod+Shift+Right

```

### Development Session
```

\$mod+Return             \# Open foot
tmux                    \# Start tmux

# Launch nvim, git, etc. in tmux panes

```

---

## RESOURCES & HELP

```

man sway                        \# Sway manual
man sway-input                  \# Input config
man sway-output                 \# Output config
man sway-bar                    \# Bar config
swaymsg --help                  \# Message help
man swaymsg                     \# Detailed help
~/.config/sway/config           \# Your config

```

---

**Last Updated:** 2025-11-19  
**System:** Fedora Asahi | M1 Mac Mini | Wayland  
**Integration:** sway (WM) → foot (terminal) → tmux/nvim/zk | Vi-like unified environment

EOF
```

Usage reference alias:

```bash
# Add to ~/.zshrc
alias swayref='nvim /mnt/data/git/fa-srv-m1m/config/sway/SWAY-REFERENCE.md'
```

This reference covers all sway operations—window management, workspaces, input/output configuration, keybindings, modes, and integration with your foot/tmux/nvim ecosystem while maintaining vi-like keybindings throughout the entire system.

