#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;
use Test::More;

my ($ip) = qx[ /sbin/ifconfig eth0 | grep 'inet addr' ] =~ m[inet addr:(\S+)];
my $url  = qq[https://check.torproject.org/cgi-bin/TorBulkExitList.py?ip=$ip];
chomp(my (@list) = qx[wget -q '$url' -O- | grep -v '^#' ]);

if (@list) {
    plan tests => scalar @list;
    cmp_ok $_, 'ne', $ip, "$_ is not $ip" for @list;
} else {
    plan skip_all => "Couldn't get list of Tor exits from $url"
}



