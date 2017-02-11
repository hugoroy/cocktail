#!/bin/sh
cd && git clone https://github.com/hugoroy/exegetesDoc.git
cd -
cp -v cocktail.conf.smp cocktail.conf
curl -L https://cpanmin.us | perl - App::cpanminus
~/perl5/bin/cpanm local::lib
~/perl5/bin/cpanm URI::Encode Etherpad Config::YAML

# Add path to ~/perl5 modules to ~/.bashrc
echo '[ $SHLVL -eq 1 ] && eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"' >> ~/.bashrc
