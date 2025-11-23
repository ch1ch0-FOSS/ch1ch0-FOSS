# NVIM COMPLETE REFERENCE GUIDE
**Vi-like Universal Keybindings | Fedora Asahi System**

---

## MODES

| Mode | Enter | Exit | Description |
|------|-------|------|-------------|
| **Normal** | `Esc` | - | Default mode for navigation and commands |
| **Insert** | `i`, `a`, `o`, `O` | `Esc` | Text insertion |
| **Visual** | `v`, `V`, `Ctrl-v` | `Esc` | Text selection |
| **Command** | `:` | `Enter`/`Esc` | Ex commands |
| **Replace** | `R` | `Esc` | Overwrite text |

---

## NAVIGATION

### Basic Movement (hjkl)
h - left
j - down
k - up
l - right

text

### Line Navigation
0 - start of line
^ - first non-blank character
$ - end of line
g_ - last non-blank character
gm - middle of screen line

text

### Word Movement
w - next word start
e - next word end
b - previous word start
W E B - same, but WORD (space-delimited)

text

### Screen Navigation
H - top of screen
M - middle of screen
L - bottom of screen
gg - file start
G - file end
50% - 50% into file
:50 - goto line 50

text

### Scrolling
Ctrl-u - half page up
Ctrl-d - half page down
Ctrl-b - page up
Ctrl-f - page down
Ctrl-e - scroll down one line
Ctrl-y - scroll up one line
zz - center cursor on screen
zt - cursor to top
zb - cursor to bottom

text

### Paragraph & Block
{ - previous paragraph
} - next paragraph
[( - previous unmatched (
]) - next unmatched )
[{ - previous unmatched {
]} - next unmatched }
% - jump to matching bracket/paren

text

---

## SEARCH & FIND

### Search
/pattern - search forward
?pattern - search backward
n - next match
N - previous match

text
      - search word under cursor forward
- search word under cursor backward
g* - partial match forward
g# - partial match backward

text

### Find Character
f{char} - find next {char} on line
F{char} - find previous {char} on line
t{char} - till before next {char}
T{char} - till after previous {char}
; - repeat last f/F/t/T
, - repeat last f/F/t/T reverse

text

### Search Settings
:set hlsearch - highlight matches
:set incsearch - incremental search
:nohlsearch - clear highlights
:set ignorecase - case insensitive
:set smartcase - smart case (auto case-sensitive if uppercase present)

text

---

## EDITING

### Insert Mode
i - insert before cursor
I - insert at line start
a - append after cursor
A - append at line end
o - open line below
O - open line above

text

### Delete
x - delete char under cursor
X - delete char before cursor
dd - delete line
D - delete to end of line
dw - delete word
d$ - delete to end of line
d0 - delete to start of line
dgg - delete to file start
dG - delete to file end

text

### Change
cc - change line
C - change to end of line
cw - change word
ciw - change inner word
ci" - change inside quotes
cit - change inside HTML tag

text

### Copy (Yank)
yy - yank line
Y - yank line
yw - yank word
y$ - yank to end of line
ygg - yank to file start
yG - yank to file end

text

### Paste
p - paste after cursor
P - paste before cursor
]p - paste and adjust indent

text

### Undo/Redo
u - undo
Ctrl-r - redo
U - undo all changes on line

text

### Repeat
. - repeat last command
@: - repeat last : command

text

---

## VISUAL MODE

### Selection Types
v - character-wise visual
V - line-wise visual
Ctrl-v - block-wise visual (column)
gv - reselect last visual

text

### Visual Operations
o - toggle cursor to opposite end
O - toggle to other corner (block mode)
d - delete selection
c - change selection
y - yank selection

text
  - indent selection
< - unindent selection
= - auto-indent selection
u - lowercase selection
U - uppercase selection
~ - toggle case

text

### Visual Block (Ctrl-v) Special
I{text}Esc - insert text at start of each line
A{text}Esc - append text at end of each line
c{text}Esc - change selected block

text

---

## FILE OPERATIONS

