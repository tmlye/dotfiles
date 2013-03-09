alias de='test -f ~/.XkeymapDE && xkbcomp -w 0 ~/.XkeymapDE $DISPLAY'
alias us='test -f ~/.XkeymapUS && xkbcomp -w 0 ~/.XkeymapUS $DISPLAY'
alias x='xrandr --output DVI-0 --left-of DVI-1'
alias xmind='XMind -data $HOME/.xmind/'
alias update='sudo yaourt -Syua --noconfirm'
alias ls='ls --color=auto'
alias v='gvim'
alias tcm='truecrypt --mount /dev/sdb1 /home/sascha/Extern'
alias tcu='sudo umount /home/sascha/Extern'
alias tcd='truecrypt -d /dev/sdb1'
alias shu='sudo shutdown -h now'
alias re='sudo reboot'
alias wd='sudo ifconfig wlan0 down'
alias wu='sudo ifconfig wlan0 up'
alias tcmd='truecrypt --mount ~/Dropbox/fear ~/Cryptdrop/'
alias tcdd='truecrypt -d ~/Dropbox/fear'
alias install='sudo yaourt -S'
alias uninstall='sudo yaourt -Rns'
alias search='sudo yaourt -Ss'
alias tcmb='truecrypt --mount /dev/sdc1 /home/sascha/Extern2'
alias tcub='sudo umount /home/sascha/Extern2'
alias tcdb='truecrypt -d /dev/sdc1'
alias m='xrandr --output VGA-0 --mode 1680x1050 --left-of LVDS
feh --bg-fill /home/sascha/.wallpaper/current.jpg'
alias ps='ps -a -c -o pid,command -x'

# new mount function because alias does not accept parameters
newmount()
{
    sudo mount -t vfat -o umask=000 $1 $2
}

alias sm='newmount'
alias smc='newmount /dev/sdc1 $HOME/Extern2'
alias smb='newmount /dev/sdb1 $HOME/Extern2'

# new umount function
newumount()
{
    sudo umount $1
}

alias um='newumount'
alias um2='newumount /home/sascha/Extern2'
