#!/bin/bash

# keep track of currently focused workspace
focusedWs=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused == true).name')

i3-msg -t get_workspaces | jq '.[] | .name' | grep -E '[a-zA-Z]+'| xargs -I '{}' bash -c "i3-msg workspace '{}' && i3-msg move workspace to output primary"

i3-msg workspace "$focusedWs"


