#!/usr/bin/env perl
use Modern::Perl;
use Test::More;

chomp(my @domains = qx[ grep -h ORIGIN /etc/bind/master/master* | $^X -pe 's/^.*? (.*?)\.\$/\$1/' ]);
my @ns = (qw(localhost), map({ "ns$_.1984.is" } 0 .. 2), (map { "ns$_.linode.com" } 1..5));

for my $domain (@domains) {
    pass "Testing $domain";

    my @tests = qw(A NS MX);
    @tests = ("SOA", @tests, "AXFR") if is_subdomain($domain);

    for my $query (@tests) {
        subtest "$domain $query" => sub {
            my %dig;

            $dig{$_} = dig_at($_, $domain, $query) for @ns;

            for my $slave (@ns[1..$#ns]) {
                is_deeply($dig{$ns[0]}, $dig{$slave}, "The $query for $domain \@$slave equals \@$ns[0]");
            }

            done_testing();
        };
    }
}

done_testing();

sub dig_at
{
    my ($host, $domain, $cmd) = @_;

    my $opt = $cmd eq 'AXFR' ? '' : '+short';

    chomp(my @out = qx[ dig $opt \@$host $domain $cmd | grep -v -e ^$ -v -e '^;' | sort ]);

    \@out;
}

sub is_subdomain
{
    my $domain = shift;
    my $dots  = () = $domain =~ /\./g;

    $dots == 1;
}
