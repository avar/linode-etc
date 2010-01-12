#!/usr/bin/env perl
use Modern::Perl;
use Test::More tests => 10;

chomp(my @domains = qx[ ls /etc/bind/master/master* | perl -pe 's/.*master\.//' ]);
my @ns = (qw(localhost), map({ "ns$_.1984.is" } 0 .. 2), (map { "ns$_.linode.com" } 1..5));

for my $domain (@domains) {
    pass "Testing $domain";
    subtest "$domain AXFR" => sub {
        my %dig;

        $dig{$_} = dig_at($_, $domain, 'AXFR') for @ns;

        for my $slave (@ns[1..$#ns]) {
            is_deeply($dig{$ns[0]}, $dig{$slave}, "The AXFR for $domain \@$slave equals \@$ns[0]");
        }

        done_testing();
    };
}

sub dig_at
{
    my ($host, $domain, $cmd) = @_;

    chomp(my @out = qx[ dig \@$host $domain $cmd | grep -v -e ^$ -v -e '^;' | sort ]);

    \@out;
}
