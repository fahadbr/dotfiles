#!/bin/bash

if [[ $WAYLAND_DISPLAY ]]; then
	output=$(swaymsg -t get_outputs | jq -r '.[] | select(.name != "eDP-1").name')
	swaymsg "output $output enable pos 0 0"
else
	if [[ "$1" != "" ]]; then
		display=$1
	else
		display=$(xrandr | grep '\bconnected' | grep -v 'eDP1' | cut -d ' ' -f 1)
	fi

	xrandr --output $display --auto --right-of eDP1
	systemctl --user start powerman@bat.service
	$HOME/.fehbg
	$HOME/.dotfiles/scripts/i3/launch-polybar.sh
	$HOME/.dotfiles/scripts/i3/gen-lockscreen-images.sh tv
fi

pactl set-card-profile 0 output:hdmi-stereo-extra1

