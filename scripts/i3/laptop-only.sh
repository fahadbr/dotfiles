#!/bin/bash

if [[ $WAYLAND_DISPLAY ]]; then
	swaymsg "output eDP-1 enable pos 0 0"
else
	for mon in $(xrandr --listmonitors | grep -v 'Monitors' | awk '{print $4}'); do

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

	~/.fehbg
fi

pactl set-card-profile 0 output:analog-stereo
systemctl --user start powerman@bat.service
