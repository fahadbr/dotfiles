#!/bin/bash

lockcmd='swaylock -f -i ~/.config/lockscreen.png -s tile'

if [[ "$1" == "lock" ]]; then
	$lockcmd
elif [[ "$1" == "ac" ]]; then
	pkill -RTMIN+4 waybar
	swayidle -w timeout 120 "$HOME/.local/bin/dimmer dim" resume "$HOME/.local/bin/dimmer restore" \
		timeout 600 "$lockcmd" \
		before-sleep "$lockcmd"
else
	pkill -RTMIN+4 waybar
	swayidle -w timeout 60 "$HOME/.local/bin/dimmer dim" resume "$HOME/.local/bin/dimmer restore" \
		timeout 120 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
		timeout 300 "$lockcmd" \
		timeout 600 'systemctl suspend' \
		before-sleep "$lockcmd"
fi
