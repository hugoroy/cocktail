#!/bin/sh
cd $HOME
wget https://github.com/jgm/pandoc/releases/download/1.19.2.1/pandoc-1.19.2.1-1-amd64.deb
dpkg -i *.deb
git clone https://github.com/hugoroy/exegetesDoc.git
cd $HOME/cocktail
cp -v cocktail.conf.smp cocktail.conf

