#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

function get_volume {
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
    volume=`get_volume`
    dunstify -a " Volume" -t 2000 -r 2593 -u normal "$volume %"
    pkill -RTMIN+1 i3blocks
}

case $1 in
    up)
	# Set the volume on (if it was muted)
	amixer set Master on > /dev/null
	# Up the volume (+ 5%)
	amixer set Master 5%+ > /dev/null
	send_notification
	;;
    down)
	amixer set Master on > /dev/null
	amixer set Master 5%- > /dev/null
	send_notification
	;;
    mute)
    	# Toggle mute
	amixer set Master 1+ toggle > /dev/null
	if is_mute ; then
			dunstify -a " Volume" -t 2000 -r 2593 -u normal "Muted"
	else
	    send_notification
	fi
	;;
esac
