#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

function get_volume {
    pulsemixer --get-volume | cut -d ' ' -f 1
}

function is_mute {
    [[ $(pulsemixer --get-mute) -eq 1 ]]
}

function send_notification {
    volume=`get_volume`
    dunstify -a " Volume" -t 2000 -r 2593 -u normal "$volume %"
    pkill -RTMIN+1 i3blocks
}

function up {
    # Set the volume on (if it was muted)
    pulsemixer --unmute
    # Up the volume (+ 5%)
    pulsemixer --change-volume +5
    send_notification

}

function down {
    pulsemixer --unmute
    pulsemixer --change-volume -5
    send_notification

}

function mute {
    # Toggle mute
    pulsemixer --toggle-mute
    if is_mute ; then
	dunstify -a " Volume" -t 2000 -r 2593 -u normal "Muted"
    else
	send_notification
    fi
}

function i3blocks {
    if is_mute; then
	echo "MUTE"
	echo "MUTE"
	echo "#FF3333"
    else
	echo "$(get_volume)%"
    fi
}

cmd=$1
shift 1
$cmd
