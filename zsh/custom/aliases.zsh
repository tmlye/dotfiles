# Keyboard
# ========

alias de='test -f ~/.XkeymapDE && xkbcomp -w 0 ~/.XkeymapDE $DISPLAY'
alias us='test -f ~/.XkeymapUS && xkbcomp -w 0 ~/.XkeymapUS $DISPLAY'

# External Screens
# ================

alias hdmi='xrandr --output HDMI1 --auto --left-of LVDS'
alias pres='xrandr --fb 1366x768 --output DP2 --mode 1024x768 --panning 1366x0'
alias mon='xrandr --output DP2 --mode 1680x1050 --left-of eDP1
feh --bg-fill $HOME/.wallpaper/current.jpg'

# Package Management
# ==================

alias update='sudo yaourt -Syua --noconfirm'
alias install='sudo yaourt -S'
alias uninstall='sudo yaourt -Rns'
alias search='sudo yaourt -Ss'

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
alias musb='sudo mount -U 442065E86FCD4ADE $HOME/mount2'
alias msa='sudo mount -U 2ab49980-3dd0-4dc7-bd10-1c9a9ce0f082 .msata'

# Truecrypt
# =========

alias tcm='truecrypt --mount `sudo fdisk -l | grep -A 3 "^Disk identifier: 0xbf40ec14" | grep -o "/dev/sd[a-z]1"` $HOME/mount'
alias tcu='sudo umount $HOME/mount'
alias tcd='truecrypt -d `sudo fdisk -l | grep -A 3 "^Disk identifier: 0xbf40ec14" | grep -o "/dev/sd[a-z]1"`'

# Power
# =====

alias shu='systemctl poweroff'
alias re='sudo reboot'

# Various
# =======

alias ps='ps -a -c -o pid,command -x'
alias v='gvim'
alias ls='ls --color=auto'

function grephistory() # search history
{
    history | grep $1 # history alias is built in oh-my-zsh
}
alias his='grephistory'