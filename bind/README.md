# Adding a new domain

* Tell the domain registrar that ns[1-5].linode.com are your nameservers

* Add a zone for the domain in Linode''s DNS manager (https://www.linode.com/members/dns/)
    * Set v.nix.is'' IP as the master, with domain transfer (AXFR) enabled.

* Add a zone for the domain in /etc/bind/named.conf

* Create /etc/bind/master/master.$your_domain

* Run "sudo /etc/bind/bin/distribute-domains.sh"
