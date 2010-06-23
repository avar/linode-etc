# How you upgrade the perl on v:

sudo to `v-perlbrew`:

    sudo -u v-perlbrew -s -H
    
Then:

    perlbrew install -v perl-5.13.2
    perlbrew switch perl-5.13.2

Install the CPAN modules:
    
    curl -L http://cpanmin.us | perl - --self-upgrade
    grep -v ^# ~/cpan-modules | cpanm
