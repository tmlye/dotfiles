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
  package_install "zsh wayland sway swaylock swayidle swaybg wl-clipboard xdg-desktop-portal-wlr"
  package_install "xorg-server-xwayland grim slurp gtk3 qt5-wayland alacritty"
  package_install "gnome-keyring libsecret brightnessctl waybar wofi mako libnotify"
  package_install "ttf-font-awesome ttf-dejavu-nerd"
}

install_media(){
  package_install "picard mplayer smplayer mpv flac ffmpeg easyeffects lsp-plugins"
}

install_internet(){
  package_install "firefox chromium flashplugin qbittorrent mtr"
}

install_tools(){
  package_install "util-linux bind-tools calc virtualbox virtualbox-host-modules-arch calibre htop whois nmon duplicity cronie net-tools gnupg"
  # Images
  package_install "imv darktable perl-image-exiftool"
  # Documents
  package_install "texlive-most texlive-bin zathura zathura-pdf-poppler"
}

install_dev(){
  package_install "nvim npm code aws-cli python-boto3 jdk21-openjdk docker docker-compose docker-buildx ruby jq rustup"
  aur_package_install "nvm tfenv"
}

install_power(){
  package_install "powertop acpi acpi_call tpacpi-bat"
  aur_package_install "laptop-mode-tools"
  systemctl enable laptop-mode.service
  systemctl mask systemd-rfkill.service
  systemctl mask systemd-rfkill.socket
}

setup_network(){
  systemctl enable systemd-resolved.service
  mkdir /etc/systemd/resolved.conf.d/
  cat << EOF > /etc/systemd/resolved.conf.d/custom.conf
[Resolve]
DNSSEC=yes
DNSOverTLS=opportunistic
EOF
  cat << EOF > /etc/resolv.conf
nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 2606:4700:4700::1111
nameserver 2606:4700:4700::1001
EOF
}

finish_install(){
  print_title "Finishing Installation"

  sudo -u $USER mkdir /home/$USER/mount
  sudo -u $USER mkdir /home/$USER/mount2

  sudo -u $USER git clone https://github.com/tmlye/dotfiles.git /home/$USER/.dotfiles
  sudo -u $USER ./.dotfiles/createSymlinks.sh
  is_package_installed "zsh" && sudo -u $USER chsh -s /bin/zsh

  systemctl enable fstrim.timer

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
install_media
install_internet
install_tools
install_dev
install_power
setup_network
finish_install
