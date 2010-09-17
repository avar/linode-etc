package DomainTest;
use 5.010;
use strict;
use Test::More;
use Time::HiRes qw< gettimeofday tv_interval >;

sub new {
    my ($class, %args) = @_;

    my $self = {
        recurse => 0,
        %args,
    };

    bless $self => $class;
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

    $self->cmp_servers($res, \@servers);
}

sub tld {
    my $domain = shift;
    my ($tld) = $domain =~ m[ \. (?<tld>[^.]+)+ $]x;
    return $tld;
}

sub whois {
    my ($self, $domain) = @_;

    my $tld = tld($domain);
    my $whois_server = "$tld.whois-servers.net";

    my $cmd;
    given ($tld) {
        when ('is') { $cmd = qq[whois -p 4343 -h $whois_server $domain 2>&1] }
        default {     $cmd = qq[whois $domain 2>&1] }
    }

    return $self->do_cmd($cmd);
}

sub whois_nameservers {
    my ($self, $whois) = @_;

    my @public;
    for my $who (@$whois) {
        push @public =>    $1 if $who =~ /^nserver:\s+(\S+)/;  # .is
        push @public => lc $1 if $who =~ /Name Server: (\S+)/; # .net
        push @public => lc $1 if $who =~ /Name Server:(\S+)/;  # .org
    }

    return \@public;
}

sub whois_expires {
    my ($self, $whois) = @_;

    my ($str);

    for my $who (@$whois) {
        if ($who =~ /^expires:\s+(.*)/           # .is
            or $who =~ m[Record expires on (.*)] # .net
            or $who =~ m[Expiration Date:\s*(.*)] # aevar.net
            or $who =~ /^Expiration Date:(.*)/) { # .org
            $str = $1;
            last;
        }
    }

    require Date::Parse;
    my $time = Date::Parse::str2time($str);
    if (ok($time, "Got time <<$time>> from string <<$str>>")) {
        return ($time, $str);
    }
    return;
}

sub run_whois_tests {
    my ($self) = @_;

    my $domain     = $self->{domain};
    my (@servers)  = @{ $self->{servers} };

    plan( tests => 2 );

    # ISNIC only allows four nameservers, so does hailo.org's registar
    @servers = splice(@servers, 0, 4) if tld($domain) eq 'is' or $domain eq 'hailo.org';

    my @whois = @{ $self->whois($domain) };

  SKIP: {
    if (@whois == 1 && $whois[0] =~ /Connection refused/) {
        skip "Can't contact the whois server: @whois", 1;
    }
    my @public = @{ $self->whois_nameservers(\@whois) };
    $self->cmp_servers(\@public, \@servers);
  }

}

sub run_whois_expire_tests {
    my ($self) = @_;

    my $domain     = $self->{domain};
    my (@servers)  = @{ $self->{servers} };

    plan( tests => 3 );

    my @whois = @{ $self->whois($domain) };
  SKIP: {
    if (@whois == 1 && $whois[0] =~ /Connection refused/) {
        skip "Can't contact the whois server: @whois", 2;
    }
    if (my ($expires_time, $expires_str) = $self->whois_expires(\@whois)) {
        my $expires_str_normal = scalar localtime $expires_time;
        my ($now_time, $now_str) = (time, scalar localtime);

        my $diff = $expires_time - $now_time;
        my $diff_days = int($diff / (60 ** 2 * 24));

        cmp_ok(
            $diff_days, '>=', 30,
            "Domain <$domain> expires in $diff_days days ($diff seconds) at <$expires_time> (<$expires_str_normal> / <'$expires_str'>). Now is <$now_time> (<$now_str>)");
    } else {
        my $lns = @whois;
        fail("Couldn't get the expiration time for domain $domain, got $lns whois lines");
    }
  }
}

sub cmp_servers {
    my ($self, $res, $servers) = @_;

    my $nres     = @$res;
    my $nservers = @$servers;

    cmp_ok(
        $nres, '==', $nservers,
        "We should have $nservers public servers (<<@$servers>>); We got $nres (<<@$res>>)"
    );
    return;
}

sub dig_at
{
    my ($self, $host, $domain, $query) = @_;

    my $recurse = $self->{recurse} ? '' : '+norecurse';
    my $opt = $query eq 'AXFR' ? '' : '+short';
    my $cmd = qq[ dig $recurse $opt \@$host $domain $query | grep -v -e '^\$' -v -e '^;' | sort ];

    return $self->do_cmd($cmd);
}

sub do_cmd
{
    my ($self, $cmd) = @_;

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
