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
    sudo -u $USER makepkg -fsri
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
  package_install "mesa vulkan-radeon libva-mesa-driver mesa-vdpau"
  package_install "zsh wayland sway swaylock swayidle swaybg wl-clipboard xdg-desktop-portal-wlr"
  package_install "xorg-server-xwayland grim slurp gtk3 qt5-wayland alacritty qmk syncthing"
  package_install "libsecret gcr-4 brightnessctl waybar wofi mako libnotify"
  package_install "ttf-dejavu ttf-dejavu-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-font-awesome"
  systemctl enable --now bluetooth.service
  aur_package_install "logiops"
}

install_media(){
  package_install "picard mplayer smplayer mpv flac ffmpeg easyeffects lsp-plugins pavucontrol"
}

install_internet(){
  package_install "firefox qbittorrent mtr"
  aur_package_install "ungoogled-chromium-bin chromium-extension-web-store chromium-widevine"
}

install_tools(){
  package_install "util-linux bind-tools calc virtualbox calibre htop whois nmon duplicity cronie net-tools gnupg"
  package_remove "virtualbox-host-dkms"
  package_install "virtualbox-host-modules-arch"
  # Images
  package_install "imv darktable perl-image-exiftool"
  # Documents
  package_install "texlive-basic texlive-latex texlive-latexrecommended texlive-latexextra zathura zathura-pdf-poppler"
}

install_dev(){
  package_install "neovim npm code python-boto3 jdk21-openjdk docker docker-compose docker-buildx ruby jq rustup go"
  package_install "kubectl k9s helm pyenv postgresql gnu-netcat direnv"
  aur_package_install "nvm tfenv aws-cli-v2-bin"
  sudo -u $USER rustup default stable
  sudo -u $USER helm repo update
  sudo -u $USER pyenv global system
}

install_power(){
  package_install "powertop tlp ethtool acpi acpi_call"
  aur_package_install "tpacpi-bat"
  systemctl enable tlp.service
  systemctl mask systemd-rfkill.service
  systemctl mask systemd-rfkill.socket
}

finish_install(){
  print_title "Finishing Installation"

  sudo -u $USER mkdir /home/$USER/mount
  sudo -u $USER mkdir /home/$USER/mount2

  sudo -u $USER touch ~/.secrets

  sudo -u $USER git clone https://github.com/tmlye/dotfiles.git /home/$USER/.dotfiles
  sudo -u $USER ./.dotfiles/createSymlinks.sh
  is_package_installed "zsh" && sudo -u $USER chsh -s /bin/zsh

  systemctl enable fstrim.timer

  cp /home/$USER/.dotfiles/various/logid.cfg /etc/logid.cfg
  systemctl enable --now logid.service

  pause_function
}

export AUR_PKG_MANAGER=pikaur
check_root
check_archlinux
check_pacman_blocked
echo "Type in your username:"
read -p "User: " USER
system_update
install_pikaur
install_desktop_environment
install_media
install_internet
install_tools
install_dev
install_power
finish_install
