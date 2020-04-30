#!/bin/bash

set -e

id=$(pulsemixer --list-sinks | grep ZOOM | sed 's/.*\(ID: \)\([a-z0-9\-]\+\).*/\2/')

read left_vol right_vol <<<$(pulsemixer --get-volume --id $id)
pulsemixer --set-volume 100 --id $id
notify-send -a $0 "Changed Zoom Volume from ${left_vol}% to 100%"