### File Management
:e file - edit file
:w - write (save)
:w file - write to file
:w !sudo tee % - save with sudo
:wq - write and quit
:x - write if changed, then quit
ZZ - save and quit
ZQ - quit without saving
:q - quit
:q! - quit without saving
:qa - quit all
:qa! - quit all without saving

text

### File Navigation
:e. - file explorer (netrw)
:Ex - explore current directory
:Sex - split and explore
:Vex - vsplit and explore
gf - goto file under cursor
Ctrl-^ - alternate file
:ls - list buffers
:bn - next buffer
:bp - previous buffer
:b# - last buffer
:bd - delete buffer

text

---

## WINDOWS & SPLITS

### Creating Splits
:split - horizontal split
:vsplit - vertical split
Ctrl-w s - horizontal split
Ctrl-w v - vertical split

text

### Navigate Windows
Ctrl-w h - left window
Ctrl-w j - down window
Ctrl-w k - up window
Ctrl-w l - right window
Ctrl-w w - cycle windows
Ctrl-w p - previous window

text

### Resize Windows
Ctrl-w = - equal size
Ctrl-w _ - max height
Ctrl-w | - max width
Ctrl-w + - increase height
Ctrl-w - - decrease height
Ctrl-w > - increase width
Ctrl-w < - decrease width
:resize 20 - set height to 20
:vertical resize 80 - set width to 80

text

### Window Management
Ctrl-w q - quit window
Ctrl-w o - close all others
Ctrl-w r - rotate windows down
Ctrl-w R - rotate windows up
Ctrl-w x - exchange windows
Ctrl-w T - move to new tab

text

---

## TABS

:tabnew - new tab
:tabedit file - edit file in new tab
:tabclose - close tab
:tabonly - close all other tabs
gt - next tab
gT - previous tab
{i}gt - goto tab {i}
:tabs - list all tabs

text

---

## COMMAND MODE

### Range Syntax
:10,20{cmd} - lines 10-20
:%{cmd} - entire file
:.{cmd} - current line
:.,${cmd} - current to end
:'<,'>{cmd} - visual selection
:g/pattern/{cmd} - all lines matching pattern
:v/pattern/{cmd} - all lines NOT matching pattern

text

### Substitution
:s/old/new/ - replace first on line
:s/old/new/g - replace all on line
:%s/old/new/g - replace all in file
:%s/old/new/gc - replace all with confirm
:'<,'>s/old/new/g - replace in visual selection

text

### Common Commands
:!command - execute shell command
:r !command - read command output into buffer
:w !command - pipe buffer to command
:.!command - filter current line through command
:%!command - filter file through command
:make - run make
:grep pattern - run grep
:copen - open quickfix window
:cnext - next quickfix item
:cprev - previous quickfix item

text

---

## MARKS & JUMPS

