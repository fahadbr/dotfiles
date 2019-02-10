#!/usr/bin/env bash

set -e -o pipefail

dest=$(i3-msg -t get_workspaces | jq -r '.[] | .name' | rofi -p workspaces -dmenu)

if [[ -z $dest ]]; then
	exit 0
fi

i3-msg "move --no-auto-back-and-forth container to workspace $dest"
