#!/bin/bash

set -e

id=$(pulsemixer --list-sinks | grep ZOOM | sed 's/.*\(ID: \)\([a-z0-9\-]\+\).*/\2/')
pulsemixer --set-volume 100 --id $id
notify-send -a $0 "Set Zoom Volume to 100%"
