#!/bin/sh

# Install Pandoc from sources (Debian version is without filters)
wget https://github.com/jgm/pandoc/releases/download/1.19.2.1/pandoc-1.19.2.1-1-amd64.deb
sudo dpkg -i *.deb

sudo apt-get -qq update
sudo apt-get install -y texlive-latex-base texlive-font-utils texlive-latex-recommended texlive-fonts-recommended texlive-latex-extra
sudo apt-get install -y python-pip
sudo pip install pandoc-latex-environment

cp -v cocktail.conf.smp cocktail.conf
MYHOME=$(pwd)
cd ..
git clone https://github.com/hugoroy/exegetesDoc.git
git clone https://github.com/sniperovitch/mirrorpad.git
cd mirrorpad
./build.sh
cd "$MYHOME"

