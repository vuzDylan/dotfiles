#!/usr/bin/env bash

command -v rg >/dev/null 2>&1 || { echo "I require ag but it's not installed.  Aborting." >&2; exit 1; }
command -v git >/dev/null 2>&1 || { echo "I require git but it's not installed.  Aborting." >&2; exit 1; }
command -v zsh >/dev/null 2>&1 || { echo "I require zsh but it's not installed.  Aborting." >&2; exit 1; }
command -v tmux >/dev/null 2>&1 || { echo "I require tmux but it's not installed.  Aborting." >&2; exit 1; }
command -v nvim >/dev/null 2>&1 || { echo "I require nvim but it's not installed.  Aborting." >&2; exit 1; }


git submodule init
git submodule update

dotfile_location=`pwd`

git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

ln -s $dotfile_location/aliases $HOME/.aliases
ln -s $dotfile_location/functions $HOME/.functions
ln -s $dotfile_location/oh-my-zsh $HOME/.oh-my-zsh
ln -s $dotfile_location/zshrc $HOME/.zshrc
ln -s $dotfile_location/tmux.conf $HOME/.tmux.conf
ln -s $dotfile_location/nvim $HOME/.config/nvim
ln -s $dotfile_location/dircolors $HOME/.dircolors
ln -s $dotfile_location/gitconfig $HOME/.gitconfig
