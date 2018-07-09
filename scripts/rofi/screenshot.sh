#!/bin/bash

screenshotDir=~/photos/screenshots
options='selection,screen'
selected=$(echo $options | rofi -dmenu -sep ',' -p "screenshot" -i)

if [[ -z $selected ]]; then
	exit 0
fi

datetime=$(date '+%Y%m%d-%s')
format=png
outfile="$screenshotDir/screenshot-$datetime.$format"

case $selected in
	selection)
		import -format $format $outfile
		;;
	screen)
		import -format $format -window root $outfile
		;;
esac

