#!/bin/bash

device="98:09:CF:F2:E4:62"
nid=2500

action="connect"
connected=$(bluetoothctl info $device | grep -E 'Connected.*yes')
if [[ $connected ]]; then
	action="disconnect"
fi

notify-send -a "$0" "Attempting $action" "$device"

bluetoothctl $action $device && \
  notify-send -a "$0" "$action" "success: $device"
