#!/bin/bash

screenshotDir=~/photos/screenshots


datetime=$(date '+%Y%m%d-%s')
format=png
outfile="$screenshotDir/screenshot-$datetime.$format"
if [[ $WAYLAND_DISPLAY ]]; then
	options=
	first=true
	for copysave in "copy" "save"; do
		for target in active screen output area window; do
			if $first; then
				options="$copysave $target" 
				first=false
			else
				options="$options,$copysave $target" 
			fi

		done
	done

	selected=$(echo $options | rofi -dmenu -sep ',' -p "screenshot" -i)

	if [[ $selected ]]; then
		grimshot --notify $selected $outfile
	fi

else
	options='selection,screen'
	selected=$(echo $options | rofi -dmenu -sep ',' -p "screenshot" -i)
	if [[ -z $selected ]]; then
		exit 0
	fi
	case $selected in
		selection)
			import -format $format $outfile
			;;
		screen)
			import -format $format -window root $outfile
			;;
	esac

fi


