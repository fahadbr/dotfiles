#!/bin/sh

set -e

killall polybar || true
TRAY_OUTPUT=$(polybar -m | grep primary | cut -d ':' -f 1)

for m in $(polybar -m | cut -d ':' -f 1); do
	export TRAY_POSITION=none
	if [[ $m == $TRAY_OUTPUT ]]; then
		export TRAY_POSITION=right
	fi
	MONITOR=$m polybar default -q -r -c ~/.dotfiles/.config/polybar/config &
done
