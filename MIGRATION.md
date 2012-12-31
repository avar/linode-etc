What needs to be done to migrate `w.nix.is` to `u.nix.is`

Things that have been done already:

 * Basic partition setup, same as w, just larger
 * Created user accounts for all paying users, synced over their .ssh directory
 * Set up an ssh key for the root user, its public key is in authorized keys on w, makes it easy to rsync over
 * Installed the packages in /etc/deb-packages
 * Set up a clone of linode-etc.git in /etc. Most stuff not sorted out (see git status)

TODO:

 * Move over failo/rtorrent/leech

   Easiest just to create the relevant users, stop it on w, rsync over etc.

 * Move over squid/Apache

   Just rsync over /var/www etc. Needs some munging. Also needs MySQLdump
   etc. for the stuff using MySQL.

 * Move everything else. Add TODO items here.
