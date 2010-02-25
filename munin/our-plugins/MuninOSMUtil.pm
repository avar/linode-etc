package MuninOSMUtil;
use strict;
use Storable;

sub osm_cache
{
    my ($cache, $file, $generate_data) = @_;

    # Remove the host identifier from the MUNIN_STATEFILE. Helps with
    # running via munin-run but obviously breaks multi-host systems
    # (which I don't need)
    $cache  =~ s[-[^-]*$][];

    $cache .= '.storable';

    my $store; eval { $store = retrieve($cache) };
    my $file_ctime = ((stat($file))[10]);

    if ($store && ref $store eq 'HASH' && $store->{ctime} == $file_ctime) {
        return $store->{data};
    } else {
        my $data = $generate_data->();
        my $store = {
            ctime => $file_ctime,
            data => $data,
        };
        store $store, $cache;
        return $data;
    }
}

1;
