#!/bin/bash
# === Shared Aliases (sourced by both bash and zsh) ===

# Editor
alias vi='nvim'
alias vim='nvim'
alias nano='nvim'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gp='git push'
alias gpl='git pull'
alias gb='git branch'
alias gco='git checkout'
alias lg='lazygit'

# Tmux
alias tm='tmux new -As master'
alias tma='tmux attach -t'
alias tmls='tmux ls'
alias tmk='tmux kill-session -t'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias gno='cd /mnt/data/git/user-GNOSIS'
alias work='cd /mnt/data/git'

# Listing
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# System
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias mkdir='mkdir -pv'

# Network
alias ports='netstat -tulanp'
alias ping='ping -c 5'

# Zk (Zettelkasten) note creation
alias zkf='zk new --template fleeting.md'
alias zkz='zk new --template zettel.md'
alias zkp='zk new --template permanent.md'
alias zkm='zk new --template moc.md'
alias zkd='zk new --template decision.md'
alias zkj='zk new --template project.md'
alias zkr='zk new --template reference.md'

# Zk search and list
alias zkl='zk list'
alias zks='zk list --interactive'
alias zke='zk edit --interactive'
alias zklf='zk list --tag fleeting'
alias zklp='zk list --tag permanent'
alias zklm='zk list --tag moc'

