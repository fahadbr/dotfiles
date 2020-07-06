#!/bin/bash

# set -eo | pipefail

if [[ "$1" != "" ]]; then
	display=$1
else
	display=$(xrandr | grep '\bconnected' | grep -v 'eDP1' | cut -d ' ' -f 1)
fi

xrandr --output $display --primary --auto --scale .5x.5 --output eDP1 --pos 1920x0

systemctl --user start powerman@ac.service
$HOME/scripts/set-xkbdrate.sh
~/.fehbg

