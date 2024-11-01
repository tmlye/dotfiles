#!/bin/bash
# This script will create a fresh Arch install
# on a partition mounted in $mountpoint

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

mount_boot_partition(){
  print_title "Mount EFI system partition"

  mkdir -p ${MOUNTPOINT}/efi
  mount -t vfat $BOOT_PARTITION ${MOUNTPOINT}/efi
}

install_base_system() {
  print_title "Install base sytem"
  print_info "Using the pacstrap script we install the base system. The base-devel package group will be installed also."
  if ! is_package_installed "arch-install-scripts" ; then
    print_info "Installing arch install scripts"
    package_install "arch-install-scripts"
  fi
  pacstrap -c -i ${MOUNTPOINT} base base-devel
}

configure_hostname(){
  print_title "HOSTNAME - https://wiki.archlinux.org/index.php/HOSTNAME"
  print_info "A host name is a unique name created to identify a machine on a network.Host names are restricted to alphanumeric characters.\nThe hyphen (-) can be used, but a host name cannot start or end with it. Length is restricted to 63 characters."
  read -p "Hostname [ex: archlinux]: " HN
  echo "$HN" > ${MOUNTPOINT}/etc/hostname
  arch_chroot "sed -i '/127.0.0.1/s/$/ '${HN}'/' /etc/hosts"
  arch_chroot "sed -i '/::1/s/$/ '${HN}'/' /etc/hosts"
}

configure_timezone(){
  print_title "TIMEZONE - https://wiki.archlinux.org/index.php/Timezone"
  print_info "In an operating system the time (clock) is determined by four parts: Time value, Time standard, Time Zone, and DST (Daylight Saving Time if applicable)."
  OPTION=n
  while [[ $OPTION != y ]]; do
    settimezone
    read_input_text "Confirm timezone ($ZONE/$SUBZONE)"
  done
  arch_chroot "ln -s /usr/share/zoneinfo/${ZONE}/${SUBZONE} /etc/localtime"
}

configure_locale(){
  print_title "LOCALE - https://wiki.archlinux.org/index.php/Locale"
  print_info "Locales are used in Linux to define which language the user uses. As the locales define the character sets being used as well, setting up the correct locale is especially important if the language contains non-ASCII characters."
  OPTION=n
  while [[ $OPTION != y ]]; do
    setlocale
    read_input_text "Confirm locale ($LOCALE)"
  done
  echo 'LANG="'$LOCALE_UTF8'"' > ${MOUNTPOINT}/etc/locale.conf
  arch_chroot "sed -i '/'${LOCALE}'/s/^#//' /etc/locale.gen"
  arch_chroot "locale-gen"
}

install_linux(){
  print_title "Installing Linux, neovim, microcode etc"

  pacstrap -c -i ${MOUNTPOINT} linux linux-firmware man-db man-pages neovim amd-ucode intel-ucode sbctl btrfs-progs dosfstools efibootmgr
}

