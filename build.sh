#!/bin/sh
cd && git clone https://github.com/hugoroy/exegetesDoc.git
cd -
cp -v cocktail.conf.smp cocktail.conf
curl -L https://cpanmin.us | perl - App::cpanminus
# cpanm --local-lib=~/perl5 local::lib
# eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
# perl -I ~/perl5/lib/perl5/ -Mlocal::lib >> .bashrc
cpanm URI::Encode Etherpad Config::YAML IO::Socket::SSL

