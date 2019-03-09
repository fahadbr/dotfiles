#!/bin/bash

xrandr --output DP2 --auto --primary --right-of eDP1 --output DP1 --auto --right-of DP2

$HOME/scripts/set-xkbdrate.sh
#$HOME/scripts/move-named-ws-to-primary.sh
systemctl --user start powerman@ac.service
