What needs to be done to migrate `v.nix.is` to `w.nix.is`

* OpenVPN - Move it to w

   Also tweak the account creation so it's easy to add new accounts by
   just adding a username to a list.
   
* Move over users

   E.g. hex isn't here yet, check /home/* on v and `git diff master..hetzner -- passwd`.
   
* Install PostgreSQL

   The debian package for both 9.0 and 8.4 is failing to install. We
   could use either one, but 9.0 would be better.
   
* Migrate oidentd

   hinrik uses this, or something.
   

* Migrate leech/failo

   Our torrent and robot setup.
