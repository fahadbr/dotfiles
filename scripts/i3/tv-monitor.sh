#!/bin/bash

if [[ "$1" != "" ]]; then
	display=$1
else
	display=$(xrandr | grep '\bconnected' | grep -v 'eDP1' | cut -d ' ' -f 1)
fi

xrandr --output $display --auto --right-of eDP1
systemctl --user start powerman@bat.service
~/.fehbg

pactl set-card-profile 0 output:hdmi-stereo-extra1

