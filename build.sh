#!/bin/sh
cp -v cocktail.conf.smp cocktail.conf
cd
git clone https://github.com/hugoroy/exegetesDoc.git
git clone https://github.com/sniperovitch/mirrorpad.git
cp $HOME/mirrorpad/mirrorpad.yml.smp $HOME/mirrorpad/mirrorpad.yml
#sudo $HOME/mirrorpad/build.sh
cd -

