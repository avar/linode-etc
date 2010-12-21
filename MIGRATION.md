What needs to be done to migrate `v.nix.is` to `w.nix.is`

* OpenVPN - Move it to w

   Also tweak the account creation so it's easy to add new accounts by
   just adding a username to a list.
   
* Move over users

   E.g. hex isn't here yet, check /home/* on v and `git diff master..hetzner -- passwd`.
   
* Migrate PostgreSQL data
   
* Migrate leech/failo

   Our torrent and robot setup.
