# Keyboard
# ========

alias de='test -f ~/.XkeymapDE && xkbcomp -w 0 ~/.XkeymapDE $DISPLAY'
alias us='test -f ~/.XkeymapUS && xkbcomp -w 0 ~/.XkeymapUS $DISPLAY'

# External Screens
# ================

alias hdmi='xrandr --output HDMI1 --auto --left-of eDP1'
alias pres='xrandr --fb 1366x768 --output DP2 --mode 1024x768 --panning 1366x0'
alias mon='xrandr --output DP2 --mode 1680x1050 --left-of eDP1'

# Package Management
# ==================

alias update='yaourt -Syua --noconfirm'
alias install='yaourt -S'
alias uninstall='yaourt -Rns'
alias search='yaourt -Ss'

# Mounting/Unmounting
# ===================

function newmount() # mount function because alias does not accept parameters
{
    sudo mount -o umask=000 $1 $2
}

alias sm='newmount'
alias smb='newmount /dev/sdb1 $HOME/mount2'
alias smc='newmount /dev/sdc1 $HOME/mount2'
alias smd='newmount /dev/sdd1 $HOME/mount2'

function newumount()
{
    sudo umount $1
}

alias um='newumount'
alias umm='newumount $HOME/mount'
alias um2='newumount $HOME/mount2'

alias msd='sudo mount /dev/mmcblk0p1 $HOME/mount2'
alias musb='sudo mount -U 340CFEF3116F2F5A $HOME/mount2'
alias msa='sudo mount -U 66a9777d-0d9e-4f18-8a31-09cd2efa4790 .msata'

# Cryptsetup
# ==========

alias me='sudo cryptsetup --type luks open `sudo fdisk -l | grep -A 3 "^Disk identifier: 0xbf40ec14" | grep -o "/dev/sd[a-z]1"` extern && sudo mount -t ext4 /dev/mapper/extern $HOME/mount'
alias dmnt='sudo umount $HOME/mount; sudo cryptsetup close extern'

# Power
# =====

alias shu='systemctl poweroff'
alias re='sudo reboot'

# SSH
# ===

alias pi='ssh pi -p 783'
alias web='ssh web01 -p 799'

# Various
# =======

alias c='clear'
alias ps='ps -a -c -o pid,command -x'
alias v='gvim'
alias ls='ls --color=auto'

function getip()
{
    wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'
}

function grephistory() # search history
{
    history | grep $1 # history alias is built in oh-my-zsh
}
alias his='grephistory'
