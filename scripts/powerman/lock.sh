#!/bin/bash

i3lock -n \
	--ignore-empty-password  \
	--show-failed-attempts  \
	--pointer win \
	--tiling \
	--image ~/.config/lockscreen.png

$HOME/.dotfiles/scripts/set-xkbdrate.sh
