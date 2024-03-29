#!/bin/bash

# set -eo | pipefail

if [[ $WAYLAND_DISPLAY ]]; then
	output=$(swaymsg -t get_outputs | jq -r '.[] | select(.name != "eDP-1").name')
	swaymsg "output $output enable mode 3840x1200@120Hz pos 0 0"
	# positioning laptop monitor under the big monitor
	swaymsg "output eDP-1 pos 960 1200"
else

	extdisplay=$(xrandr | grep '\bconnected' | grep -v 'eDP' | cut -d ' ' -f 1)
	localdisplay=$(xrandr | grep '\bconnected' | grep 'eDP' | cut -d ' ' -f 1)

	if [[ $localdisplay ]]; then
		xrandr --output $extdisplay --primary --mode 3840x1200 --rate 120.00 --left-of $localdisplay
	else
		xrandr --output $extdisplay --primary --mode 3840x1200 --rate 120.00
	fi


	$HOME/.dotfiles/scripts/set-xkbdrate.sh
	$HOME/.dotfiles/scripts/i3/launch-polybar.sh
	$HOME/.fehbg
	$HOME/.dotfiles/scripts/i3/gen-lockscreen-images.sh home

fi

systemctl --user start powerman@ac.service
