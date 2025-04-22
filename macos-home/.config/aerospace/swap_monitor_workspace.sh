#!/usr/bin/env bash

set -exu

## NOTES: this isnt really working as expected right now

direction="$1"
inverse="next"
if [ "$direction" = "next" ]; then
  inverse="prev"
fi

current_workspace="$(aerospace list-workspaces --focused)"
aerospace focus-monitor $direction
other_workspace="$(aerospace list-workspaces --focused)"
#aerospace move-workspace-to-monitor --workspace $other_workspace $inverse
#aerospace move-workspace-to-monitor --workspace $current_workspace $direction
#aerospace workspace $current_workspace
#aerospace workspace $other_workspace
#aerospace workspace $current_workspace

#aerospace summon-workspace $current_workspace
#aerospace focus-monitor $inverse
#aerospace summon-workspace $other_workspace
#aerospace workspace $current_workspace

aerospace summon-workspace $current_workspace
sleep .5
aerospace move-workspace-to-monitor --workspace $other_workspace $inverse
sleep .5
