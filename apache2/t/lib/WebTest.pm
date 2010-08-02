package WebTest;
use 5.10.0;
use strict;
use Test::More;
use Test::WWW::Mechanize;

sub new {
    my ($class, %args) = @_;

    my $self = {
        mech => Test::WWW::Mechanize->new(
            agent => __FILE__,
        ),
        site => "http://$args{domain}",
         %args,
    };

    bless $self => $class;
}

sub get {
    my ($self, $mech) = @_;
    my $success      = $self->{success};
    my $site         = $self->{site};

    $mech->get( $site );
    if ($success) {
        ok(  $mech->success, "Should get $site successfully" );
    } else {
        ok( !$mech->success, "Should get $site unsuccessfully" );
    }
    return;
}

sub run_content_like_tests {
    my ($self) = @_;

    my $mech         = $self->{mech};
    my $domain       = $self->{domain};
    my $site         = $self->{site};
    my $content_like = $self->{content_like};

    plan( tests => 2 );
    $self->get($mech);
    $mech->content_like( $content_like, "$site has content like $content_like");

    return;
}

sub run_base_is_tests {
    my ($self) = @_;

    my $mech         = $self->{mech};
    my $domain       = $self->{domain};
    my $site         = $self->{site};
    my $base         = $self->{base_url};
    my $base_is      = $base // $site;

    plan( tests => 2 );
    $self->get($mech);
    $mech->base_is( $base_is, "The base for <$site> is <$base_is>");

    return;
}

sub run_follow_links_tests {
    my ($self) = @_;

    my $mech         = $self->{mech};
    my $domain       = $self->{domain};
    my $follow_links = $self->{follow_links};

    plan( tests => 2 );
    $self->get($mech);

    unless ($follow_links) {
      SKIP:{
          skip "Shouldn't follow links on $domain", 1;
      }
        return;
    }

    my @links = $mech->followable_links();
    subtest "Followable links aren't 404" => sub {
        plan tests => scalar @links;
        for my $l (@links) {
            $mech->link_status_isnt( $l->url, 404, sprintf "Link %s on domain $domain isn't 404", $l->url );
        }
    };
}

sub run_todo_test {
    my ($self) = @_;

    my $domain       = $self->{domain};
    plan( skip_all => "No tests for domain or alias $domain yet" );
    return;
}

1;
