# Adding a new domain

* Tell the domain registrar that (`ns1.first-ns.de`, `robotns2.second-ns.de`, `robotns3.second-ns.com`) are your nameservers

* Go to https://robot.your-server.de/dns and add a new slave DNS entry for the domain, with w.nix.is' IP as the IP address

* Add a zone for the domain in `/etc/bind/named.conf`

* Create `/etc/bind/master/master.YOUR_DOMAIN`

* Run `sudo /etc/bind/bin/distribute-domains.sh`
