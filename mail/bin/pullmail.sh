#!/bin/bash
#
# This script is run in a cron job to do the actual synchronization of mail.

# Source the environmental variables we need to access gnome-keyring
source $HOME/.Xdbus

# Perform the synchronization
/usr/bin/offlineimap > $HOME/.dotfiles/mail/offlineimap.last.log
