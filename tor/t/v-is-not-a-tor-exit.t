#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;
use Test::More;

# Get the list of exit nodes
my ($request_ip) = qx[ /sbin/ifconfig eth0 | grep 'inet addr' ] =~ m[inet addr:(\S+)];
my $url  = qq[https://check.torproject.org/cgi-bin/TorBulkExitList.py?ip=$request_ip];
chomp(my (@list) = qx[wget -q '$url' -O- | grep -v '^#' ]);

# Get all the interfaces I could exit through
my @all_ip = qx[ /sbin/ifconfig | grep 'inet addr' ] =~ m[inet addr:(\S+)]g;
my @ip = grep { ! / ^ (?: 127 | 172 ) \. /x } @all_ip;

# Plan tests
plan @list
    ? (tests => @list * @ip)
    : (skip_all => "Couldn't get list of Tor exits from $url");

for my $exit (@list) {
    for my $ip (@ip) {
        cmp_ok $ip, 'ne', $exit, "Our IP $ip is not the exit $exit";
    }
}



