#!/bin/bash

set -eu

if ! which betterlockscreen >/dev/null 2>&1; then
	exit 0
fi

workspace=$1
basedir=$HOME/.cache/betterlockscreen
wsdir="$basedir/$workspace"
curdir="$basedir/current"

if [[ -d $wsdir ]]; then
	ln -sfT $wsdir $curdir
	exit 0
fi

rm -Rf $curdir
betterlockscreen -u $HOME/code/polybar-themes/wallpapers/
mv $curdir $wsdir
ln -sfT $wsdir $curdir
