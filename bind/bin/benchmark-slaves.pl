#!/usr/bin/env perl
use 5.010;
use strict;
use Benchmark q[:all];

my $count = $ARGV[0] // 5;
my $j     = $ARGV[1] // 10;
my $testdir = "/etc/bind/t/gen";

my @ns = grep { $_ =~ /^ns/ } map { s[.*/][]; $_ } glob "$testdir/*";

my %test;

for my $ns (@ns) {
    $test{$ns} = sub {
        system "prove -j $j -r $testdir/$ns" and die $!;
    };
};

cmpthese($count, \%test);
