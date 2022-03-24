#!/bin/bash

if [[ $WAYLAND_DISPLAY ]]; then
	# TODO update this when available
	#output=$(swaymsg -t get_outputs | jq -r '.[] | select(.name != "eDP-1").name')
	#swaymsg "output $output enable mode 3840x1200@120Hz pos 1920 0"
	#swaymsg "output eDP-1 pos 0 0"
	#swaymsg "output eDP-1 disable"
	echo 'doing nothing for wayland right now'
else
	xrandr \
		--output DP-2 --mode 2560x1440 --primary --left-of eDP-1 --output DP-1 --mode 2560x1600 --rotate right --left-of DP-2
	$HOME/.dotfiles/scripts/set-xkbdrate.sh
	$HOME/.dotfiles/scripts/i3/launch-polybar.sh
	if [[ -f $HOME/.fehbg ]]; then
		$HOME/.fehbg
	fi
fi
systemctl --user start powerman@ac.service
