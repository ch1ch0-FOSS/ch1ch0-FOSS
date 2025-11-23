#!/bin/zsh

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY APPEND_HISTORY
setopt PROMPT_SUBST

# Git branch in prompt (vcs_info)
autoload -Uz vcs_info
precmd_functions+=(vcs_info)
zstyle ':vcs_info:git:*' formats '%F{2}(%b)%f '
zstyle ':vcs_info:*' enable git

# Vi mode indicator in prompt
function zle-line-init zle-keymap-select {
  if [[ $KEYMAP == vicmd ]]; then
    VI_MODE='%F{1}[N]%f'
  else
    VI_MODE='%F{2}[I]%f'
  fi
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Prompt: user@host:path (branch) [mode] %
PROMPT='%F{2}%n@%m%f:%F{245}%~%f ${vcs_info_msg_0_}${VI_MODE} %# '

# Vi mode
bindkey -v

# Completion
autoload -U compinit && compinit

# Source shared environment, aliases, functions
[ -f ~/toolkit/shell/profile.sh ] && source ~/toolkit/shell/profile.sh
[ -f ~/toolkit/shell/aliases.sh ] && source ~/toolkit/shell/aliases.sh
[ -f ~/toolkit/shell/functions.sh ] && source ~/toolkit/shell/functions.sh

