What needs to be done to migrate `w.nix.is` to `u.nix.is`

Things that have been done already:

 * Basic partition setup, same as w, just larger
 * Created user accounts for all paying users, synced over their .ssh directory
 * Set up an ssh key for the root user, its public key is in authorized keys on w, makes it easy to rsync over
 * Installed the packages in /etc/deb-packages
 * Set up a clone of linode-etc.git in /etc. Most stuff not sorted out (see git status)
 * Copying stuff over from w:

    rsync -av --progress --delete-before root@w.nix.is:/{home,var,etc,bin,sbin,lib,lib64,usr,root} /w/

TODO:

 * Move over failo/rtorrent/leech

   Easiest just to create the relevant users, stop it on w, rsync over etc.

 * DONE Move over Apache

   Just rsync over /var/www etc. Needs some munging. Also needs MySQLdump
   etc. for the stuff using MySQL.

 * DONE bitlbee, needs syncing of data files
 
 * DONE mailmain, ditto
 
 * shellinabox, if hinrik still cares
 
 * DONE uptimed, install & migrate
 
 * DONE vnstatd, ditto
 
 * DONE memcached, just install
 
 * DONE -- mysql, data & start
 
 * DONE apache, data & start
 
 * DONE fail2ban, data in etc and start
 
 * openvpn, needs reconfiguration etc.
 
 * DONE redis-server, re-install?
 
 * BROKEN postgresql, migrate data files & start at version 9
 
   Copying over data files from pg 9.0 to use in 9.1: fail whale
 
 * DONE iodine, data in /etc/ and start
 
 * tor, just leave unconfigured
 
 * postfix

 * These daemons need configuring/checking:
    
    $ history|grep init.d
      DONE 113  2012-12-31 16:40:15  sudo /etc/init.d/mysql stop
      DONE 114  2012-12-31 16:40:19  sudo /etc/init.d/redis-server stop
      DONE 115  2012-12-31 16:40:24  sudo /etc/init.d/squid stop
      DONE 118  2012-12-31 16:40:37  sudo /etc/init.d/memcached stop
      DONE 119  2012-12-31 16:40:42  sudo /etc/init.d/pdns-recursor stop
      DONE 121  2012-12-31 16:41:26  sudo /etc/init.d/pdns stop
      MAYBE 12`12  2012-12-31 16:41:31  sudo /etc/init.d/apache2 stop
      DROPPED 124  2012-12-31 16:41:45  sudo /etc/init.d/munin stop
      DROPPED 125  2012-12-31 16:41:47  sudo /etc/init.d/munin-node stop
      DROPPED 129  2012-12-31 16:43:09  sudo /etc/init.d/avahi-daemon stop
      DROPPED 130  2012-12-31 16:43:12  sudo /etc/init.d/oidentd stop
      DROPPED 132  2012-12-31 16:43:20  sudo /etc/init.d/proftpd stop
