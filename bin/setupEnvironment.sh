#!/bin/bash
# This script sets up the desktop environment and installs many programs I use.

if [[ -f `pwd`/sharedfuncs ]]; then
  source sharedfuncs
else
  echo "missing file: sharedfuncs"
  exit 1
fi

install_DE(){
  package_install "xorg-server xorg-apps xorg-xinit xf86-video-vesa xautolock slock awesome zsh rxvt-unicode slim ttf-dejavu gtk-engine-murrine xclip"
  aur_package_install "allblack-icons xcmenu-git"
}

install_communication(){
  package_install "irssi mairix"
  aur_package_install "mutt-sidebar muttvcardsearch archivemail"
}

install_music(){
  package_install "mpd ncmpcpp picard mplayer"
}

install_internet(){
  package_install "firefox chromium flashplugin rtorrent pptpclient unbound dnscrypt-proxy"
  aur_package_install "google-talkplugin"
}

install_tools(){
  package_install "calc virtualbox calibre viewnior zathura zathura-pdf-poppler htop scrot whois dnsutils"
}

install_dev(){
  package_install "nodejs"
}

install_cloud(){
    aur_package_install "seafile-client seafile-client-cli"
}

install_power(){
  aur_package_install "tpacpi-bat"
  package_install "powertop acpi_call"
}

finish_install(){
  print_title "Finishing Installation"
  sudo -u $USER git clone https://github.com/tmlye/dotfiles.git /home/$USER/.dotfiles
  is_package_installed "zsh" && sudo -u $USER chsh -s /bin/zsh
  sudo -u $USER ./.dotfiles/createSymlinks.sh
  sudo -u $USER mkdir /home/$USER/mount
  sudo -u $USER mkdir /home/$USER/mount2
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
  truecrypt --text --mount $DEVICE /home/$USER/mount/
  sudo -u $USER cp -r /home/$USER/mount/backup/code /home/$USER/
  sudo -u $USER cp -r /home/$USER/mount/backup/desktop /home/$USER/
  sudo -u $USER cp -r /home/$USER/mount/backup/downloads /home/$USER/
  cp -f /home/$USER/mount/backup/OS/slim.conf /etc/
  mkdir -p /usr/share/slim/themes
  cp -r /home/$USER/mount/backup/OS/slim/simple /usr/share/slim/themes/
  sudo -u $USER cp -r /home/$USER/mount/backup/OS/home/.* /home/$USER/
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
install_dev
install_power
install_cloud
finish_install
