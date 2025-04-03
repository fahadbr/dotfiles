#!/usr/bin/env bash

set -x

# move all windows to workspace 1
for window_workspace in $(aerospace list-windows --all --format '%{window-id}|%{workspace}'); do
  IFS='|' read wid workspace <<<"$(echo $window_workspace)"
  if [ "$workspace" = "scratch" ]; then
    continue
  fi
  if [ "$workspace" = "1" ]; then
    continue
  fi
  aerospace move-node-to-workspace --window-id $wid '1'
done

aerospace workspace '1'
aerospace flatten-workspace-tree
aerospace layout 'h_accordion'


