#!/bin/sh
cd && git clone https://github.com/hugoroy/exegetesDoc.git
cd -
cp -v cocktail.conf.smp cocktail.conf
cp -v mirror_pad.yml.smp mirror_pad.yml
curl -L https://cpanmin.us | perl - App::cpanminus
cpanm --no-test URI::Encode Etherpad Config::YAML IO::Socket::SSL LWP::UserAgent

