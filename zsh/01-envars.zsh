## ZSH Environment Variables
## ~/.config/zsh

export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.dotfiles/zsh/history.log
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
$HOME/.gem/ruby/1.9.1/bin:\
/usr/bin/site_perl:\
/usr/bin/vendor_perl:\
/usr/bin/core_perl:\
$HOME/.dotfiles/bin:"

# Less
export LESSOPEN='| /usr/bin/highlight -0 ansi %s'
export LESS='-A$-R$-g$-i$-m$-s'

# vim: set ft=zsh
