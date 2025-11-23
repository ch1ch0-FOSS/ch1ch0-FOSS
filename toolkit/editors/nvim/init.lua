-- /mnt/data/git/fa-srv-m1m/config/nvim/init.lua
-- Neovim init.lua - Universal ncurses theme with zk, lazygit, oil
-- Location: <your-git-repo>/nvim/init.lua
-- Symlink to: ~/.config/nvim/init.lua
--
-- Workflow-focused configuration for:
-- - zk (Zettelkasten note-taking)
-- - lazygit (Git UI)
-- - oil.nvim (File explorer)
--
-- To symlink from git repo:
-- ln -sf /path/to/your/git/repo/nvim ~/.config/nvim

-- =============================================================================
-- BASIC SETTINGS
-- =============================================================================

-- Leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Enable true color support
vim.opt.termguicolors = false
vim.opt.background = "dark"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Display
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showmatch = true
vim.opt.cursorline = false
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- Split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Update time for better responsiveness
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Enable mouse
vim.opt.mouse = "a"

-- Clipboard (use system clipboard)
vim.opt.clipboard = "unnamedplus"

-- Persistent undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Enable filetype detection
vim.cmd('filetype plugin indent on')

-- =============================================================================
-- BOOTSTRAP LAZY.NVIM (Plugin Manager)
-- =============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- PLUGIN SPECIFICATIONS
-- =============================================================================

require("lazy").setup({
  -- Color scheme (optional - respects terminal colors by default)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Use default colorscheme to respect terminal colors
      -- Uncomment below to use tokyonight
      -- vim.cmd([[colorscheme tokyonight-night]])
    end,
  },

  -- Telescope (fuzzy finder - required for zk)
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({
        defaults = {
          layout_strategy = 'horizontal',
          layout_config = { height = 0.9, width = 0.9 },
        }
      })
    end
  },

  -- ZK (Zettelkasten note-taking)
  {
    "zk-org/zk-nvim",
    config = function()
      require("zk").setup({
        picker = "telescope",
        
        lsp = {
          config = {
            cmd = { "zk", "lsp" },
            name = "zk",
            filetypes = { "markdown" },
          },
          auto_attach = {
            enabled = true,
            filetypes = { "markdown" },
          },
        },
      })
    end
  },

  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      -- LazyGit configuration handled via keymaps below
    end
  },

  -- Oil.nvim (file explorer as buffer)
  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        columns = {
          "icon",
          "permissions",
          "size",
          "mtime",
        },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = false,
        view_options = {
          show_hidden = false,
          is_hidden_file = function(name, bufnr)
            return vim.startswith(name, ".")
          end,
        },
        float = {
          padding = 2,
          max_width = 90,
          max_height = 0,
        },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-v>"] = "actions.select_vsplit",
          ["<C-x>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-r>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
      })
    end,
  },

  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "markdown", "bash", "python", "javascript", "json" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require('lspconfig')
      
      -- Basic on_attach for keymaps
      local on_attach = function(client, bufnr)
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
      end
      
      -- You can add more LSP servers here
      -- Example: lspconfig.pyright.setup{ on_attach = on_attach }
    end
  },

  -- Git signs (show git changes in gutter)
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },

  -- Which-key (show keybindings)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      require("which-key").setup({})
    end
  },

  -- Auto pairs
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },

  -- Comment.nvim (easy commenting)
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },

  -- Lualine (status line)
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto',
          section_separators = '',
          component_separators = '|'
        }
      })
    end
  },

})

-- =============================================================================
-- COLOR CUSTOMIZATION (Terminal-aware)
-- =============================================================================

-- CRITICAL: Disable true color for foot terminal compatibility
vim.opt.termguicolors = false

-- Set up highlights to respect terminal colors
vim.cmd([[colorscheme default]])

local function set_hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Cursor: bright green, fast blink
vim.opt.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,o:hor50-Cursor/lCursor,a:blinkwait300-blinkoff200-blinkon200-Cursor/lCursor"
set_hl('Cursor', { ctermbg = 10, ctermfg = 0 })  -- Bright green cursor
set_hl('lCursor', { ctermbg = 10, ctermfg = 0 })

-- Line numbers - grey
set_hl('LineNr', { ctermfg = 7, ctermbg = 0 })
set_hl('CursorLineNr', { ctermfg = 2, bold = true })

-- Visual selection - GREEN background, black text
set_hl('Visual', { ctermbg = 2, ctermfg = 0, bold = true })

-- Search - GREEN background, black text  
set_hl('Search', { ctermbg = 2, ctermfg = 0 })
set_hl('IncSearch', { ctermbg = 10, ctermfg = 0, bold = true })  -- Bright green for current match

-- Status line - green text on black
set_hl('StatusLine', { ctermfg = 2, ctermbg = 0, bold = true })
set_hl('StatusLineNC', { ctermfg = 7, ctermbg = 0 })

-- Popup menu
set_hl('Pmenu', { ctermbg = 8, ctermfg = 7 })
set_hl('PmenuSel', { ctermbg = 2, ctermfg = 0 })

-- Match parentheses
set_hl('MatchParen', { ctermbg = 10, ctermfg = 0, bold = true })


-- =============================================================================
-- KEY MAPPINGS
-- =============================================================================

