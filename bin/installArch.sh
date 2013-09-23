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
  local countries_code=("AU" "BY" "BE" "BR" "BG" "CA" "CL" "CN" "CO" "CZ" "DK" "EE" "FI" "FR" "DE" "GR" "HU" "IN" "IE" "IL" "IT" "JP" "KZ" "KR" "LV" "LU" "MK" "NL" "NC" "NZ" "NO" "PL" "PT" "RO" "RU" "RS" "SG" "SK" "ZA" "ES" "LK" "SE" "CH" "TW" "TR" "UA" "GB" "US" "UZ" "VN")
  local countries_name=("Australia" "Belarus" "Belgium" "Brazil" "Bulgaria" "Canada" "Chile" "China" "Colombia" "Czech Republic" "Denmark" "Estonia" "Finland" "France" "Germany" "Greece" "Hungary" "India" "Ireland" "Israel" "Italy" "Japan" "Kazakhstan" "Korea" "Latvia" "Luxembourg" "Macedonia" "Netherlands" "New Caledonia" "New Zealand" "Norway" "Poland" "Portugal" "Romania" "Russian" "Serbia" "Singapore" "Slovakia" "South Africa" "Spain" "Sri Lanka" "Sweden" "Switzerland" "Taiwan" "Turkey" "Ukraine" "United Kingdom" "United States" "Uzbekistan" "Viet Nam")
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

  url="https://www.archlinux.org/mirrorlist/?country=${country}&use_mirror_status=on"

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

install_base_system() {
  print_title "Install base sytem"
  print_info "Using the pacstrap script we install the base system. The base-devel package group will be installed also."
  if ! is_package_installed "arch-install-scripts" ; then
      print_info "Installing arch install scripts"
      package_install "arch-install-scripts"
  fi
  mkdir -p ${MOUNTPOINT}/var/lib/pacman
  pacman -Sy -r ${MOUNTPOINT}
  mkdir -p ${MOUNTPOINT}/var/cache/pacman/pkg
  pacman -Su base --noconfirm --cachedir ${MOUNTPOINT}/var/cache/pacman/pkg -r ${MOUNTPOINT}
}

configure_hostname(){
  print_title "HOSTNAME - https://wiki.archlinux.org/index.php/HOSTNAME"
  print_info "A host name is a unique name created to identify a machine on a network.Host names are restricted to alphanumeric characters.\nThe hyphen (-) can be used, but a host name cannot start or end with it. Length is restricted to 63 characters."
  read -p "Hostname [ex: archlinux]: " HN
  echo "$HN" > $MOUNTPOINT/etc/hostname
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
  echo 'LANG="'$LOCALE_UTF8'"' > $MOUNTPOINT/etc/locale.conf
  arch_chroot "sed -i '/'${LOCALE}'/s/^#//' /etc/locale.gen"
  arch_chroot "locale-gen"
}

generate_ramdisk(){
  print_title "Generating initial ramdisk"
  # Move block to right after udev in HOOKS array
  # This makes it possible to boot from usb devices
  sed -i "s/block//" ${MOUNTPOINT}/etc/mkinitcpio.conf
  sed -i "s/udev/udev block/" ${MOUNTPOINT}/etc/mkinitcpio.conf
  arch_chroot "mkinitcpio -p linux"
}

install_bootloader(){
  print_title "Installing GRUB"
  if [[ $UEFI -eq 1 ]]; then
    pacstrap $MOUNTPOINT grub dosfstools efibootmgr
  else
    pacstrap $MOUNTPOINT grub
  fi
}

configure_bootloader(){
  print_title "Configuring GRUB"
  partitions=(`cat /proc/partitions | awk 'length($3)>1' | awk '{print "/dev/" $4}' | awk 'length($0)>8' | grep 'sd\|hd'`)

  echo "Select the partition:"
  select DEVICE in "${partitions[@]}"; do
   #get the selected number - 1
   DEVICE_NUMBER=$(( $REPLY - 1 ))
   if contains_element "$DEVICE" "${partitions[@]}"; then
      BOOT_DEVICE=`echo $DEVICE | sed 's/[0-9]//'`
      break
   else
     invalid_option
   fi
  done

  arch_chroot "modprobe dm-mod"
  if [[ $UEFI -eq 1 ]]; then
    echo "Configuring for UEFI"
    arch_chroot "mkdir -p /boot/efi"
    # TODO Check if this works
    arch_chroot "mount -t vfat $DEVICE /boot/efi"
    arch_chroot "grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck"
  else
    arch_chroot "grub-install --recheck ${BOOT_DEVICE}"
  fi
  arch_chroot "grub-mkconfig -o /boot/grub/grub.cfg"
}

install_network(){
  print_title "Installing wicd for network management"
  arch_chroot "pacman -S wicd ca-certificates"
  pause_function
}

finish_install(){
  print_title "INSTALL COMPLETED"
  print_info "A setup script will be copied to /root on the new system."
  cp `pwd`/setupArch.sh ${MOUNTPOINT}/root/
  cp `pwd`/setupEnvironment.sh ${MOUNTPOINT}/root/
  cp `pwd`/sharedfuncs ${MOUNTPOINT}/root/

  read_input_text "Unmount partition?"
  if [[ $OPTION == y ]]; then
    umount ${MOUNTPOINT}
  fi
  echo "Finished"
}


usage() {
  cat <<EOF
usage: ${0##*/} [options] /path/to/mountpoint

  Options:
    -h             Print this help message

This script will create a fresh Arch install on a partition mounted
at mountpoint. It is a wrapper around the AUI Script created by https://github.com/helmuthdu
Most of the credit goes to him.

EOF
}

if [[ -z $1 || $1 = @(-h|--help) ]]; then
  usage
  exit $(( $# ? 0 : 1 ))
fi

if [[ -f `pwd`/sharedfuncs ]]; then
  source sharedfuncs
else
  echo "missing file: sharedfuncs"
  exit 1
fi

if [[ ! -d $1 ]]; then
    error_msg "ERROR! Mountpoint does not exist or is not a directory."
fi

MOUNTPOINT=$1
check_root
check_archlinux

print_title "This script makes the following assumptions:"
print_info "- Network is functional\n- There is a valid mirror in /etc/pacman.d/mirrorlist\n- You have formatted a partition and mounted it in $MOUNTPOINT"
read_input_text "Do you want to continue?"

if [[ $OPTION != y ]]; then exit 0; fi

check_boot_system
system_update
configure_mirrorlist
install_base_system
# TODO: check why tempfs is not added to fstab
genfstab -U ${MOUNTPOINT} >> ${MOUNTPOINT}/etc/fstab
configure_hostname
configure_timezone
configure_locale
generate_ramdisk
install_bootloader
configure_bootloader
install_network
finish_install


# TODO: Clean up below

#chroot ${new_arch} /bin/bash pacman-key --init
#chroot ${new_arch} /bin/bash pacman-key --populate archlinux
#chroot ${new_arch} /bin/bash pacman-key --refresh-keys

# TODO change SigLevel to Never before??
#pacman --root ${mountpoint} -S base-devel vim grub wicd

# Add / and tmpfs to fstab
#echo 'tmpfs		/tmp	tmpfs	nodev,nosuid	0	0' >> ${new_arch}/etc/fstab
#echo 'UUID=$uuid / ext4 defaults 0 1' >> ${new_arch}/etc/fstab

# Install grub
# chroot ${new_arch} /bin/bash grub-install $partition
# chroot ${new_arch} /bin/bash grub-mkconfig -o /boot/grub/grub.cfg

# Cleanup
# umount ${new_arch}/{proc,sys,dev}
# umount ${new_arch}
