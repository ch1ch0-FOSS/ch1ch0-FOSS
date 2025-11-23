-- Custom user commands for productivity
vim.api.nvim_create_user_command("ReloadConfig", "source $MYVIMRC", {})
vim.api.nvim_create_user_command("EditConfig", "edit $MYVIMRC", {})
vim.api.nvim_create_user_command("EditZkConfig", "edit ~/notes/.zk/config.toml", {})
vim.api.nvim_create_user_command("EditGitConfig", "edit ~/.config/jesseduffield/lazygit/config.yml", {})

