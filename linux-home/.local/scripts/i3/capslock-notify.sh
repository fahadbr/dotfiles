#!/bin/bash

if $( xset -q | grep 'LED mask:  00000001' &>/dev/null ) || [[ "$1" == "on" ]]; then
	dunstify -a '' -t 120000 -r 2596 -u critical 'CAPS LOCK ON'
else
	dunstify -a '' -t 750 -r 2596 -u normal 'caps lock off'
fi

# notify i3blocks
pkill -SIGRTMIN+11 i3blocks

