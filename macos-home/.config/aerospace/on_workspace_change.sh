#!/usr/bin/env bash

curr_workspace=$1
prev_workspace=$2

move_from_scratch() {

  if [ "$curr_workspace" = "scratch" ]; then
    window_id="$(aerospace list-windows --focused --format '%{window-id}')"
    aerospace move-node-to-workspace --focus-follows-window --window-id $window_id $prev_workspace
  fi
}

notify_sketchybar() {
  if [ "$curr_workspace" = "scratch" ]; then
    curr_workspace=$prev_workspace
  fi
  sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$curr_workspace PREV_WORKSPACE=$prev_workspace
}

move_from_scratch
notify_sketchybar