local keymap = vim.keymap.set

-- Clear search highlight
keymap('n', '<Esc><Esc>', ':nohlsearch<CR>', { silent = true })

-- Better window navigation
keymap('n', '<C-h>', '<C-w>h', { noremap = true })
keymap('n', '<C-j>', '<C-w>j', { noremap = true })
keymap('n', '<C-k>', '<C-w>k', { noremap = true })
keymap('n', '<C-l>', '<C-w>l', { noremap = true })

-- Resize windows
keymap('n', '<C-Up>', ':resize +2<CR>', { silent = true })
keymap('n', '<C-Down>', ':resize -2<CR>', { silent = true })
keymap('n', '<C-Left>', ':vertical resize -2<CR>', { silent = true })
keymap('n', '<C-Right>', ':vertical resize +2<CR>', { silent = true })

-- Buffer navigation
keymap('n', '<S-l>', ':bnext<CR>', { silent = true })
keymap('n', '<S-h>', ':bprevious<CR>', { silent = true })

-- Stay in indent mode
keymap('v', '<', '<gv', { noremap = true })
keymap('v', '>', '>gv', { noremap = true })

-- Move text up and down
keymap('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true })
keymap('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true })

-- =============================================================================
-- OIL.NVIM KEYMAPS
-- =============================================================================

-- Open oil file explorer
keymap('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
keymap('n', '<leader>e', '<CMD>Oil<CR>', { desc = 'Open file explorer' })
keymap('n', '<leader>E', '<CMD>Oil --float<CR>', { desc = 'Open floating file explorer' })

-- =============================================================================
-- LAZYGIT KEYMAPS
-- =============================================================================

-- Open lazygit
keymap('n', '<leader>gg', '<CMD>LazyGit<CR>', { desc = 'Open LazyGit' })
keymap('n', '<leader>gf', '<CMD>LazyGitFilter<CR>', { desc = 'LazyGit File History' })
keymap('n', '<leader>gc', '<CMD>LazyGitFilterCurrentFile<CR>', { desc = 'LazyGit Current File History' })

-- =============================================================================
-- ZK KEYMAPS (Zettelkasten)
-- =============================================================================

-- Create new note
keymap('n', '<leader>zn', "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", { desc = 'New note' })

-- Open notes
keymap('n', '<leader>zo', "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", { desc = 'Open notes' })

-- Open notes with tag
keymap('n', '<leader>zt', "<Cmd>ZkTags<CR>", { desc = 'Open notes by tag' })

-- Search notes
keymap('n', '<leader>zf', "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", { desc = 'Search notes' })

-- Create new note from visual selection
keymap('v', '<leader>zn', ":'<,'>ZkNewFromTitleSelection<CR>", { desc = 'New note from selection' })

-- Create new note from content selection
keymap('v', '<leader>zc', ":'<,'>ZkNewFromContentSelection<CR>", { desc = 'New note from content' })

-- Backlinks
keymap('n', '<leader>zb', "<Cmd>ZkBacklinks<CR>", { desc = 'Show backlinks' })

-- Links
keymap('n', '<leader>zl', "<Cmd>ZkLinks<CR>", { desc = 'Show links' })

-- Insert link
keymap('n', '<leader>zi', "<Cmd>ZkInsertLink<CR>", { desc = 'Insert link' })

-- =============================================================================
-- TELESCOPE KEYMAPS
-- =============================================================================

keymap('n', '<leader>ff', '<CMD>Telescope find_files<CR>', { desc = 'Find files' })
keymap('n', '<leader>fg', '<CMD>Telescope live_grep<CR>', { desc = 'Live grep' })
keymap('n', '<leader>fb', '<CMD>Telescope buffers<CR>', { desc = 'Find buffers' })
keymap('n', '<leader>fh', '<CMD>Telescope help_tags<CR>', { desc = 'Help tags' })

-- =============================================================================
-- AUTOCOMMANDS
-- =============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
augroup('highlight_yank', { clear = true })
autocmd('TextYankPost', {
  group = 'highlight_yank',
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
  end,
})

-- Markdown-specific settings for zk
augroup('zk_markdown', { clear = true })
autocmd('FileType', {
  group = 'zk_markdown',
  pattern = 'markdown',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})

-- Return to last edit position when opening files
augroup('restore_cursor', { clear = true })
autocmd('BufReadPost', {
  group = 'restore_cursor',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- =============================================================================
-- NOTES
-- =============================================================================

-- Workflow:
-- 1. <leader>e or - : Open Oil file explorer (edit filesystem like a buffer)
-- 2. <leader>gg : Open LazyGit (full git UI)
-- 3. <leader>zn : Create new zk note
-- 4. <leader>zo : Browse existing zk notes
-- 5. <leader>zf : Search notes by content
-- 6. <leader>ff : Telescope file finder
-- 7. <leader>fg : Telescope grep search

-- Integration tips:
-- - Oil.nvim: Navigate with hjkl, edit filenames, save buffer to commit changes
-- - LazyGit: Full git workflow (stage, commit, push, pull, merge, rebase)
-- - ZK: Create linked notes, use [[wiki-links]], search with telescope
-- - Use :help <plugin-name> for more info on each plugin
