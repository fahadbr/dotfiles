#!/bin/bash

set -euo pipefail

currentNet=$(nmcli -t c | awk -F ":" '/wireless/ {if ($4) print $1}')

filename=$(basename $0)
notify-send -a $filename "$(nmcli c down "$currentNet")" && \
notify-send -a $filename "$(nmcli c up "$currentNet")"
