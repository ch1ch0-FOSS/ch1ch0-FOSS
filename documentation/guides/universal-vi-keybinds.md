┌─────────────────────────────────────────────────────────┐
│              UNIVERSAL VI KEYBINDINGS                  │
├─────────────────────────────────────────────────────────┤
│                                                         │
│ NAVIGATION:                                            │
│   h, j, k, l  → left, down, up, right (everywhere)    │
│   Ctrl+h/j/k/l → window/pane switching (tmux + nvim) │
│                                                        │
│ SELECTION/VISUAL:                                     │
│   v     → begin selection/visual                       │
│   V     → line selection                               │
│   Ctrl+V → block selection                             │
│                                                        │
│ ACTION:                                                │
│   y     → yank/copy                                    │
│   d     → delete                                       │
│   p     → paste                                        │
│                                                        │
│ SEARCH:                                                │
│   /     → search forward                               │
│   ?     → search backward                              │
│   n     → next match                                   │
│   N     → prev match                                   │
│                                                        │
│ NAVIGATION (Advanced):                                 │
│   0, $  → start/end of line                            │
│   g, G  → top/bottom of file                           │
│   w, e, b → word forward/end/back                      │
│                                                        │
│ ESCAPE:                                                │
│   Escape → normal mode, cancel, return                 │
│   q     → quit (lazygit, tools)                        │
│                                                        │
└─────────────────────────────────────────────────────────┘

CROSS-TOOL VERIFICATION:

Tool       | hjkl Nav | Ctrl+hjkl Panes | v=select | y=copy | q=quit
-----------|----------|-----------------|----------|--------|--------
Tmux       | ✓        | ✓ (vim-aware)   | ✓        | ✓      | ✓
Nvim       | ✓ native | ✓               | ✓ native | ✓      | ✓
Lazygit    | ✓ native | N/A (no panes)  | ✓        | ✓      | ✓
Telescope  | ✓ mapped | N/A (picker)    | ✓        | N/A    | ✓
Sway       | ✓        | ✓ (via tmux)    | N/A      | N/A    | N/A
Zsh        | hjkl shell vi-mode (optional below)  | N/A    | N/A    | N/A

