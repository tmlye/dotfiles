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

configure_mirrorlist(){
  local countries_code=("AU" "BY" "BE" "BR" "BG" "CA" "CL" "CN" "CO" "CZ" "DK" "EE" "FI" "FR" "DE" "GR" "HK" "HU" "IN" "IE" "IL" "IT" "JP" "KZ" "KR" "LV" "LU" "MK" "NL" "NC" "NZ" "NO" "PL" "PT" "RO" "RU" "RS" "SG" "SK" "ZA" "ES" "LK" "SE" "CH" "TW" "TR" "UA" "GB" "US" "UZ" "VN")
  local countries_name=("Australia" "Belarus" "Belgium" "Brazil" "Bulgaria" "Canada" "Chile" "China" "Colombia" "Czech Republic" "Denmark" "Estonia" "Finland" "France" "Germany" "Greece" "Hong Kong" "Hungary" "India" "Ireland" "Israel" "Italy" "Japan" "Kazakhstan" "Korea" "Latvia" "Luxembourg" "Macedonia" "Netherlands" "New Caledonia" "New Zealand" "Norway" "Poland" "Portugal" "Romania" "Russian" "Serbia" "Singapore" "Slovakia" "South Africa" "Spain" "Sri Lanka" "Sweden" "Switzerland" "Taiwan" "Turkey" "Ukraine" "United Kingdom" "United States" "Uzbekistan" "Viet Nam")
  country_list(){
    #`reflector --list-countries | sed 's/[0-9]//g' | sed 's/^/"/g' | sed 's/,.*//g' | sed 's/ *$//g'  | sed 's/$/"/g' | sed -e :a -e '$!N; s/\n/ /; ta'`
    PS3="$prompt1"
    echo "Select your country:"
    select OPT in "${countries_name[@]}"; do
      if contains_element "$OPT" "${countries_name[@]}"; then
        country=${countries_code[$(( $REPLY - 1 ))]}
        break
      else
        invalid_option
      fi
    done
  }
  print_title "MIRRORLIST - https://wiki.archlinux.org/index.php/Mirrors"
  print_info "This option is a guide to selecting and configuring your mirrors, and a listing of current available mirrors."
  OPTION=n
  while [[ $OPTION != y ]]; do
    country_list
    read_input_text "Confirm country: $OPT"
  done

  url="https://www.archlinux.org/mirrorlist/?country=${country}&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"

  tmpfile=$(mktemp --suffix=-mirrorlist)

  # Get latest mirror list and save to tmpfile
  curl -so ${tmpfile} ${url}
  sed -i 's/^#Server/Server/g' ${tmpfile}

  # Backup and replace current mirrorlist file (if new file is non-zero)
  if [[ -s ${tmpfile} ]]; then
   { echo " Backing up the original mirrorlist..."
     mv -i /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig; } &&
   { echo " Rotating the new list into place..."
     mv -i ${tmpfile} /etc/pacman.d/mirrorlist; }
  else
    echo " Unable to update, could not download list."
  fi
  # allow global read access (required for non-root yaourt execution)
  chmod +r /etc/pacman.d/mirrorlist
  $EDITOR /etc/pacman.d/mirrorlist
}

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
  print_title "Installing Linux, vim"

  pacstrap -c -i ${MOUNTPOINT} linux linux-firmware man-db man-pages vim
}

install_bootloader(){
  print_title "Installing GRUB"
  pacstrap -c -i ${MOUNTPOINT} grub dosfstools efibootmgr
}

configure_mkinitcpio(){
  print_title "Configuring mkinitcpio"

  # Create a keyfile to avoid entering password twice on boot
  dd bs=512 count=4 if=/dev/random of=${MOUNTPOINT}/root/keyfile.bin iflag=fullblock
  arch_chroot "chmod 600 /root/keyfile.bin"
  sed -i "s/FILES=.*/FILES=(\/root\/keyfile.bin)/" ${MOUNTPOINT}/etc/mkinitcpio.conf

  # Move block to right after udev in HOOKS array
  # This makes it possible to boot from usb devices
  sed -i "s/block//" ${MOUNTPOINT}/etc/mkinitcpio.conf
  sed -i "s/udev/udev block/" ${MOUNTPOINT}/etc/mkinitcpio.conf
  # Add encrypt for LUKS support
  sed -i "s/filesystems/encrypt filesystems/" ${MOUNTPOINT}/etc/mkinitcpio.conf
  arch_chroot "mkinitcpio -p linux"
  arch_chroot "chmod 600 /boot/initramfs-linux*"
  pause_function
}

configure_bootloader(){
  print_title "Configuring GRUB"

  # Grub only supports pbkdf2 and sha256
  cryptsetup -v luksAddKey --pbkdf pbkdf2 --hash sha256 $ROOT_PARTITION ${MOUNTPOINT}/root/keyfile.bin

  ROOT_UUID=$(blkid -s UUID -o value $ROOT_PARTITION)

  sed -i "s/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=$ROOT_UUID\:cryptroot cryptkey=rootfs\:\/root\/keyfile.bin\"/" ${MOUNTPOINT}/etc/default/grub
  sed -i "s/#GRUB_ENABLE_CRYPTODISK=y/GRUB_ENABLE_CRYPTODISK=y/" ${MOUNTPOINT}/etc/default/grub
  sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet\"/" ${MOUNTPOINT}/etc/default/grub

  curl https://gist.githubusercontent.com/tmlye/a682d07e40ad9b5d7237bd46f4f72e60/raw > ${MOUNTPOINT}/etc/grub.d/31_hold_shift
  chmod +x ${MOUNTPOINT}/etc/grub.d/31_hold_shift
  arch_chroot "grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=arch_grub --boot-directory=/efi --removable --recheck --modules=\"part_gpt part_msdos\""
  arch_chroot "grub-mkconfig -o /efi/grub/grub.cfg"
  pause_function
}

install_network(){
  print_title "Installing network management"
  arch_chroot "pacman -S systemd-resolvconf netctl dhcpcd ca-certificates wpa_supplicant dialog openvpn"
  pause_function
}

root_password(){
  print_title "Setting root password"
  print_warning "Enter your new root password"
  arch_chroot passwd
}

setup_dns(){
  print_title "Setting up DNS"
  arch_chroot systemctl enable systemd-resolved.service
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
install_bootloader
configure_bootloader
install_network
root_password
setup_dns
finish_install
