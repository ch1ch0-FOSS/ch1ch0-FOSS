#!/bin/bash
# === Shared Shell Profile (sourced by both bash and zsh) ===

# Portable Development Environment
export CARGO_HOME=/mnt/data/dev/rust/cargo
export RUSTUP_HOME=/mnt/data/dev/rust/rustup
export GOPATH=/mnt/data/dev/go/workspace
export GOCACHE=/mnt/data/dev/go/cache
export PATH="$PATH:$CARGO_HOME/bin:$GOPATH/bin:/usr/local/bin"

# Git identity (used if .gitconfig is unavailable)
export GIT_AUTHOR_NAME="user"
export GIT_AUTHOR_EMAIL="user@duck.com"

# History settings
export HISTSIZE=10000
export HISTFILESIZE=100000
export HISTTIMEFORMAT="%Y-%m-%d %T "

# Editor and pager
export EDITOR=nvim
export VISUAL=nvim
export SYSTEMD_PAGER="less -FMR"
export TERM=foot
export COLORTERM=truecolor

# Neovim + lazygit integration
if [ -n "$NVIM" ]; then
    export GIT_EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
    export GIT_EDITOR="nvim"
fi

