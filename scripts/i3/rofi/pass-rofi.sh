#!/usr/bin/env bash

set -eo pipefail
shopt -s nullglob globstar
bww=$HOME/.dotfiles/scripts/bww

dotype() {
	if [[ $WAYLAND_DISPLAY ]]
	then
		wtype $1
	else
		echo $1 | xdotool type --clearmodifiers --file -
	fi
}


function dopass {
	prefix=${PASSWORD_STORE_DIR-~/.password-store}
	password_files=( "$prefix"/**/*.gpg )
	password_files=( "${password_files[@]#"$prefix"/}" )
	password_files=( "${password_files[@]%.gpg}" )

	password=$(printf '%s\n' "${password_files[@]}" | rofi -dmenu -p "pass")

	[[ -n $password ]] || exit

	dotype "$(pass show "$password" | { IFS= read -r pass; printf %s "$pass"; })"
}

function dolpass {
	selected=$(lpass ls --sync=no | grep id | rofi -dmenu -p 'lpass')
	[[ -n $selected ]] || exit

	lpassID=$(echo $selected | sed -E 's/.*id: ([0-9]+)]/\1/')
	dotype "$(lpass show --sync=no --password $lpassID 2>&1 | { IFS= read -r pass; printf %s "$pass"; })"
}

dobw() {
	bww unlock
	selected=$($bww list | rofi -dmenu -p 'bitwarden')
	[[ -n $selected ]] || exit

	bwID=$(echo $selected | cut -d ':' -f 2)
	secret="$($bww show $bwID)"
	dotype $secret
}

case "$1" in
	lastpass) dolpass ;;
	bitwarden) dobw ;;
	pass) dopass ;;
	*)
		if which lpass &>/dev/null ; then
			dolpass
		elif which bw &> /dev/null ; then
			dobw
		else
			dopass
		fi
		;;
esac
