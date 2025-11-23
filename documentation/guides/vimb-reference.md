# VIMB COMPLETE REFERENCE GUIDE
**Vi-like Browser | Keyboard-Only Web Navigation**

---

## OVERVIEW

Vimb is a vi-like browser that eliminates mouse dependency:
- Keyboard-driven workflow
- Vi-like keybindings throughout
- Fast, lightweight (WebKit-based)
- Tabbed interface
- URL hints for link navigation
- Search and filtering
- Command mode for operations
- Minimalist design

---

## LAUNCHING VIMB

vimb # Launch vimb
vimb {url} # Open URL
vimb --help # Show help
vimb --version # Version info
vimb --config {config} # Custom config
vimb about:version # Version page
vimb -e {cmd} # Execute command on start

text

### With Tabbed (Recommended)
tabbed -c vimb -e # Tabbed interface

Ctrl+Shift+t = new tab
Ctrl+Shift+q = close tab
text

---

## MODES

| Mode | Enter | Exit | Description |
|------|-------|------|-------------|
| **Normal** | Default | - | Navigation & commands |
| **Insert** | `i` | `Esc` | Text input in forms |
| **Command** | `:` | `Enter`/`Esc` | Ex-style commands |
| **Search** | `/`, `?` | `Enter`/`Esc` | Find on page |

---

## NAVIGATION

### Basic Movement
h - scroll left
j - scroll down
k - scroll up
l - scroll right

text

### Page Navigation
gg - top of page
G - bottom of page
Ctrl+d - page down
Ctrl+u - page up
d - half page down
u - half page up

text

### History Navigation
H - back (history previous)
L - forward (history next)
Ctrl+^ - toggle between last two pages

text

### Tab Navigation
gt - next tab (with tabbed)
gT - previous tab (with tabbed)
Ctrl+Tab - next tab
Ctrl+Shift+Tab - previous tab
g{n} - goto tab n (0-9)

text

### Link Following

f - hint mode (follow link)
F - hint mode (open in new tab)
;y - copy link URL
;i - copy image URL
;I - save image as
gf - view frame source

text

### Scrolling

j - scroll down
k - scroll up
h - scroll left
l - scroll right
0 - scroll to left edge
$ - scroll to right edge
m - mark position
' - jump to mark

text

---

## HINTING & LINK INTERACTION

### Hint Mode
f - hint mode (follow links)
F - hint mode (new tab)
;y - yank/copy link
;w - save link as
;i - copy image URL
;I - save image
;s - search in Google (highlighted text)
;S - search in another engine

text

### Hint Selection
After pressing f/F:
a-z - select hint by letter
0-9 - select hint by number
Ctrl+j/k - cycle through hints
Enter - follow selected hint
Esc - cancel hint mode

text

### Keyboard Shortcuts for Links
gi - focus input (first form field)
gf - view page info
gy - yank current URL
yy - yank URI

text

---

## SEARCHING

### Search on Page
/pattern - search forward
?pattern - search backward
n - next match
N - previous match
Escape - clear search highlights

text

### Search Engines (in Command Mode)
:open {query}
:tabopen {query}
:search {query}

Configure shortcuts in config file:
shortcut-add {name}={search-url}
shortcut-default={engine}

text

### Search Engine Examples
:shortcut-add ddg=https://duckduckgo.com/?q=$0
:shortcut-add gh=https://github.com/search?q=$0
:shortcut-add wiki=https://en.wikipedia.org/wiki/$0
:shortcut-add yt=https://www.youtube.com/results?search_query=$0

text

---

## COMMAND MODE

### Access Command Mode
text
          - enter command mode
:command {args} - execute command
:set {option} - set option
:help - show help

text

### Navigation Commands
:open {url} - open URL
:open - open last page
:tabnew - new tab
:tabopen {url} - open in new tab
:bdelete - close tab
:quit - quit vimb
:quitall - quit all
:reload - reload page
:reloadall - reload all tabs
:stop - stop loading

text

### Bookmark & History
:bookmark {url} {title} - save bookmark
:history - show history
:history {search} - search history
:bmarks - show bookmarks

text

### Settings
:set {option}={value} - set option
:set {option}! - toggle option
:set {option}? - show option value
:set {option}& - reset to default

text

### Abbreviations & Shortcuts
:abbr {shorthand} {expansion} - text abbreviation
:shortcut-add {name}={url} - search shortcut
:shortcut-default={engine} - default search
:map {key} {command} - custom keybinding

text

---

## STATUS BAR & INDICATORS

### Status Line Information
text
         - current tab number[1]
(L) - loading indicator
[*] - modified indicator
[+] - secure (HTTPS)
[-] - insecure (HTTP)

text

### Show/Hide Status Bar
:set status-bar-show-settings=true # Show options in status
:set status-bar-show-settings=false # Hide options

text

---

