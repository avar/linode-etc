package WebTest;
use 5.10.0;
use strict;
use Test::More;
use Test::WWW::Mechanize;

sub new {
    my ($class, %args) = @_;

    my $self = {
         %args,
    };

    bless $self => $class;
}

sub run_tests {
    my ($self) = @_;

    my $domain       = $self->{domain};
    my $content_like = $self->{content_like};
    my $base         = $self->{base_url};
    my $success      = $self->{success};
    my $site         = "http://$domain/";
    my $base_is      = $base // $site;

    plan( tests => 3 );

    my $mech = Test::WWW::Mechanize->new(
        agent => __FILE__,
    );

    $mech->get( $site );
    if ($success) {
        ok(  $mech->success, "Should get $site successfully" );
    } else {
        ok( !$mech->success, "Should get $site unsuccessfully" );
    }
    $mech->base_is( $base_is, "The base for <$site> is <$base_is>");
    $mech->content_like( $content_like, "$site has content like $content_like");

    return;
}

sub run_todo_test {
    my ($self) = @_;

    my $domain       = $self->{domain};
    plan( skip_all => "No tests for domain or alias $domain yet" );
    return;
}

1;
