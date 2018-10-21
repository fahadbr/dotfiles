#!/bin/bash

forkarg=
if [[ "$1" == "-n" ]]; then
	forkarg="-n"
fi

i3lock $forkarg -e -f -t -i ~/.config/lockscreen.png
