#!/bin/bash

options='laptop-only.sh,work-monitors.sh'

script=$(echo $options | rofi -dmenu -sep ',' -p "display mode" -i)

if [[ $script ]]; then
	echo "script chosen is $script"
	$HOME/.dotfiles/scripts/$script
fi
