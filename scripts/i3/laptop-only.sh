#!/bin/bash

	xrandr --output VIRTUAL1 --off --output eDP1 --primary --mode 1920x1080 --scale 1x1 --pos 0x0 --rotate normal --output DP1 --off --output HDMI2 --off --output HDMI1 --off --output DP2 --off
systemctl --user start powerman@bat.service
pactl set-card-profile 0 output:analog-stereo