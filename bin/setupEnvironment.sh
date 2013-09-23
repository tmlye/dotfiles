#!/bin/bash
# This script sets up the desktop environment and installs many programs I use.

if [[ -f `pwd`/sharedfuncs ]]; then
  source sharedfuncs
else
  echo "missing file: sharedfuncs"
  exit 1
fi

install_DE(){
  package_install "xorg-server xorg-apps xorg-xinit xf86-video-vesa xautolock slock awesome zsh rxvt-unicode slim ttf-dejavu gtk-engine-murrine"
  aur_package_install "allblack-icons"
}

install_communication(){
  package_install "irssi teamspeak3"
}

install_music(){
  package_install "mpd ncmpcpp picard mplayer"
}

install_internet(){
  package_install "firefox chromium flashplugin rtorrent pptpclient"
  aur_package_install "google-talkplugin"
}

install_tools(){
  package_install "truecrypt wine virtualbox calibre viewnior zathura"
  aur_package_install "xmind dropbox dropbox-cli"
}

finish_install(){
  print_title "Finishing Installation"
  sudo -u $USER git clone https://github.com/tmlye/dotfiles.git /home/$USER/.dotfiles
  is_package_installed "zsh" && sudo -u $USER chsh -s /bin/zsh
  sudo -u $USER ./.dotfiles/createSymlinks.sh
  sudo -u $USER mkdir /home/$USER/Extern
  sudo -u $USER mkdir /home/$USER/Extern2
  print_warning "If your backup drive is not connected, please do it now."
  pause_function
  #tee /etc/modules-load.d/truecrypt.conf <<< "loop"
  partitions=(`cat /proc/partitions | awk 'length($3)>1' | awk '{print "/dev/" $4}' | awk 'length($0)>8' | grep 'sd\|hd'`)
  fdisk -l
  echo "Select the backup drive:"
  select DEVICE in "${partitions[@]}"; do
   DEVICE_NUMBER=$(( $REPLY - 1 ))
   if contains_element "$DEVICE" "${partitions[@]}"; then
      BACKUP_DRIVE=`echo $DEVICE | sed 's/[0-9]//'`
      break
   else
     invalid_option
   fi
  done
  truecrypt --text --mount $DEVICE /home/$USER/Extern/
  sudo -u $USER cp -r /home/$USER/Extern/Backup/Code /home/$USER/
  sudo -u $USER cp -r /home/$USER/Extern/Backup/Desktop /home/$USER/
  sudo -u $USER cp -r /home/$USER/Extern/Backup/Downloads /home/$USER/
  cp -f /home/$USER/Extern/Backup/OS/slim.conf /etc/
  mkdir -p /usr/share/slim/themes
  cp -r /home/$USER/Extern/Backup/OS/slim/simple /usr/share/slim/themes/
  sudo -u $USER cp -r /home/$USER/Extern/Backup/OS/home/.* /home/$USER/
  echo "Enabling slim"
  system_ctl enable slim
  pause_function
}

AUR_PGK_MANAGER=yaourt
check_root
check_archlinux
check_pacman_blocked
echo "Type in your username:"
read -p "User: " USER
install_DE
install_communication
install_music
install_internet
install_tools
finish_install
