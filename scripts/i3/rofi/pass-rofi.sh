#!/usr/bin/env bash

set -exo pipefail
#shopt -s nullglob globstar
bww=$HOME/.dotfiles/scripts/bww

dotype() {
	if [[ $WAYLAND_DISPLAY ]]
	then
		wtype $1
	else
		echo $1 | xdotool type --clearmodifiers --file -
	fi
}

dobw() {
	bww unlock
	selected=$($bww list | rofi -dmenu -p 'bitwarden')
	[[ -n $selected ]] || exit

	bwID=$(echo $selected | cut -d ':' -f 2)
	secret="$($bww show $bwID)"
	dotype $secret
}

dobw
