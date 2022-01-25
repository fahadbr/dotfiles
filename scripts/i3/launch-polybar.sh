#!/bin/bash

set -e

killall -q polybar || true

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

COLORS_FILE=$HOME/.config/polybar/colors.sh

if [[ -f $COLORS_FILE ]]; then
	source $COLORS_FILE
fi

TRAY_OUTPUT=$(polybar -m | grep primary | cut -d ':' -f 1)

for m in $(polybar -m | cut -d ':' -f 1); do
	export TRAY_POSITION=none
	if [[ $m == $TRAY_OUTPUT ]]; then
		export TRAY_POSITION=right
	fi
	MONITOR=$m polybar main -q -r -c $HOME/.config/polybar/grayblocks/config.ini &
done