## VISUAL MODE & SELECTION

### Text Selection
v - enter visual mode
V - line selection
Ctrl+v - block selection

text

### Selection Operations
yy - yank (copy) selection
d - delete selection
y - copy selection
p - paste

text

### Search Highlighted Text
After selecting text:
;s - search in default engine
;S - search in other engine

text

---

## COPY & PASTE

### Yank/Copy Operations
yy - copy current URL
yw - copy page title
yf - copy link (hint mode + y)
yc - copy page content
;y - copy link URL (in hint mode)
;i - copy image URL

text

### Paste Operations
p - paste URL in current tab
P - paste URL in new tab
gp - paste and go (current tab)
gP - paste and go (new tab)

text

### Registers
Vimb uses system clipboard (limited local registers)
Copy integrates with system via xclip/wl-copy
text

---

## ZOOMING

### Font Size
text
          - increase zoom
text
          - decrease zoom
= - reset zoom

text

### Persistent Zoom
:set zoom-level=150 # Set zoom percentage
:set font-size=14 # Set font size

text

---

## TABS & WINDOWS

### Tab Operations
:tabnew # new tab
:tabopen {url} # new tab with URL
:tablast # last tab
:tabnext # next tab
:tabprevious # previous tab
:tabonly # close all others
:bdelete # delete current tab
:bdelall # delete all tabs

text

### Tab Navigation (with Tabbed)
Ctrl+Shift+t # new tab (tabbed)
Ctrl+Shift+w # close tab (tabbed)
Ctrl+Shift+q # close window (tabbed)
Ctrl+Shift+Left # previous tab (tabbed)
Ctrl+Shift+Right # next tab (tabbed)

text

---

## CONFIGURATION

### Config File Location
~/.config/vimb/config

text

### Core Settings
Display
set dark-mode=on
set scrollbars=false
set status-bar-show-settings=true
set smooth-scrolling=true

Fonts
set default-font=monospace
set monospace-font-size=12
set font-size=14

Security
set strict-ssl=true
set cookie-accept=origin
set webgl=false
set geolocation=ask
set notification=ask

Downloads
set download-path=~/Downloads
set prevent-newwindow=true

Homepage
set home-page=https://start.duckduckgo.com

Hints
set hint-keys=asdfghjkl
set hint-timeout=5000
set hint-follow-last=true

Misc
set default-zoom=100
set input-autohide=true

text

### Search Shortcuts
shortcut-default=ddg
shortcut-add ddg=https://duckduckgo.com/?q=$0
shortcut-add gh=https://github.com/search?q=$0
shortcut-add wiki=https://en.wikipedia.org/wiki/$0
shortcut-add yt=https://www.youtube.com/results?search_query=$0
shortcut-add reddit=https://www.reddit.com/search?q=$0

text

### Editor Integration
set editor-command=foot -e nvim %s

text

---

## KEYBOARD SHORTCUTS

### Vi-like Navigation Summary
h j k l - scroll/navigate
gg G - top/bottom of page
/ ? - search forward/backward
n N - next/previous match
f F - follow link / new tab
H L - back/forward
gt gT - next/previous tab
/ - command/search mode
Esc - escape/clear

text

### Quick Commands
r - reload
Ctrl+c - stop
d - scroll down (half page)
u - scroll up (half page)
yy - copy URL
p P - paste in tab/new tab

= - zoom in/out/reset
gi - goto input

text

---

## HISTORY & BOOKMARKS

### Browsing History
:history # Show history
:history {search} # Search history
{backspace} # Go back

text

### Bookmarks
:bookmark {url} {title} # Save bookmark
:bmarks # List bookmarks
:open {bookmark} # Open bookmark

text

### Save & Load
Bookmarks stored in:
~/.config/vimb/bookmarks

History stored in:
~/.config/vimb/history

text

---

## FORMS & INPUT

### Form Navigation
gi - focus first input field
Tab - next form field
Shift+Tab - previous form field
Ctrl+j - submit form (in some cases)

text

### Text Input in Forms
i - enter insert mode
Esc - exit insert mode (form still focused)
Ctrl+a - select all in field
Ctrl+u - clear line
Ctrl+h - backspace

text

---

## SPECIAL PAGES

### Built-in Pages
about:version - version info
about:blank - blank page
about:plugins - plugins info
view-source: - view page source (prefix URL)

text

### Source Viewing
gs - view page source
gf - view frame source
:inspect - developer tools (if enabled)

text

---

## PRIVACY & SECURITY

### Cookie Handling
set cookie-accept=origin # Accept same-origin only
set cookie-accept=never # Never accept
set cookie-accept=always # Accept all

text

### Privacy Settings
set strict-ssl=true # Require valid SSL
set webgl=false # Disable WebGL
set geolocation=ask # Ask for location
set notification=ask # Ask for notifications
set header=DNT=1 # Set Do Not Track

