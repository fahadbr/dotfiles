#!/bin/bash

if [[ $WAYLAND_DISPLAY ]]; then
	swaymsg "output eDP-1 enable pos 0 0"
else
	for mon in $(xrandr | grep '\bconnected' | cut -d ' ' -f 1); do

		if echo $mon | grep -q 'eDP'; then
			mode="--auto"
			if [[ "$MACHINE" == "home" ]]; then
				mode="--mode 1920x1200"
			fi

			xrandr --output $mon --primary $mode --scale 1x1 --pos 0x0 --rotate normal
		else
			xrandr --output $mon --off
		fi

	done

	$HOME/.fehbg
	$HOME/.dotfiles/scripts/i3/launch-polybar.sh
fi

pactl set-card-profile 0 output:analog-stereo
systemctl --user start powerman@bat.service
