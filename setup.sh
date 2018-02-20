#!/usr/bin/env bash

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
