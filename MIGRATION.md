What needs to be done to migrate `v.nix.is` to `w.nix.is`

* A working mail system

   Set up postfix and mailman on w. We need to have cron E-Mails
   etc. sent out for all the stuff that's failing to run.

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
   
      Plan:
   
       1. reduce the dns refresh time
       2. shut down the sites on v
       3. mysqldump
       4. switch dns
       5. power up the sites on w
       
   blog.nix.is, velfag.is, and ci.nix.is use mysql for their
   databases. So we need to have PHP + MySQL working first.
