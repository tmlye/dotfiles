#!/bin/bash
#
# This is a setup script to make all the
# symlinks and directories that you will need
# to use this mail setup.
#
# For now, this is specific to myself, and assumes
# that I have put the mail configuration repo in
# $HOME/.dotfiles/mail/

# Get the directory name of the setup script

function notes {
	echo "If you haven't already, you will need to install mutt,"
    echo "offlineimap,( imapfilter,) archivemail, mairix, and msmtp,"
	echo "as well as the python bindings for gnome-keyring"
	echo ""
	echo "Also, to let offlineimap/imapfilter be run through cron,"
	echo "add export_x_info.sh to your startup scripts."
	echo ""
	echo "When these have been installed, use bin/msmtp-gnome-tool.py"
	echo "and bin/offlineimap-gnome-tool.py to populate gnome-keyring"
	echo "with your passwords, for gmail use the server imap.gmail.com."
	echo ""
	echo ""
	echo "Insert something like the following into your crontab (crontab -e)"
	echo ""
	echo "*/10 *   *  *  *  $HOME/.dotfiles/bin/pullmail.sh > $HOME/.offlineimap.last.log"
    echo "13   */2 *  *  *  mairix -p -f $HOME/.dotfiles/mail/mairixrc"
	echo "15   */2 *  *  *  $HOME/.dotfiles/mail/lib/refreshaddress.sh"
}

# Make the required mail directories
mkdir -p $HOME/.mail/ohm
mkdir -p $HOME/.mail/web

# We need to make $HOME/.mairix too
mkdir -p $HOME/.mairix

# Symlinks
declare -a links=(.msmtprc .mutt .offlineimaprc .mairixrc)
# If files already exist create backups
for i in ${links[*]}
do
  if [ -e $HOME/$i ]
    then mv ~/$i ~/$i.backup
  fi
done

ln -s $HOME/.dotfiles/mail/msmtprc $HOME/.msmtprc
ln -s $HOME/.dotfiles/mail/mutt $HOME/.mutt
ln -s $HOME/.dotfiles/mail/offlineimaprc $HOME/.offlineimaprc
ln -s $HOME/.dotfiles/mail/mairixrc $HOME/.mairixrc

# msmtprc needs to be 600 permissions
chmod 600 $HOME/.dotfiles/mail/msmtprc

# binary files
rm $HOME/.dotfiles/bin/pullmail.sh
ln -s $HOME/.dotfiles/mail/bin/pullmail.sh $HOME/.dotfiles/bin/pullmail.sh

# Create required folders
mkdir -p $HOME/.mutt/{temp,cache}

# Print out the notes to end
notes

