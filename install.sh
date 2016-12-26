#!/bin/env bash
git submodule init
git submodule update
ln -rs ./zshrc ~/.zshrc
ln -rs zprofile ~/.zprofile
ln -rs zshenv ~/.zshenv
ln -rs tmux.conf ~/.tmux.conf
ln -rs dir_colors ~/.dir_colors
ln -rs gtkrc-2.0 ~/.gtkrc-2.0
ln -rs functions ~/.functions
ln -rs config ~/.config
ln -rs xinitrc ~/.xinitrc
