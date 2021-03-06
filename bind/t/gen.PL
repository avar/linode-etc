#!/usr/bin/env perl
use 5.010;
use autodie qw[:all];
use strict;
use FindBin qw[$Bin];
use File::Path qw[remove_tree make_path];

chomp(my @domains = qx[ grep -h ORIGIN /etc/bind/master/master* | $^X -pe 's/^.*? (.*?)\.\$/\$1/' ]);
my @ns = qw(
    localhost
    ns1.first-ns.de
    robotns2.second-ns.de
    robotns3.second-ns.com
);

my @subdomain_tests = qw(A NS MX);
my @sub_zone_tests  = qw(A MX);
my @domain_tests    = ("SOA", @subdomain_tests);

remove_tree("$Bin/gen");

# Check slaves against localhost
for my $domain (@domains) {
    my @tests =
        is_subdomain($domain)
        ? (is_sub_zone($domain)
           ? @sub_zone_tests
           : @subdomain_tests)
        : @domain_tests;

    for my $ns (@ns[1..$#ns]) {
        my $test = <<TEST;
#!$^X
# DO NOT EDIT, AUTOGENERATED
use FindBin qw[\$Bin];
use lib qq[\$FindBin::Bin/../../lib];
use DomainTest;
DomainTest->new(
    domain  => q[$domain],
    servers => [ qw[ $ns[0] $ns ] ],
    tests   => [ qw[ @tests ] ],
)->run_tests;
TEST
        my $dir = "$Bin/gen/$ns";
        make_path($dir);
        open my $th, ">", "$dir/$domain.t";
        print $th $test;
        close $th;
    }
}

# Sanity check that the public servers have a NS record like ours
for my $domain (@domains) {
    next if is_subdomain($domain);

    my $test = <<TEST;
# DO NOT EDIT, AUTOGENERATED
use FindBin qw[\$Bin];
use lib qq[\$FindBin::Bin/../../../lib];
use DomainTest;
DomainTest->new(
    domain  => q[$domain],
    servers => [ 'ns1-coloc.hetzner.de', qw[ @ns ] ],
    recurse => 1,
)->run_public_tests;
TEST
    my $dir = "$Bin/gen/public/recurse";
    make_path($dir);
    open my $th, ">", "$dir/$domain.t";
    print $th $test;
    close $th;
}

# Sanity check that the the registry agrees with our NS records
for my $domain (@domains) {
    next if is_subdomain($domain);

    # Not localhost
    my @pns = @ns[1..$#ns];

    my $test = <<TEST;
# DO NOT EDIT, AUTOGENERATED
use FindBin qw[\$Bin];
use lib qq[\$FindBin::Bin/../../../lib];
use DomainTest;
DomainTest->new(
    domain  => q[$domain],
    servers => [ qw[ @pns ] ],
)->run_whois_tests;
TEST
    my $dir = "$Bin/gen/public/whois";
    make_path($dir);
    open my $th, ">", "$dir/$domain.t";
    print $th $test;
    close $th;
}


# Make sure the domain isn't about to expire
for my $domain (@domains) {
    next if is_subdomain($domain);

    # Not localhost
    my @pns = @ns[1..$#ns];

    my $test = <<TEST;
# DO NOT EDIT, AUTOGENERATED
use FindBin qw[\$Bin];
use lib qq[\$FindBin::Bin/../../../lib];
use DomainTest;
DomainTest->new(
    domain  => q[$domain],
    servers => [ qw[ @pns ] ],
)->run_whois_expire_tests;
TEST
    my $dir = "$Bin/gen/public/whois-expire";
    make_path($dir);
    open my $th, ">", "$dir/$domain.t";
    print $th $test;
    close $th;
}

sub is_subdomain
{
    my $domain = shift;
    my $dots  = () = $domain =~ /\./g;

    $dots != 1;
}

sub is_sub_zone
{
    my $domain = shift;
    chomp(my $maybe_ns = qx[ grep -A1 -h 'ORIGIN $domain' /etc/bind/master/master* ]);
    my $is_subzone = $maybe_ns =~ /IN +NS/;
    return $is_subzone;
}