text

### Clearing Data
:se privacy mode in config or use external tools

Data cleared on exit if configured
text

---

## INTEGRATION WITH SYSTEM

### With Tmux
In tmux:
Prefix+h/j/k/l # Navigate tmux panes

Within vimb, use same hjkl for page scrolling
No conflicts - context-aware
text

### With Sway
In sway config:
bindsym $mod+w exec vimb # Launch vimb
bindsym $mod+Tab exec "swaymsg '[app_id="vimb"]' focus"

text

### With Foot Terminal
Launch in foot:
foot vimb

Or run external commands from vimb:
:!command

text

### With Nvim
Vimb shares vi-keybindings with nvim:
hjkl - navigation
/ - search
: - commands
y p - yank/paste

text

---

## WORKFLOW PATTERNS

### Research Session
Start vimb
vimb

Navigate with hjkl
Search with /
Follow links with f
Open in new tab with F
Switch tabs with gt/gT
Copy URLs with yy
Paste with p/P
text

### Tab Management
Multiple searches in parallel
:tabopen duck.com
:tabopen github.com
gt # cycle through results

Switch between results easily
text

### Quick Web Search
Configured shortcuts:
:open linux tutorial # Search (default engine)
:tabopen python docs # New tab search

text

---

## SCRIPTING & AUTOMATION

### Command Line
vimb "https://example.com" # Open URL
vimb -e ":open https://github.com" # Execute command

text

### External Commands
:!command # Run shell command
:r !command # Insert command output
:s/old/new/ # Substitute (limited)

text

---

## TROUBLESHOOTING

### Common Issues

**Hints not working:**
Check hint-keys setting in config
:set hint-keys=asdfghjkl
Restart vimb

text

**Links not opening:**
Check JavaScript/content settings
:set strict-ssl=false (if SSL issues)
Reload page

text

**Search shortcuts not working:**
Verify shortcut-add syntax in config
Use :shortcut-add {name}={url}
Replace $0 with query placeholder

text

**Zoom not persistent:**
Use :set default-zoom=150
Or set zoom for specific sites

text

---

## ADVANCED KEYBINDINGS

### Custom Maps (in config)
Format: map {key} {command}
map W :tabopen
map d :bdelete
map r :reload
map Y :sh echo $VIMB_URI | xclip -selection clipboard

text

### Special Keys
<CR> - Enter
<Esc> - Escape
<Tab> - Tab
<Space> - Space
<C-> - Ctrl+key
<A-> - Alt+key
<S-*> - Shift+key

text

---

## EXTENSION & CUSTOMIZATION

### Ad Blocker
set webgl=false # Disable WebGL tracking
set notification=ask # Control notifications
set geolocation=ask # Control location
set header=DNT=1 # Send DNT header

text

### User Styles
Limited CSS customization available
Mainly through WebKit settings
text

---

## BROWSER COMPARISON

### Vimb vs Other Browsers
Vimb:

Vi-like keybindings

Lightweight & fast

Keyboard-driven

No mouse required

Minimalist interface

Limited extension support

Smaller community

No developer tools (limited)

WebKit only (no Firefox engine)

text

---

## COMMON WORKFLOWS

### Daily Browsing
vimb

Homepage loaded
/ search
n find next
f follow link (or F new tab)
gt switch tabs
yy copy interesting URL
H/L back/forward

text

### Research Project
vimb
:tabopen search1 # Tab 1: search
:tabopen search2 # Tab 2: documentation
:tabopen search3 # Tab 3: reference
gt # cycle through

Collect URLs with yy
Paste to notes with p in tmux
text

### Development Documentation
vimb https://docs.example.com
/ search documentation
f follow links
;y copy code snippets to external clipboard

Switch to nvim, paste with Ctrl+Shift+v
text

---

## SYSTEM INTEGRATION SUMMARY

### Vi-like Universal Flow
sway (Wayland)
↓
vimb (browser hjkl)
↓
tmux (terminal hjkl)
↓
nvim/zk (editor hjkl)

All tools share:

hjkl navigation

/ search

: command mode

Esc to cancel

text

---

## RESOURCES & HELP

vimb --help # Command help
man vimb # Manual page
man vimbrc # Config manual
:help # In-browser help
~/.config/vimb/config # Your config

text

---

**Last Updated:** 2025-11-19  
**System:** Fedora Asahi | M1 Mac Mini | Wayland  
**Integration:** sway → vimb → tmux → nvim/zk | Vi-like universal keybindings

EOF
Usage reference alias:

bash
# Add to ~/.zshrc
alias vimbref='nvim /mnt/data/git/fa-srv-m1m/config/vimb/VIMB-REFERENCE.md'
This reference covers all vimb operations—navigation, hinting, search, tabs, configuration, and integration with your sway/tmux/nvim ecosystem while maintaining vi-like universal keybindings throughout.