### Marks
ma - set mark 'a' (local to file)
mA - set mark 'A' (global)
'a - jump to line of mark 'a'
`a - jump to position of mark 'a'
:marks - list all marks
'. - jump to last change
`` - jump to last jump position

text

### Jump List
Ctrl-o - jump to older position
Ctrl-i - jump to newer position
:jumps - show jump list

text

### Change List
g; - goto older change
g, - goto newer change
:changes - show change list

text

---

## MACROS

q{register} - start recording to {register}
q - stop recording
@{register} - execute macro
@@ - repeat last macro
:reg - show all registers

text

---

## REGISTERS

### Special Registers
" - unnamed (last delete/yank)
0 - last yank
1-9 - last 9 deletes

text
          - small delete
a-z - named registers
A-Z - append to named registers
% - current filename

- alternate filename
text
          - last command
/ - last search

text
          - system clipboard
text
          - primary selection
text

### Using Registers
"{register}y - yank to register
"{register}p - paste from register
Ctrl-r {reg} - insert register in insert/command mode

text

---

## TEXT OBJECTS

### Inner vs A (Around)
iw - inner word
aw - a word (includes space)
i" - inside quotes
a" - around quotes (includes quotes)
i( - inside parentheses
a( - around parentheses
i[ - inside brackets
a[ - around brackets
i{ - inside braces
a{ - around braces
it - inside HTML tag
at - around HTML tag
ip - inner paragraph
ap - a paragraph
is - inner sentence
as - a sentence

text

### Usage Examples
ciw - change inner word
di" - delete inside quotes
va( - visual select around parentheses
yit - yank inside HTML tag

text

---

## FOLDING

zf{motion} - create fold
zd - delete fold
zD - delete all folds at cursor
zo - open fold
zc - close fold
za - toggle fold
zR - open all folds
zM - close all folds
zj - move to next fold
zk - move to previous fold

text

---

## SPELL CHECKING

:set spell - enable spell check
:set nospell - disable spell check
]s - next misspelled word
[s - previous misspelled word
z= - suggest corrections
zg - add to dictionary
zw - mark as wrong

text

---

## COMPLETION (Insert Mode)

Ctrl-n - next completion
Ctrl-p - previous completion
Ctrl-x Ctrl-n - keyword completion
Ctrl-x Ctrl-f - filename completion
Ctrl-x Ctrl-l - line completion
Ctrl-x Ctrl-o - omni completion
Ctrl-x Ctrl-] - tag completion

text

---

## ADVANCED NAVIGATION

### Tags
Ctrl-] - jump to tag under cursor
Ctrl-t - jump back from tag
:tag {name} - jump to tag
:tags - show tag stack
:tn - next tag
:tp - previous tag

text

### Quickfix
:copen - open quickfix
:cclose - close quickfix
:cnext - next error
:cprev - previous error
:cfirst - first error
:clast - last error

text

---

## SETTINGS

### Common Options
:set number - show line numbers
:set relativenumber - relative line numbers
:set nowrap - disable line wrap
:set list - show invisible chars
:set expandtab - use spaces for tabs
:set tabstop=4 - tab width
:set shiftwidth=4 - indent width
:set autoindent - auto indent
:set smartindent - smart indent
:set clipboard=unnamedplus - use system clipboard

text

---

## HELP SYSTEM

:help {topic} - help on topic
:help :command - help on ex command
:help i_CTRL-N - help on insert mode command
:help v_d - help on visual mode command
:h 'option' - help on option
Ctrl-] - jump to tag in help
Ctrl-t - jump back
:helpgrep {pattern} - search help files

text

---

## KEY NOTATION

<CR> - Enter
<Esc> - Escape
<Tab> - Tab
<BS> - Backspace
<Space> - Space
<C-x> - Ctrl-x
<A-x> - Alt-x
<S-x> - Shift-x
<Leader> - Leader key (usually )

text

---

## VIM PHILOSOPHY

**Operator + Motion = Action**

Operators: `d` (delete), `c` (change), `y` (yank), `>` (indent), `<` (unindent), `=` (format)  
Motions: `w` (word), `$` (end), `gg` (top), `G` (bottom), `}` (paragraph)

Examples:
- `dw` - delete word
- `c$` - change to end of line
- `y}` - yank to end of paragraph
- `>ap` - indent a paragraph

**Count + Operator + Motion**
- `2dw` - delete 2 words
- `3caw` - change 3 words
- `5yy` - yank 5 lines

---

## INTEGRATION NOTES

**Unified with tmux, vimb, vifm, sway:**
- `hjkl` navigation everywhere
- `Ctrl-hjkl` window/pane navigation (with vim-tmux-navigator)
- Visual mode `v` selection matches system-wide
- `/` search forward, `?` search backward universal
- `Esc` always returns to normal/command mode
- Copy/yank uses `y`, paste uses `p`

---

**Last Updated:** 2025-11-19  
**System:** Fedora Asahi | M1 Mac Mini | ncurses green theme
EOF
Usage reference alias:

bash
# Add to ~/.zshrc
alias vimref='nvim /mnt/data/git/fa-system/config/nvim/NVIM-REFERENCE.md'
This reference covers all standard nvim operations in a quick-lookup format organized by task category, fully aligned with your vi-like universal keybindings across tmux/vimb/vifm/sway.
