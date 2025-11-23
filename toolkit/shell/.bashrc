# .bashrc

export TERM=foot
export COLORTERM=truecolor
export EDITOR=nvim
export VISUAL=nvim

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Use 'less' as the pager, with optimal flags
export SYSTEMD_PAGER="less -FMR"

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi

# Green user@host:  (ANSI color 2), grey command (245)
PS1='\[\e[38;5;2m\]\u@\h:\[\e[38;5;245m\] \w\$ \[\e[0m\]'

# For lazygit integration with neovim
if [ -n "$NVIM" ]; then
    export GIT_EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
    export GIT_EDITOR="nvim"
fi

# Start nvim with server for lazygit integration
alias nvim='nvim --listen /tmp/nvim-server.pipe'

unset rc

# Source shared profile, aliases, functions
[ -f ~/toolkit/shell/profile.sh ] && source ~/toolkit/shell/profile.sh
[ -f ~/toolkit/shell/aliases.sh ] && source ~/toolkit/shell/aliases.sh
[ -f ~/toolkit/shell/functions.sh ] && source ~/toolkit/shell/functions.sh

