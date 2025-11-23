-- Treesitter setup for better syntax highlighting
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "vim", "markdown", "bash", "python", "json" },
  highlight = { enable = true },
  indent = { enable = true },
})

