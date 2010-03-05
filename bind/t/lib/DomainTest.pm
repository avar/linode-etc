package DomainTest;
use strict;
use Test::More;

sub new {
    my ($class, %args) = @_;

    bless \%args => $class;
}

sub run_tests {
    my ($self) = @_;

    my $domain   = $self->{domain};
    my @ns       = @{ $self->{servers} };
    my @tests    = @{ $self->{tests} };

    plan( tests => @tests * (scalar(@ns) - 1) );

    for my $query (@tests) {
        my %dig;
        $dig{$ns[0]} = $self->dig_at($ns[0], $domain, $query);

        for my $slave (@ns[1..$#ns]) {
            $dig{$slave} = $self->dig_at($slave, $domain, $query);
            is_deeply($dig{$ns[0]}, $dig{$slave}, "The $query for $domain \@$slave equals \@$ns[0]");
        }
    }
}

sub dig_at
{
    my ($self, $host, $domain, $query) = @_;

    my $opt = $query eq 'AXFR' ? '' : '+short';
    my $cmd = qq[ dig +norecurse $opt \@$host $domain $query | grep -v -e ^$ -v -e '^;' | sort ];

    chomp(my @out = qx[ $cmd ]);

    \@out;
}

1;