configure_mkinitcpio(){
  print_title "Configuring mkinitcpio"

  echo "quiet rw" > ${MOUNTPOINT}/etc/kernel/cmdline
  mkdir -p ${MOUNTPOINT}/efi/EFI/Linux

  # We'll use a systemd based ramdisk
  sed -i "s/HOOKS=\(.*\)/HOOKS=\(base systemd udev block autodetect microcode modconf sd-encrypt filesystems keyboard fsck\)/" ${MOUNTPOINT}/etc/mkinitcpio.conf

  cat << EOF > ${MOUNTPOINT}/etc/mkinitcpio.d/linux.preset
# mkinitcpio preset file to generate UKIs

ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux"
ALL_microcode=(/boot/*-ucode.img)

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
#default_image="/boot/initramfs-linux.img"
default_uki="/efi/EFI/Linux/arch-linux.efi"
default_options="--splash /usr/share/systemd/bootctl/splash-arch.bmp"

#fallback_config="/etc/mkinitcpio.conf"
#fallback_image="/boot/initramfs-linux-fallback.img"
fallback_uki="/efi/EFI/Linux/arch-linux-fallback.efi"
fallback_options="-S autodetect"
EOF

  arch_chroot "mkinitcpio -P"
  arch_chroot "chmod 600 /boot/initramfs-linux*"
  pause_function
}

get_dm_uuid(){
  print_title "Getting LUKS device UUID"
  print_info "Please provide the UUID of the dm-crypt device (dm-0, dm-1, etc.)"
  print_info "You can find this by running: ls -l /dev/disk/by-uuid/"
  print_warning "This is NOT the UUID of the partition, but of the decrypted LUKS device"

  while true; do
    read -p "Enter dm-crypt device UUID: " DM_UUID
    if [[ -z "$DM_UUID" ]]; then
      print_warning "UUID cannot be empty. Please try again."
    else
      read_input_text "Is this UUID correct: $DM_UUID"
      [[ $OPTION == y ]] && break
    fi
  done
}

configure_bootloader(){
  print_title "Configuring Bootloader"
  mkdir -p ${MOUNTPOINT}/efi/loader/entries
  cat << EOF > ${MOUNTPOINT}/efi/loader/loader.conf
default arch.conf
timeout 3
console-mode auto
editor no
EOF

  ROOT_UUID=$(blkid -s UUID -o value $ROOT_PARTITION)
  cat << EOF > ${MOUNTPOINT}/efi/loader/entries/arch.conf
title   Arch Linux
efi     /EFI/Linux/arch-linux.efi
options luks.uuid=$ROOT_UUID luks.name=cryptroot root=UUID=$DM_UUID rw
EOF

  arch_chroot "bootctl install --esp-path=/efi"
  pause_function
}

install_network(){
  print_title "Installing network management"
  arch_chroot "pacman -S systemd-resolvconf networkmanager wpa_supplicant"
  systemctl --root=${MOUNTPOINT} enable wpa_supplicant
  systemctl --root=${MOUNTPOINT} enable NetworkManager
  systemctl --root=${MOUNTPOINT} mask systemd-networkd
  pause_function
}

root_password(){
  print_title "Setting root password"
  print_warning "Enter your new root password"
  arch_chroot passwd
}

setup_dns(){
  print_title "Setting up DNS"
  systemctl --root=${MOUNTPOINT} enable systemd-resolved
  ln -sf /run/systemd/resolve/stub-resolv.conf ${MOUNTPOINT}/etc/resolv.conf
  mkdir ${MOUNTPOINT}/etc/systemd/resolved.conf.d/
  cat << EOF > ${MOUNTPOINT}/etc/systemd/resolved.conf.d/custom.conf
[Resolve]
DNSSEC=allow-downgrade
DNSOverTLS=opportunistic
DNS=1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001
Domains=~.
FallbackDNS=
EOF
  pause_function
}

finish_install(){
  print_title "INSTALL COMPLETED"
  print_info "A setup script will be copied to /root on the new system."
  cp $DIR/setupArch.sh ${MOUNTPOINT}/root/
  cp $DIR/setupEnvironment.sh ${MOUNTPOINT}/root/
  cp $DIR/sharedfuncs ${MOUNTPOINT}/root/

  read_input_text "Unmount partition?"
  if [[ $OPTION == y ]]; then
    umount -R ${MOUNTPOINT}
  fi
  echo "Finished"
}

usage() {
  cat <<EOF
usage: ${0##*/} [options]

  Options:
    -h             Print this help message
    -m             Path to where the root partition is mounted
    -d             The disk, for example /dev/sda
    -b             The boot partition (EFI system partition), for example /dev/sda1
    -p             The root partition, for example /dev/sda2, should match what is mounted at the path given with -m

This script will create a fresh Arch install on a partition mounted
at the mountpoint. It is a wrapper around the AUI Script created by https://github.com/helmuthdu

EOF
}


# Get the directory this script is in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [[ -f $DIR/sharedfuncs ]]; then
  source sharedfuncs
else
  echo "missing file: sharedfuncs"
  exit 1
fi

unset BOOT_PARTITION DISK MOUNTPOINT ROOT_PARTITION

while getopts ":m:d:b:p:h" opt; do
  case $opt in
    b)
      if [[ ! -e $OPTARG ]]; then
        error_msg "ERROR! Boot partition does not exist $OPTARG"
        exit 1
      fi
      BOOT_PARTITION=$OPTARG
      ;;
    d)
      if [[ ! -e $OPTARG ]]; then
        error_msg "ERROR! Disk does not exist $OPTARG"
        exit 1
      fi
      DISK=$OPTARG
      ;;
    h)
      usage
      exit 0
      ;;
    m)
      if [[ ! -d $OPTARG ]]; then
        error_msg "ERROR! Mountpoint does not exist or is not a directory."
        exit 1
      fi
      MOUNTPOINT=$OPTARG
      ;;
    p)
      if [[ ! -e $OPTARG ]]; then
        error_msg "ERROR! Root partition does not exist $OPTARG"
        exit 1
      fi
      ROOT_PARTITION=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ "x" == "x$BOOT_PARTITION" ]; then
  echo "-b [option] is required, specify the boot partition"
  usage
  exit
fi

if [ "x" == "x$DISK" ]; then
  echo "-d [option] is required, specify the disk"
  usage
  exit
fi

if [ "x" == "x$MOUNTPOINT" ]; then
  echo "-m [option] is required, specify the mountpoint"
  usage
  exit
fi

if [ "x" == "x$ROOT_PARTITION" ]; then
  echo "-p [option] is required, specify the root partition"
  usage
  exit
fi

check_root
check_archlinux

print_title "This script makes the following assumptions:"
print_info "- Network is functional\n- There is a valid mirror in /etc/pacman.d/mirrorlist\n- You have formatted a partition and mounted it in ${MOUNTPOINT}\n- You have a separate EFI system partition that is NOT mounted"
read_input_text "Do you want to continue?"

if [[ $OPTION != y ]]; then exit 0; fi

check_boot_system
mount_boot_partition
install_base_system
genfstab -U ${MOUNTPOINT} >> ${MOUNTPOINT}/etc/fstab
echo 'tmpfs		/tmp	tmpfs	nodev,nosuid	0	0' >> ${MOUNTPOINT}/etc/fstab
configure_hostname
configure_timezone
configure_locale
install_linux
configure_mkinitcpio
get_dm_uuid
configure_bootloader
install_network
root_password
setup_dns
finish_install
