#!/bin/bash

which betterlockscreen || (echo "already installed" && exit 0)

tmpdir=$(mktemp -d betterlockscreen.XXXXXX)
cd $tmpdir

wget https://github.com/pavanjadhaw/betterlockscreen/archive/refs/heads/main.zip
unzip main.zip
cd betterlockscreen-main/
chmod u+x betterlockscreen
cp betterlockscreen $HOME/.local/bin/

wallpaperdir=$HOME/code/polybar-themes/wallpapers/
if [[ -d $wallpaperdir ]]; then
	$HOME/.local/bin/betterlockscreen -u $HOME/code/polybar-themes/wallpapers/
else
	echo "no such dir $wallpaperdir"
	exit 1
fi
