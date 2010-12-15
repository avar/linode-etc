What needs to be done to migrate `v.nix.is` to `w.nix.is`

* Install v-perlbrew

   This is needed for quotecc for `failo-wisdom` and numerous other
   things. Create the user and see the v-perlbrew README for how to
   install it.
   
* Set up a backup job for v

   generate a ssh keypair for a new v-backup user on w, and add its
   public ssh key to v:/root/.ssh/authorized_keys.
   
   Then set up a rsync job in cron that copies over the entire
   contents of v.nix.is to w.nix.is. We can afford the space, and
   having a complete local copy is nice.
   
* Set up munin-w.nix.is, noc-w.nix.is etc.

   Everything listed on http://noc.nix.is should be duplicated for w,
   so we can monitor it as it's being set up and taking over.
   
   Maybe we want to copy over the old RRD files from v to get
   historical graps, but then we'd have diverging graphs for the
   two. That probably can't be helped.
   
* Install & configure apache

   Install apache2 with the modules it has on v (and add them to
   `deb-packages`). Once 

* Start moving over /var/www sites

   Start moving some of them over, and edit `master.nix.is` on v to
   make the hostnames point to the new IP.
   
* Migrate MySQL

   This needs to be a dump/restore. Several www sites depend on this.
