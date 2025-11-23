-- ZK integration plugin configuration for Neovim
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

