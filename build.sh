#!/bin/sh
cd && git clone https://github.com/hugoroy/exegetesDoc.git
cd && git clone https://github.com/sniperovitch/mirrorpad.git
cd mirrorpad/
carton install
cd
cp -v cocktail.conf.smp cocktail.conf

