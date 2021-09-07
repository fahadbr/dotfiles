#!/bin/bash

forkarg=
if [[ "$1" == "-n" ]]; then
	forkarg="-n"
fi

i3lock $forkarg \
	--ignore-empty-password  \
	--show-failed-attempts  \
	--pointer win \
	--tiling \
	--image ~/.config/lockscreen.png
