#!/bin/bash

# Create .config directory if needed
if [ ! -d ~/.config ]
  then mkdir ~/.config
fi

declare -a links=(.config/awesome .Xdefaults .zshrc)

# If files already exist create backups
for i in ${links[*]}
do
  if [ -e $HOME/$i ]
    then mv ~/$i ~/$i.backup
  fi
done

# Awesome
ln -s $HOME/.dotfiles/awesome/ $HOME/.config/awesome

# X
ln -s $HOME/.dotfiles/X/Xdefaults $HOME/.Xdefaults

# zsh
ln -s $HOME/.dotfiles/zsh/zshrc $HOME/.zshrc
