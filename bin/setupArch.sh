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

setup_network(){
  print_title "Network setup"
  system_ctl stop netctl netcfg dhcpcd networkmanager network
  system_ctl disable netctl netcfg dhcpcd networkmanager network
  system_ctl start wicd
  system_ctl enable wicd
  wicd-curses
}

root_password(){
  print_title "ROOT PASSWORD"
  print_warning "Enter your new root password"
  passwd
}

configure_sudo(){
  if ! is_package_installed "sudo" ; then
    print_title "SUDO - https://wiki.archlinux.org/index.php/Sudo"
    package_install "sudo"
  fi
  #CONFIGURE SUDOERS {{{
  if [[ ! -f  /etc/sudoers.aui ]]; then
    cp -v /etc/sudoers /etc/sudoers.aui
    ## Uncomment to allow members of group wheel to execute any command
    sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers
    ## Same thing without a password (not secure)
    #sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//' /etc/sudoers

    #This config is especially helpful for those using terminal multiplexers like screen, tmux, or ratpoison, and those using sudo from scripts/cronjobs:
    echo "" >> /etc/sudoers
    echo 'Defaults !requiretty, !tty_tickets, !umask' >> /etc/sudoers
    echo 'Defaults visiblepw, path_info, insults, lecture=always' >> /etc/sudoers
    echo 'Defaults loglinelen=0, logfile =/var/log/sudo.log, log_year, log_host, syslog=auth' >> /etc/sudoers
    echo 'Defaults passwd_tries=3, passwd_timeout=1' >> /etc/sudoers
    echo 'Defaults env_reset, always_set_home, set_home, set_logname' >> /etc/sudoers
    echo 'Defaults !env_editor, editor="/usr/bin/vim:/usr/bin/vi:/usr/bin/nano"' >> /etc/sudoers
    echo 'Defaults timestamp_timeout=300' >> /etc/sudoers
    echo 'Defaults passprompt="[sudo] password for %u: "' >> /etc/sudoers
  fi
  #}}}
}

create_new_user(){
  read -p "Username: " USER_NAME
  useradd -m -g users -G wheel -s /bin/bash ${USER_NAME}
  chfn ${USER_NAME}
  passwd ${USER_NAME}
}

install_yaourt(){
  print_title "Installing Yaourt"
  if ! is_package_installed "yaourt" ; then
    package_install "base-devel yajl namcap"
    pacman -D --asdeps yajl namcap
    aui_download_packages "package-query yaourt"
    pacman -D --asdeps package-query
    if ! is_package_installed "yaourt" ; then
      echo "Yaourt not installed. EXIT now"
      pause_function
      exit 0
    fi
  fi
  AUR_PKG_MANAGER="yaourt"
  pause_function
}

enable_multilib(){
  print_title "Enabling Multilib"
  local MULTILIB=`grep -n "\[multilib\]" /etc/pacman.conf | cut -f1 -d:`
  if [[ -z $MULTILIB ]]; then
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
    echo -e '\nMultilib repository added into pacman.conf file'
  else
    sed -i "${MULTILIB}s/^#//" /etc/pacman.conf
    local MULTILIB=$(( $MULTILIB + 1 ))
    sed -i "${MULTILIB}s/^#//" /etc/pacman.conf
  fi
  pause_function
}

install_basic_setup(){
  print_title "Installing basic tools"
  package_install "rsync mlocate ranger gvim git openssh"
  print_info "Installing NTPd"
  package_install "ntp"
  is_package_installed "ntp" && timedatectl set-ntp true
  print_info "Installing compression tools"
  package_install "zip unzip unrar"
  print_info "Installing ALSA"
  package_install "alsa-utils alsa-plugins lib32-alsa-plugins"
  print_info "Installing filesystems+tools"
  package_install "ntfs-3g dosfstools exfat-utils fuse fuse-exfat"
  is_package_installed "fuse" && add_module "fuse"
}

install_tlp(){
  print_title "Installing TLP"
  aur_package_install "tlp tlp-rdw acpi_call-git"
  package_install "tp_smapi"
  system_ctl start tlp tlp-sleep.service
  system_ctl enable tlp tlp-sleep.service
  pause_function
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
setup_network
check_connection
system_upgrade
root_password
configure_sudo
create_new_user
install_yaourt
enable_multilib
install_basic_setup
install_tlp
finish_install
