## ZSH Environment Variables
## ~/.config/zsh

export HISTSIZE=100
export SAVEHIST=100
export HISTFILE=~/.zshhistory
export DISPLAY=:0

export SHELL='/bin/zsh'

export EDITOR='gvim'

export PATH="/usr/local/bin:\
/usr/bin:\
/bin:\
/usr/local/sbin:\
/usr/sbin:\
/sbin:\
/opt/java/jre/bin:\
/usr/bin/site_perl:\
/usr/bin/vendor_perl:\
/usr/bin/core_perl:\
/home/sascha/bin:"

# Less
export LESSOPEN='| /usr/bin/highlight -0 ansi %s'
export LESS='-A$-R$-g$-i$-m$-s'

# vim: set ft=zsh
