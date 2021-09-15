#!/bin/bash

ignoreempty=""
if [[ "$1" == "--ignore-empty-password" ]]; then
	ignoreempty="--ignore-empty-password"
fi


i3lock -n \
	$ignoreempty  \
	--show-failed-attempts  \
	--pointer win \
	--tiling \
	--image ~/.config/lockscreen.png

$HOME/.dotfiles/scripts/set-xkbdrate.sh
