-- Keymaps for Neovim, classic and plugin
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader Key Definition for plugins
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Standard navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Window resize
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- Quick save and quit
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)

-- Clear search highlight
map("n", "<Esc><Esc>", ":nohlsearch<CR>", opts)

-- Oil file explorer
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
map("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open file explorer" })
map("n", "<leader>E", "<CMD>Oil --float<CR>", { desc = "Open floating file explorer" })

-- LazyGit integration
map("n", "<leader>gg", "<CMD>LazyGit<CR>", { desc = "Open LazyGit" })
map("n", "<leader>gf", "<CMD>LazyGitFilter<CR>", { desc = "LazyGit File History" })
map("n", "<leader>gc", "<CMD>LazyGitFilterCurrentFile<CR>", { desc = "LazyGit Current File History" })

-- ZK note keymaps (Zettelkasten)
map("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", { desc = "New note" })
map("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", { desc = "Open notes" })
map("n", "<leader>zt", "<Cmd>ZkTags<CR>", { desc = "Open notes by tag" })
map("n", "<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", { desc = "Search notes" })
map("v", "<leader>zn", ":'<,'>ZkNewFromTitleSelection<CR>", { desc = "New note from selection" })
map("v", "<leader>zc", ":'<,'>ZkNewFromContentSelection<CR>", { desc = "New note from content" })
map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", { desc = "Show backlinks" })
map("n", "<leader>zl", "<Cmd>ZkLinks<CR>", { desc = "Show links" })
map("n", "<leader>zi", "<Cmd>ZkInsertLink<CR>", { desc = "Insert link" })

-- Telescope fuzzy finding
map("n", "<leader>ff", "<CMD>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<CMD>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<CMD>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<CMD>Telescope help_tags<CR>", { desc = "Help tags" })

-- Which-key plugin loads this file for reference

