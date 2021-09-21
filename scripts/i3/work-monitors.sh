#!/bin/bash

if [[ $WAYLAND_DISPLAY ]]; then
	# TODO update this when available
	#output=$(swaymsg -t get_outputs | jq -r '.[] | select(.name != "eDP-1").name')
	#swaymsg "output $output enable mode 3840x1200@120Hz pos 1920 0"
	#swaymsg "output eDP-1 pos 0 0"
	#swaymsg "output eDP-1 disable"
	echo 'doing nothing for wayland right now'
else
	xrandr --output DP-2 --auto --primary --left-of eDP-1
	$HOME/.dotfiles/scripts/set-xkbdrate.sh
fi
systemctl --user start powerman@ac.service
