#!/bin/bash

if [[ $WAYLAND_DISPLAY ]]; then
	# TODO update this when available
	#output=$(swaymsg -t get_outputs | jq -r '.[] | select(.name != "eDP-1").name')
	#swaymsg "output $output enable mode 3840x1200@120Hz pos 1920 0"
	#swaymsg "output eDP-1 pos 0 0"
	#swaymsg "output eDP-1 disable"
else
	xrandr --output DP2 --auto --primary --right-of eDP1 --output DP1 --auto --right-of DP2

	$HOME/.dotfiles/scripts/set-xkbdrate.sh
fi
systemctl --user start powerman@ac.service
