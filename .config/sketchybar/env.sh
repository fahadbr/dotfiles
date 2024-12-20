#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

# env variables
export CACHE_DIR="$HOME/.cache/sketchybar"
export PLUGIN_DIR="$CONFIG_DIR/plugins"
export ITEM_DIR="$CONFIG_DIR/items"
export LOG_FILE="aerospace.log"

export ICON_FONT="sketchybar-app-font:Regular"
export ICON_FONTSIZE=14
export FONT="SF Pro:Semibold"
export FONTSIZE=12
export NERD="Symbols Nerd Font:Regular"
export ICOMOON="Icomoon:Regular"

export BAR_HEIGHT=40
export ITEM_HEIGHT=40
export ITEM_HEIGHT_WITH_LABEL=60
#export LABEL_ONLY_HEIGHT=25
#export LABEL_Y_OFFSET=-17
export BORDER_WIDTH=2
