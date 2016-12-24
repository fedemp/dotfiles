#!/bin/env bash
git submodule init
git submodule update
ln -s zshrc ~/.zshrc
ln -s zprofile ~/.zprofile
ln -s zshenv ~/.zshenv
ln -s tmux.conf ~/.tmux.conf
ln -s dir_colors ~/.dir_colors
ln -s gtkrc-2.0 ~/.gtkrc-2.0
ln -s functions ~/.functions
ln -s config ~/.config
