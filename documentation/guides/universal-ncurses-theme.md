# Use these values consistently across all your terminal tools
# 
# This defines the 16 ANSI colors that tmux, vim, nvim, and other
# ncurses applications reference. Store this as reference or use
# in your tool configurations.

# =============================================================================
# 16 ANSI COLOR PALETTE - Classic ncurses green-on-black
# =============================================================================
#
# Color Index | Standard Name  | Regular (Normal)  | Bright (Bold)
# -----------+----------------+------------------+----------------
#      0     | Black          | #000000           | #555555
#      1     | Red            | #AA0000           | #FF5555
#      2     | Green          | #00AA00           | #55FF55
#      3     | Yellow         | #AA5500           | #FFFF55
#      4     | Blue           | #0000AA           | #5555FF
#      5     | Magenta        | #AA00AA           | #FF55FF
#      6     | Cyan           | #00AAAA           | #55FFFF
#      7     | White          | #AAAAAA           | #FFFFFF

# =============================================================================
# DEFAULT TEXT COLORS
# =============================================================================
#
# Foreground (text): #AAAAAA (grey - for user input contrast)
# Background: #000000 (black - classic terminal)
# Cursor: #00FF00 (green - system output green)

# =============================================================================
# USAGE IN DIFFERENT APPLICATIONS
# =============================================================================
#
# FOOT TERMINAL EMULATOR (~/.config/foot/foot.ini):
#   [colors]
#   foreground=AAAAAA
#   background=000000
#   regular0=000000
#   regular1=AA0000
#   ... etc (see foot-universal.ini)
#
# TMUX (~/.tmux.conf):
#   set -g default-terminal "tmux-256color"
#   set -ga terminal-overrides ",*:Tc"  # Enable true color
#   set -g message-style 'fg=colour2,bg=colour0'  # Green text on black
#
# NEOVIM (~/.config/nvim/init.lua):
#   vim.opt.termguicolors = true
#   vim.opt.background = "dark"
#   -- Use a colorscheme with ANSI palette support or hex values
#   vim.cmd('colorscheme default')  -- Falls back to terminal colors
#
# VIMB (Browser):
#   # Edit ~/.config/vimb/style.css for color customization
#   # Most colors inherit from terminal emulator

# =============================================================================
# KEY COLORS FOR REFERENCE
# =============================================================================
#
# Primary Output (System/Data):     Bright Green (#55FF55)
#   - Used by tools when displaying data
#   - High contrast against black background
#   - Evokes classic green CRT terminals
#
# User Input (Typing):              Grey (#AAAAAA)
#   - Distinguishes your commands from system output
#   - Reduces contrast fatigue during long sessions
#   - Easy to differentiate typed vs received text
#
# Error/Warning:                    Red family (#AA0000, #FF5555)
#   - Regular red for dim warnings
#   - Bright red for alerts/errors
#
# Cursor:                           Green (#00FF00)
#   - Bright green, high visibility
#   - Matches classic terminal aesthetic
#   - Visible on black background

# =============================================================================
# TERMINAL COMPATIBILITY NOTES
# =============================================================================
#
# 1. TMUX Configuration:
#    - Set default-terminal to "tmux-256color" for proper color support
#    - Add "terminal-overrides" to pass RGB/true color through tmux
#    - tmux-256color supports the full 256 color palette + RGB
#
# 2. NEOVIM/VIM:
#    - Set termguicolors in nvim config for true color support
#    - Falls back to 256-color palette if termguicolors unavailable
#    - Use colorschemes designed for terminal color palettes
#
# 3. VIMB (Vi-like Browser):
#    - Colors mainly inherit from foot terminal emulator
#    - Can be customized via CSS styling
#
# 4. NCURSES APPLICATIONS (htop, vim, less, etc.):
#    - All use the 16 ANSI colors defined above
#    - Respect terminal emulator color settings
#    - Work automatically with this palette

# =============================================================================
# TMUX CONFIGURATION SNIPPET (~/.tmux.conf)
# =============================================================================
#
# # Use 256-color palette
# set -g default-terminal "tmux-256color"
#
# # Enable true color pass-through
# set -ga terminal-overrides ",*:Tc"
#
# # Message colors (system messages in green)
# set -g message-style 'fg=colour2,bg=colour0'
#
# # Command line colors
# set -g message-command-style 'fg=colour7,bg=colour0'
#
# # Status bar example (customize to preference)
# set -g status-bg colour0
# set -g status-fg colour7
# set -g status-left '#[fg=colour2]#S'  # Green session name
# set -g status-right '#[fg=colour2]%H:%M'  # Green time

# =============================================================================
# NEOVIM CONFIGURATION SNIPPET (~/.config/nvim/init.lua)
# =============================================================================
#
# -- Enable true color support
# vim.opt.termguicolors = true
#
# -- Set dark background to work with this terminal scheme
# vim.opt.background = "dark"
#
# -- Use default colorscheme which respects terminal palette
# vim.cmd('colorscheme default')
#
# -- Or use a palette-aware colorscheme:
# -- vim.cmd('colorscheme gruvbox')

# =============================================================================
# ENVIRONMENT SETUP (~/.bashrc or ~/.zshrc)
# =============================================================================
#
# # Ensure proper terminal detection
# export TERM=foot
#
# # Inside tmux, use:
# export TERM=tmux-256color
#
# # For maximum compatibility with ncurses apps:
# export COLORTERM=truecolor
