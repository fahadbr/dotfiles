#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on background.color=$GREY background.border_width=2
elif [[ "${VISIBLE_WORKSPACES}" =~ "$1" ]]; then
    sketchybar --set $NAME background.drawing=on background.color=$BAR background.border_width=2
else
    sketchybar --set $NAME background.drawing=off background.border_width=0
fi

