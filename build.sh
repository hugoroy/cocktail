#!/bin/sh
cd && git clone https://github.com/hugoroy/exegetesDoc.git
cd -
cp -v cocktail.conf.smp cocktail.conf
curl -L https://cpanmin.us | perl - App::cpanminus
~/perl5/bin/cpanm local::lib
cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)

~/perl5/bin/cpanm URI::Encode Etherpad Config::YAML

