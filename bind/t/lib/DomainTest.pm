package DomainTest;
use strict;
use Test::More;
use Time::HiRes qw< gettimeofday tv_interval >;

sub new {
    my ($class, %args) = @_;

    bless \%args => $class;
}

sub run_tests {
    my ($self) = @_;

    my $domain   = $self->{domain};
    my @ns       = @{ $self->{servers} };
    my @tests    = @{ $self->{tests} };

    my $tests = @tests
                * (
                    # One for dig @localhost
                    1
                    +
                    # Two for every dig @$ns
                    (2 * (@ns - 1)));
    plan( tests => $tests );

    for my $query (@tests) {
        my %dig;
        $dig{$ns[0]} = $self->dig_at($ns[0], $domain, $query);

        for my $slave (@ns[1..$#ns]) {
            $dig{$slave} = $self->dig_at($slave, $domain, $query);

            is_deeply($dig{$slave}, $dig{$ns[0]}, "The $query for $domain \@$slave equals \@$ns[0]");
        }
    }
}

sub run_public_tests {
    my ($self) = @_;

    my $domain              = $self->{domain};
    my ($public, undef, @servers)  = @{ $self->{servers} };

    plan( tests => 2 );

    my $res = $self->dig_at($public, $domain, "NS");

    cmp_ok(scalar(@$res), '==', scalar(@servers), "We should have " . scalar(@servers) . " public servers (<<@servers>>); We got: <<@$res>>");
}

sub dig_at
{
    my ($self, $host, $domain, $query) = @_;

    my $opt = $query eq 'AXFR' ? '' : '+short';
    my $cmd = qq[ dig +norecurse $opt \@$host $domain $query | grep -v -e '^\$' -v -e '^;' | sort ];

    my $t0 = [gettimeofday];
    chomp(my @out = qx[ $cmd ]);
    my $t1 = [gettimeofday];
    my $elapsed = tv_interval($t0, $t1);

    my $subtest = sprintf "^^ output of <<$cmd>> (in %.3f seconds)", $elapsed;
    subtest $subtest => sub {
        if (@out == 0) {
            plan tests => 1;
            pass("No output");
        } else {
            plan tests => scalar @out;
            pass($_) for @out;
        }
    };

    \@out;
}

1;
