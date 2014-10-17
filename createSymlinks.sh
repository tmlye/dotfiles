#!/bin/bash

# Create .config directory if needed
mkdir -p $HOME/.config

declare -a links=(.config/awesome .Xresources .zshrc .ncmpcpp .vim .vimrc .XkeymapUS .XkeymapDE .config/zathura/zathurarc)

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
ln -s $HOME/.dotfiles/X/xinitrc $HOME/.xinitrc
ln -s $HOME/.dotfiles/X/Xresources $HOME/.Xresources
ln -s $HOME/.dotfiles/X/XkeymapUS $HOME/.XkeymapUS
ln -s $HOME/.dotfiles/X/XkeymapDE $HOME/.XkeymapDE

# zsh
ln -s $HOME/.dotfiles/zsh/zshrc $HOME/.zshrc

# ncmpcpp
ln -s $HOME/.dotfiles/ncmpcpp/ $HOME/.ncmpcpp

# vim
ln -s $HOME/.dotfiles/vim/vim/ $HOME/.vim
ln -s $HOME/.dotfiles/vim/vimrc $HOME/.vimrc

# ranger
ln -s $HOME/.dotfiles/ranger/ $HOME/.config/ranger

# browser
ln -s $HOME/.dotfiles/browser/pentadactylrc $HOME/.pentadactylrc

# zathura
mkdir -p $HOME/.config/zathura
ln -s $HOME/.dotfiles/various/zathurarc $HOME/.config/zathura/zathurarc

# htop
mkdir -p $HOME/.config/htop
ln -s $HOME/.dotfiles/various/htoprc $HOME/.config/htop/htoprc

# viewnior
mkdir -p $HOME/.config/viewnior
ln -s $HOME/.dotfiles/various/viewnior.conf $HOME/.config/viewnior/viewnior.conf

# don't use Desktop, use desktop
ln -s $HOME/.dotfiles/various/user-dirs.dirs $HOME/.config/user-dirs.dirs


echo "You'll have to symlink the userChrome.css file manually to ~/.mozilla/firefox/<profile_dir>/chrome/userChrome.css if you want to use it."
echo "If you want to setup mail, check the .dotfiles/mail directory."
