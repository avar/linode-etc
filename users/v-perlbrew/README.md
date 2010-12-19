# How to create the user

     sudo adduser --disabled-login --disabled-password v-perlbrew
     
# Install cpanm for the system perl

    curl -L http://cpanmin.us | perl - -S -v --self-upgrade
    cpanm -S App::perlbrew
    
# Initialize v-perlbrew

    sudo -u v-perlbrew -s -H
    perlbrew init
    perlbrew install -v perl-5.13.7

# How you upgrade the perl on v:

sudo to `v-perlbrew`:

    sudo -u v-perlbrew -s -H
    
Then:

    perlbrew install -v perl-5.13.5
    
But *don't* `perlbrew switch` to it yet, because that'll leave the
machine with a Perl without any modules we need.

Install the CPAN modules:
    
    curl -L http://cpanmin.us | ~/perl5/perlbrew/perls/perl-5.13.5/bin/perl5.13.5 - --self-upgrade
    grep -v ^# ~/cpan-modules | ~/perl5/perlbrew/perls/perl-5.13.5/bin/cpanm 
    
Fix any errors that came up, then switch to the new perl:

    perlbrew switch perl-5.13.5
