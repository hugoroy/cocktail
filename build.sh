#!/bin/sh
cd && git clone https://github.com/hugoroy/exegetesDoc.git
cd && git clone https://github.com/sniperovitch/mirrorpad.git
cd $HOME/mirrorpad/
cpanm Carton
carton install
cd $HOME/cocktail/
cp -v cocktail.conf.smp cocktail.conf

