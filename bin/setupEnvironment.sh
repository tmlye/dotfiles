#!/bin/bash
# This script sets up the desktop environment and installs many programs I use.

if [[ -f `pwd`/sharedfuncs ]]; then
  source sharedfuncs
else
  echo "missing file: sharedfuncs"
  exit 1
fi

install_pikaur(){
  print_title "Installing pikaur"
  if ! is_package_installed "pikaur" ; then
    package_install "base-devel git"
    sudo -u $USER git clone https://aur.archlinux.org/pikaur.git
    cd pikaur
    sudo -u $USER makepkg -fsr
    pacman -U *.pkg.tar.xz
    cd ..
    rm -rf pikaur
    if ! is_package_installed "pikaur" ; then
      echo "Pikaur not installed. EXIT now"
      pause_function
      exit 0
    fi
  fi
  pause_function
}

install_desktop_environment(){
  package_install "mesa xf86-video-amdgpu vulkan-radeon libva-mesa-driver"
  package_install "zsh rxvt-unicode wayland sway swaylock swayidle swaybg xorg-server-xwayland grim slurp ttf-dejavu gtk3"
}

install_communication(){
  package_install "neomutt offlineimap mairix gnupg keybase"
  aur_package_install "muttvcardsearch archivemail"
}

install_music(){
  package_install "mpd ncmpcpp picard mplayer smplayer flac ffmpeg"
}

install_internet(){
  package_install "firefox chromium flashplugin rtorrent mtr"
}

install_tools(){
  package_install "util-linux bind-tools calc virtualbox calibre htop whois nmon duplicity"
  # Images
  package_install "viewnior darktable perl-image-exiftool"
  # Documents
  package_install "texlive-most texlive-bin zathura zathura-pdf-poppler"
}

install_dev(){
  package_install "npm code terraform hugo aws-cli python-boto3 jdk11-openjdk kotlin docker docker-compose ruby"
  aur_package_install "nvm"
}

install_power(){
  package_install "powertop acpi acpi_call tpacpi-bat"
}

finish_install(){
  print_title "Finishing Installation"

  sudo -u $USER mkdir /home/$USER/mount
  sudo -u $USER mkdir /home/$USER/mount2

  sudo -u $USER git clone https://github.com/tmlye/dotfiles.git /home/$USER/.dotfiles
  sudo -u $USER ./.dotfiles/createSymlinks.sh
  is_package_installed "zsh" && sudo -u $USER chsh -s /bin/zsh

  pause_function
}

export AUR_PKG_MANAGER=pikaur
check_root
check_archlinux
check_pacman_blocked
echo "Type in your username:"
read -p "User: " USER
install_pikaur
install_desktop_environment
install_communication
install_music
install_internet
install_tools
install_dev
install_power
finish_install
