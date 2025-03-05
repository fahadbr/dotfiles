#!/usr/bin/env bash

APP_ID=$1
APP_NAME=$2

IFS='|' read windowid workspace <<<"$(aerospace list-windows --monitor all --app-id $APP_ID --format '%{window-id}|%{workspace}' | head -n 1)"
current_window="$(aerospace list-windows --focused --format '%{window-id}')"

summon_app() {
  current_workspace=$(aerospace list-workspaces --focused)
  aerospace move-node-to-workspace --window-id $windowid $current_workspace
  aerospace focus --window-id $windowid
  aerospace move-mouse window-lazy-center
}

dismiss_app_to_scratchpad() {
  aerospace move-node-to-workspace scratch
}

# app not open
if [[ -z $windowid ]]; then
  open -a $APP_NAME
  #sleep 0.5
else
  if [[ $windowid == $current_window ]]; then
    dismiss_app_to_scratchpad
  elif [[ $workspace != 'scratch' ]]; then
    aerospace focus --window-id $windowid
  else
    # app is in scratch workspace so summon it
    summon_app
  fi
fi
