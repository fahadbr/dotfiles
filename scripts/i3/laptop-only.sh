#!/bin/bash

if [[ $WAYLAND_DISPLAY ]]; then
	swaymsg "output eDP-1 enable"
else
	if [[ "$MACHINE" == "home" ]]; then
		xrandr --output VIRTUAL1 --off --output eDP1 --primary --mode 1920x1200 --scale 1x1 --pos 0x0 --rotate normal --output DP1 --off --output HDMI2 --off --output HDMI1 --off --output DP2 --off --output DP3 --off
		~/.fehbg
	else
		xrandr --output VIRTUAL1 --off --output eDP1 --primary --mode 1920x1080 --scale 1x1 --pos 0x0 --rotate normal --output DP1 --off --output HDMI2 --off --output HDMI1 --off --output DP2 --off
	fi
	systemctl --user start powerman@bat.service
	pactl set-card-profile 0 output:analog-stereo
fi
