# Package Management
# ==================

alias update='pikaur -Syu --noconfirm'
alias install='pikaur -S'
alias uninstall='pikaur -Rns'
alias search='pikaur -Ss'

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
alias musb='sudo mount -U 651B-DF09 $HOME/mount2'

# Cryptsetup
# ==========

alias me='sudo cryptsetup --type luks open /dev/disk/by-uuid/2c501317-75d0-4816-807e-00b4b37a9f8b extern && sudo mount -t ext4 /dev/mapper/extern $HOME/mount'
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
alias tf='terraform'

function getip()
{
    wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'
}

function grephistory() # search history
{
    history | grep $1 # history alias is built in oh-my-zsh
}
alias his='grephistory'

# GIT
# ===

alias gcb='git checkout -b'
alias gpu='git push -u origin `git rev-parse --abbrev-ref HEAD`'
alias gfm='git fetch origin master:master'
alias grm='git rebase master'
alias gpl='git pull'

# Kubectl
# =======

alias k='kubectl "--context=${KUBECTL_CONTEXT:-$(kubectl config current-context)}" ${KUBECTL_NAMESPACE/[[:alnum:]-]*/--namespace=${KUBECTL_NAMESPACE}}'
alias kd='kubectl describe'
alias kg='kubectl get'
