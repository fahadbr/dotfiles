#!/bin/bash

# set -eo | pipefail

if [[ "$1" != "" ]]; then
	display=$1
else
	display=$(xrandr | grep '\bconnected' | grep -v 'eDP1' | cut -d ' ' -f 1)
fi

if [[ "$MACHINE" == "home" ]]; then
	xrandr --output $display --primary --auto --scale .6x.6 --left-of eDP1
else
	xrandr --output $display --primary --mode 1920x1080 --left-of eDP1
fi

systemctl --user start powerman@ac.service
~/.fehbg

