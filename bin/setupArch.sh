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
  print_warning "You need to have your network connection setup. Check if systemd-resolved, NetworkManager and wpa_supplicant are running."
  print_warning "Use nmcli d wifi list and nmcli --ask dev wifi connect <ssid>"
  read_input_text "Is your network setup?"
  if [[ $OPTION != y ]]; then exit 0; fi
}

ask_secureboot(){
  print_title "Secure Boot Setup"
  read_input_text "Would you like to set up Secure Boot?"
  if [[ $OPTION == y ]]; then
    check_secureboot_setup
    setup_secureboot
  else
    print_warning "Skipping Secure Boot setup"
  fi
}

ask_tpm(){
  print_title "TPM2 for disk decryption"
  read_input_text "Would you like to set up TPM2 for disk decryption?"
  if [[ $OPTION == y ]]; then
    configure_tpm_encryption
  else
    print_warning "Skipping TPM2 configuration"
  fi
}

check_secureboot_setup(){
  print_title "Checking Secure Boot Setup Mode"
  if ! command -v sbctl &> /dev/null; then
    print_warning "sbctl is not installed. Installing it now..."
    package_install "sbctl"
  fi

  if ! sbctl status | grep "Setup Mode" | grep -q "Enabled"; then
    print_error "Secure Boot Setup Mode is not enabled!"
    print_warning "Please enable Secure Boot Setup Mode in your UEFI settings and try again."
    print_warning "This is required to enroll your own Secure Boot keys."
    exit 1
  fi

  print_info "Secure Boot Setup Mode is enabled"
  pause_function
}

setup_secureboot(){
  print_title "Setting up Secure Boot"

  print_info "Creating secure boot keys..."
  sbctl create-keys

  print_info "Enrolling keys into firmware..."
  print_warning "You might have to run chattr -i on some keys, pay attention to the output"
  sbctl enroll-keys -m

  if ! sbctl verify; then
    print_error "Secure boot keys verification failed!"
    print_warning "There might be an issue with the key enrollment."
    read_input_text "Do you want to continue anyway?"
    if [[ $OPTION != y ]]; then exit 1; fi
  else
    print_info "Secure boot keys were successfully enrolled"
  fi

  sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi
  sbctl sign -s /efi/EFI/BOOT/BOOTX64.EFI
  sbctl sign -s /efi/EFI/Linux/arch-linux.efi
  sbctl sign -s /efi/EFI/Linux/arch-linux-fallback.efi

  pause_function
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
  package_install "ntfs-3g exfat-utils fuse2 fuse3 mtpfs"
}

finish_install(){
  print_title "Installation complete"
  print_info "A script called setupEnvironment was copied to your home folder.\n Login with your user and execute it to continue."
  mv setupEnvironment.sh /home/${USER_NAME}/
  mv sharedfuncs /home/${USER_NAME}/
  rm setupArch.sh_error.log
  rm setupArch.sh
}

configure_tpm_encryption(){
  print_title "Configuring TPM2 + PIN disk encryption"

  package_install tpm2-tss

  if ! command -v tpm2_getcap &> /dev/null; then
    print_warning "tpm2-tools not installed. Installing required packages..."
    package_install "tpm2-tools"
  fi

  if ! tpm2_getcap properties-fixed 2>/dev/null | grep -q "TPM2_PT_MANUFACTURER"; then
    print_error "No TPM2 device found or not accessible!"
    print_warning "Make sure TPM2 is enabled in UEFI settings."
    read_input_text "Do you want to continue without TPM2 configuration?"
    if [[ $OPTION != y ]]; then exit 1; fi
  fi

  root_part=$(findmnt -n -o SOURCE /)
  if [[ $root_part == /dev/mapper/* ]]; then
    crypt_dev=$(dmsetup deps -o devname "$root_part" | sed -n 's/.*(\(.*\))/\/dev\/\1/p')
    if [[ -n $crypt_dev ]]; then
      print_info "Found encrypted device: $crypt_dev"

      print_info "Enrolling TPM2 with PIN for disk encryption..."
      systemd-cryptenroll --tpm2-device=auto --tpm2-with-pin=yes "$crypt_dev"

      ROOT_UUID=$(blkid -s UUID -o value $crypt_dev)
      echo "root  UUID=$ROOT_UUID  none  discard,tpm2-device=auto" > /etc/crypttab.initramfs

      mkinitcpio -P

#      if ! grep -q "tpm2-device=auto" /etc/crypttab; then
#        print_info "Updating /etc/crypttab with TPM2 configuration..."
#        uuid=$(blkid -s UUID -o value "$crypt_dev")
#        sed -i "s|UUID=$uuid.*|UUID=$uuid - none tpm2-device=auto,tpm2-with-pin=yes|" /etc/crypttab
#      fi

      print_info "TPM2 + PIN enrollment complete"
    else
      print_error "Could not find encrypted device!"
    fi
  else
    print_warning "No encrypted root partition found. Skipping TPM2 configuration."
  fi

  pause_function
}

check_root
check_archlinux
check_hostname
check_pacman_blocked
check_network
ask_secureboot
check_connection
system_upgrade
#ask_tpm
configure_sudo
create_new_user
configure_pacman
install_basic_setup
finish_install
