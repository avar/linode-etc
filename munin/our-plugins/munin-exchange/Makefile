all:
	wget http://exchange.munin-monitoring.org/plugins/apache_activity/version/1/download -O apache_activity
	wget http://exchange.munin-monitoring.org/plugins/squid_efficiency/version/1/download -O squid_efficiency
	wget http://exchange.munin-monitoring.org/plugins/squid_times/version/1/download -O squid_times
	# Monkeypatch in host/port support to squid_times
	git show 61b6d0d8df4035f5b00591448167d53c57cc79fe | patch -p3
	wget http://exchange.munin-monitoring.org/plugins/squid/version/1/download -O squid

	wget http://exchange.munin-monitoring.org/plugins/vnstat/version/1/download -O vnstat
	wget http://exchange.munin-monitoring.org/plugins/fail2ban_all_jails/version/1/download -O fail2ban_all_jails

	wget http://exchange.munin-monitoring.org/plugins/linux_diskstat_/version/1/download -O linux_diskstat_
	# Use Time::HiRes
	git show 2cc46699e2e248b5c35073b2555c8ddc4989bcba | patch -p3
	git show 261458489c7b2cd955684d03c96eabd785417f58 | patch -p3

	wget http://exchange.munin-monitoring.org/plugins/sockstat/version/1/download -O sockstat
	# Plugin contains windows newlines in the shebang
	perl -pi -e 's/\r\n/\n/g' sockstat

	wget http://exchange.munin-monitoring.org/plugins/multips/version/1/download -O multips

	for i in rtom_mem rtom_peers rtom_spdd rtom_vol; do \
	    wget http://exchange.munin-monitoring.org/plugins/$$i/version/1/download -O $$i; \
	done

	# These are fail, they've been rewritten in another language etc.
	#wget http://exchange.munin-monitoring.org/plugins/tor_traffic/version/1/download -O tor_traffic
	#wget http://exchange.munin-monitoring.org/plugins/tor_routers/details -O tor_routers

	wget http://exchange.munin-monitoring.org/plugins/apache_activity/version/1/download -O apache_activity

	wget http://exchange.munin-monitoring.org/plugins/memcached-multigraph/version/1/download -O memcached_multi_

	wget http://exchange.munin-monitoring.org/plugins/mysql_connections/version/1/download -O mysql_connections

	# chmod +x
	chmod +x [a-z_]*
