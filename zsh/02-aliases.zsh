alias de='test -f ~/.XkeymapDE && xkbcomp -w 0 ~/.XkeymapDE $DISPLAY'
alias us='test -f ~/.XkeymapUS && xkbcomp -w 0 ~/.XkeymapUS $DISPLAY'
alias hdmi='xrandr --output HDMI1 --auto --left-of LVDS'
alias pres='xrandr --fb 1366x768 --output DP2 --mode 1024x768 --panning 1366x0'
alias mon='xrandr --output DP2 --mode 1680x1050 --left-of eDP1
feh --bg-fill $HOME/.wallpaper/current.jpg'
alias update='sudo yaourt -Syua --noconfirm'
alias ls='ls --color=auto'
alias v='gvim'
alias tcm='truecrypt --mount /dev/sdc1 $HOME/Extern'
alias tcu='sudo umount $HOME/Extern'
alias tcd='truecrypt -d /dev/sdc1'
alias shu='systemctl poweroff'
alias re='sudo reboot'
alias wd='sudo ifconfig wlan0 down'
alias wu='sudo ifconfig wlan0 up'
alias install='sudo yaourt -S'
alias uninstall='sudo yaourt -Rns'
alias search='sudo yaourt -Ss'
alias tcmb='truecrypt --mount /dev/sdc1 $HOME/Extern2'
alias tcub='sudo umount $HOME/Extern2'
alias tcdb='truecrypt -d /dev/sdc1'
alias ps='ps -a -c -o pid,command -x'

# new mount function because alias does not accept parameters
newmount()
{
    sudo mount -t vfat -o umask=000 $1 $2
}

alias sm='newmount'
alias smd='newmount /dev/sdd1 $HOME/Extern2'
alias smc='newmount /dev/sdc1 $HOME/Extern2'
alias smb='newmount /dev/sdb1 $HOME/Extern2'

# new umount function
newumount()
{
    sudo umount $1
}

alias um='newumount'
alias um2='newumount $HOME/Extern2'

# grep
grephistory()
{
    grep $1 $HOME/.dotfiles/zsh/history.log
}
alias his='grephistory'
