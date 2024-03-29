#!/bin/bash

set -e

killall -q polybar || true

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

COLORS_FILE=$HOME/.config/polybar/colors.sh

if [[ -f $COLORS_FILE ]]; then
	source $COLORS_FILE
fi

TRAY_OUTPUT=$(polybar -m | grep primary | cut -d ':' -f 1)

export WIFI_DEV=$(iw dev | awk '/Interface/ {print $2}' || echo 'none')
for m in $(polybar -m | cut -d ':' -f 1); do
	TP=none
	if [[ "$m" == "$TRAY_OUTPUT" ]]; then
		TP=right
	fi
	TRAY_POSITION="$TP" MONITOR="$m" polybar main -q -r -c $HOME/.config/polybar/grayblocks/config.ini &
done
