# Mail #

This is the mail setup I use, it is almost identical Jason Graham's setup (see below). Changes I made include file/directory locations and the removal of imapfilter. I also added Google contacts integration with goobook.

This will not work out of the box; it is strongly recommended that you go through each of the config files and adjust the settings according to your needs.
You should also read the blog post linked to below.

Original readme:


# Mail Configuration Example #

This is an example of what [my mail configuration][] looks like.  It will
probably not be especially useful to anyone without going through each file
and customizing.  I intend this to be more of a reference than a working
example.

That said, if anyone would like to contribute ideas / corrections, you are
welcome to submit pull requests.

[my mail configuration]:http://jason.the-graham.com/2011/01/10/email_with_mutt_offlineimap_imapfilter_msmtp_archivemail/

---

I use the following programs:

+ [offlineimap][]: Syncs mail in local Maildirs with remote IMAP servers.
+ [imapfilter][]: Sorts mail in remote IMAP servers.
+ [mutt][]: Reads the mail.
+ [msmtp][]: Sends new mail.
+ [mairix][]: Searches mail.
+ [lbdb][]: My local address book.
+ [gnome-keyring][]: To store the credentials for IMAP / SMTP.

[offlineimap]:http://offlineimap.org/
[imapfilter]:https://github.com/lefcha/imapfilter
[mutt]:http://www.mutt.org/
[msmtp]:http://msmtp.sourceforge.net/
[mairix]:http://www.rpcurnow.force9.co.uk/mairix/
[lbdb]:http://www.spinnaker.de/lbdb/
[gnome-keyring]:https://live.gnome.org/GnomeKeyring
