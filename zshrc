export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="sunrise"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git)
unsetopt AUTO_CD

source $ZSH/oh-my-zsh.sh

eval `dircolors ~/.dircolors`

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

KEYTIMEOUT=1

set -o vi

ulimit -n 2048

foreground-vi() {
  fg %nvim
}

zle -N foreground-vi
bindkey '^Z' foreground-vi

source ~/.aliases
source ~/.functions

# Custom setting per computer
if [ -e $HOME/.system.zsh ]
then
  source $HOME/.system.zsh
fi

# Check if python
if [ -e /usr/local/bin/virtualenvwrapper.sh ]
then
  export WORKON_HOME=~/Envs
  source /usr/local/bin/virtualenvwrapper.sh
fi

# Check if node
if [ -e $HOME/.nvm/nvm.sh ]
then
  unset PREFIX
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
fi

# Check if ruby
if [ -e $HOME/.rvm/bin ]
then
  export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
fi

# Check if rust
if [ -e $HOME/.cargo/bin ]
then
  export PATH="$PATH:$HOME/.cargo/bin"
  export RUST_SRC_PATH="$HOME/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"
fi

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

[[ ! $TERM =~ "screen" ]] && tmux
