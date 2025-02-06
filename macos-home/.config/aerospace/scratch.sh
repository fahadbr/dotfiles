#!/usr/bin/env bash

APP_ID=$1
APP_NAME=$2

summon_app() {
  current_workspace=$(aerospace list-workspaces --focused)
  app_window_id=$(aerospace list-windows --monitor all --app-id "$APP_ID" --format "%{window-id}" | head -n 1)
  aerospace move-node-to-workspace --window-id $app_window_id $current_workspace
  aerospace focus --window-id $app_window_id
  aerospace move-mouse window-lazy-center
}

app_closed() {
  if [ "$(aerospace list-apps | grep $APP_NAME)" == "" ]; then
    true
  else
    false
  fi
}

app_focused() {
  if [ "$(aerospace list-windows --focused --format "%{app-bundle-id}")" == "$APP_ID" ]; then
    true
  else
    false
  fi
}

dismiss_app_to_scratchpad() {
  aerospace layout floating
  aerospace move-node-to-workspace scratch
}

if app_closed; then
  open -a $APP_NAME
  sleep 0.5
else
  if app_focused; then
    dismiss_app_to_scratchpad
  else
    summon_app
  fi
fi
