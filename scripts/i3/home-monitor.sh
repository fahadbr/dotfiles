#!/bin/bash

# set -eo | pipefail

if [[ $WAYLAND_DISPLAY ]]; then
	output=$(swaymsg -t get_outputs | jq -r '.[] | select(.name != "eDP-1").name')
	swaymsg "output $output enable mode 3840x1200@120Hz pos 1920 0"
	#swaymsg "output eDP-1 pos 0 0"
	swaymsg "output eDP-1 disable"
else

	if [[ "$1" != "" ]]; then
		display=$1
	else
		display=$(xrandr | grep '\bconnected' | grep -v 'eDP1' | cut -d ' ' -f 1)
	fi

	#xrandr --output $display --primary --auto --scale .5x.5 --output eDP1 --pos 1920x0
	xrandr --output $display --primary --mode 3840x1200 --rate 120.00 --output eDP1 --left-of $display && \
		xrandr --output eDP1 --off

	systemctl --user start powerman@ac.service
	$HOME/scripts/set-xkbdrate.sh
	~/.fehbg

fi
