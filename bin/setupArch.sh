#!/bin/bash
# This script will walk you through setting up a new system.

# CREDIT
# A lot of the functions are copied from https://github.com/helmuthdu/aui

# LICENSE
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.

if [[ -f `pwd`/sharedfuncs ]]; then
  source sharedfuncs
else
  echo "missing file: sharedfuncs"
  exit 1
fi

check_network(){
  print_title "Network setup"
  print_warning "You need to have your network connection setup. Netctl should be setup by this point."
  read_input_text "Is your network setup?"
  if [[ $OPTION != y ]]; then exit 0; fi
}

configure_sudo(){
  if ! is_package_installed "sudo" ; then
    print_title "SUDO - https://wiki.archlinux.org/index.php/Sudo"
    package_install "sudo"
  fi

  echo "" >> /etc/sudoers
  echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
  echo 'Defaults !requiretty, !tty_tickets, !umask' >> /etc/sudoers
  echo 'Defaults visiblepw, path_info, insults, lecture=always' >> /etc/sudoers
  echo 'Defaults loglinelen=0, logfile =/var/log/sudo.log, log_year, log_host, syslog=auth' >> /etc/sudoers
  echo 'Defaults passwd_tries=3, passwd_timeout=1' >> /etc/sudoers
  echo 'Defaults env_reset, always_set_home, set_home, set_logname' >> /etc/sudoers
  echo 'Defaults !env_editor, editor="/usr/bin/vim:/usr/bin/vi:/usr/bin/nano"' >> /etc/sudoers
  echo 'Defaults timestamp_timeout=300' >> /etc/sudoers
  echo 'Defaults passprompt="[sudo] password for %u: "' >> /etc/sudoers
}

create_new_user(){
  read -p "Username for new user: " USER_NAME
  useradd -m -g users -G wheel -s /bin/bash ${USER_NAME}
  chfn ${USER_NAME}
  passwd ${USER_NAME}
}

configure_pacman(){
  print_title "Configuring Pacman"
  local MULTILIB=`grep -n "\[multilib\]" /etc/pacman.conf | cut -f1 -d:`
  if [[ -z $MULTILIB ]]; then
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
    echo -e '\nMultilib repository added into pacman.conf file'
  else
    sed -i "${MULTILIB}s/^#//" /etc/pacman.conf
    local MULTILIB=$(( $MULTILIB + 1 ))
    sed -i "${MULTILIB}s/^#//" /etc/pacman.conf
  fi
  package_install "pacman-contrib reflector"
  systemctl enable --now paccache.timer
  pause_function
}

install_basic_setup(){
  print_info "Enabling timesyncd"
  system_ctl enable systemd-timesyncd.service
  print_title "Installing basic tools"
  package_install "efivar gptfdisk rsync mlocate ranger w3m openssh wget traceroute bluez bluez-libs bluez-utils arch-install-scripts"
  print_info "Installing compression tools"
  package_install "zip unzip unrar"
  print_info "Installing audio"
  package_install "alsa-utils alsa-plugins pipewire pipewire-audio pipewire-alsa pipewire-pulse wireplumber"
  print_info "Installing filesystems+tools"
  package_install "ntfs-3g dosfstools exfat-utils fuse2 fuse3 mtpfs"
}

finish_install(){
  print_title "Installation complete"
  print_info "A script called setupEnvironment was copied to your home folder.\n Login with your user and execute it to continue."
  mv setupEnvironment.sh /home/${USER_NAME}/
  mv sharedfuncs /home/${USER_NAME}/
  rm setupArch.sh_error.log
  rm setupArch.sh
}

check_root
check_archlinux
check_hostname
check_pacman_blocked
check_network
check_connection
system_upgrade
configure_sudo
create_new_user
configure_pacman
install_basic_setup
finish_install
