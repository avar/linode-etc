#!/usr/bin/env perl
use Modern::Perl;
use Test::More tests => 10;

chomp(my @domains = qx[ ls /etc/bind/master/master* | perl -pe 's/.*master\.//' ]);
my @ns = qw(localhost ns0.1984.is ns1.1984.is ns2.1984.is);

for my $domain (@domains) {
    pass "Testing $domain";
    subtest $domain => sub {
        my %dig;

        $dig{$_} = dig_at($_, $domain) for @ns;

        for my $slave (@ns[1..$#ns]) {
            is_deeply($dig{$ns[0]}, $dig{$slave}, "The configuration for $domain \@$slave equals \@$ns[0]");
        }

        done_testing();
    };
}

sub dig_at
{
    my ($host, $domain) = @_;

    chomp(my @out = qx[ dig \@$host $domain AXFR | grep -v -e ^$ -v -e '^;' | sort ]);

    \@out;
}
