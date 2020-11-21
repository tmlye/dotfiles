#!/bin/bash

# Create .config directory if needed
mkdir -p $HOME/.config

declare -a links=(.gitconfig .zlogin .zshrc .vim .vimrc .config/zathura/zathurarc .config/htop/htoprc .config/gtk-3.0 .config/ranger .tmux.conf .config/viewnior/viewnior.conf .config/user-dirs.dirs .config/waybar)

# If files already exist create backups
for i in ${links[*]}
do
  if [ -e $HOME/$i ]
    then mv ~/$i ~/$i.backup
  fi
done

# sway
mkdir -p $HOME/.config/sway
ln -s $HOME/.dotfiles/sway/config $HOME/.config/sway/config

# set environment variables so firefox uses wayland and xdg-desktop-portal-wlr works
mkdir -p $HOME/.config/environment.d
ln -s $HOME/.dotfiles/various/env.conf $HOME/.config/environment.d/env.conf

# waybar
ln -s $HOME/.dotfiles/waybar $HOME/.config/waybar

# alacritty
mkdir -p $HOME/.config/alacritty
ln -s $HOME/.dotfiles/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml

# mako
mkdir -p $HOME/.config/mako
ln -s $HOME/.dotfiles/mako/config $HOME/.config/mako/config

# X
ln -s $HOME/.dotfiles/X/Xresources $HOME/.Xresources

# zsh
ln -s $HOME/.dotfiles/zsh/zshrc $HOME/.zshrc
ln -s $HOME/.dotfiles/zsh/zlogin $HOME/.zlogin

# vim
ln -s $HOME/.dotfiles/vim/vim/ $HOME/.vim
ln -s $HOME/.dotfiles/vim/vimrc $HOME/.vimrc

# gtk
ln -s $HOME/.dotfiles/gtk $HOME/.config/gtk-3.0

# ranger
ln -s $HOME/.dotfiles/ranger/ $HOME/.config/ranger

# tmux
ln -s $HOME/.dotfiles/various/tmux.conf $HOME/.tmux.conf

# zathura
mkdir -p $HOME/.config/zathura
ln -s $HOME/.dotfiles/various/zathurarc $HOME/.config/zathura/zathurarc

# htop
mkdir -p $HOME/.config/htop
ln -s $HOME/.dotfiles/various/htoprc $HOME/.config/htop/htoprc

# viewnior
mkdir -p $HOME/.config/viewnior
ln -s $HOME/.dotfiles/various/viewnior.conf $HOME/.config/viewnior/viewnior.conf

# vscode
mkdir -p $HOME/.config/Code\ -\ OSS/User
ln -s $HOME/.dotfiles/vscode/settings.json $HOME/.config/Code\ -\ OSS/User/settings.json
ln -s $HOME/.dotfiles/vscode/keybindings.json $HOME/.config/Code\ -\ OSS/User/keybindings.json

# git
ln -s $HOME/.dotfiles/various/gitconfig $HOME/.gitconfig

# don't use Desktop, use desktop
ln -s $HOME/.dotfiles/various/user-dirs.dirs $HOME/.config/user-dirs.dirs

echo "If you want to setup mail, check the .dotfiles/mail directory."
