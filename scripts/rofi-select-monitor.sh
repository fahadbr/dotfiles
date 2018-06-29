#!/bin/bash

options='laptop-only.sh,external-4k.sh DP1,external-4k.sh DP2'

script=$(echo $options | rofi -dmenu -sep ',' -p "display mode" -i)

if [[ $script ]]; then
	echo "script chosen is $script"
	$HOME/scripts/$script
fi
