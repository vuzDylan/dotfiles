export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="sunrise"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git)
unsetopt AUTO_CD

source $ZSH/oh-my-zsh.sh

eval `dircolors ~/.dircolors`

export PATH="$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

export FZF_DEFAULT_COMMAND='rg --files --follow --glob "!.git/*"'
export EDITOR=$(command -v nvim)
export VISUAL=$EDITOR

# ENABLE VI MODE
bindkey -v
KEYTIMEOUT=1
bindkey '^?' backward-delete-char # Make backspace work

# MAX_NUM FILES OPENED
ulimit -n 4096

# ^Z for fg and bg vim
foreground-vi() {
  fg %nvim
}

zle -N foreground-vi
bindkey '^Z' foreground-vi

source ~/.aliases
source ~/.functions

# Init FZF
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

[ -f $HOME/.system.zsh ] && source $HOME/.system.zsh

BASE16_SHELL=$HOME/.config/base16-shell/

[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
