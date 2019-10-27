#!/usr/bin/env bash

set -eo pipefail
shopt -s nullglob globstar
bww=$HOME/.dotfiles/scripts/bww

typeit=0
if [[ $1 == "--type" ]]; then
	typeit=1
	shift
fi

function dopass {
	prefix=${PASSWORD_STORE_DIR-~/.password-store}
	password_files=( "$prefix"/**/*.gpg )
	password_files=( "${password_files[@]#"$prefix"/}" )
	password_files=( "${password_files[@]%.gpg}" )

	password=$(printf '%s\n' "${password_files[@]}" | rofi -dmenu -p "pass")

	[[ -n $password ]] || exit

	if [[ $typeit -eq 0 ]]; then
		pass show -c "$password" 2>/dev/null
	else
		pass show "$password" | { IFS= read -r pass; printf %s "$pass"; } | xdotool type --clearmodifiers --file -
	fi
}

function dolpass {
	selected=$(lpass ls --sync=no | grep id | rofi -dmenu -p 'lpass')
	[[ -n $selected ]] || exit

	lpassID=$(echo $selected | sed -E 's/.*id: ([0-9]+)]/\1/')
	lpass show --sync=no --password $lpassID 2>&1 | { IFS= read -r pass; printf %s "$pass"; } | xdotool type --clearmodifiers --file -
}

function dobw {
	bww unlock
	selected=$($bww list | rofi -dmenu -p 'bitwarden')
	[[ -n $selected ]] || exit

	bwID=$(echo $selected | cut -d ':' -f 2)
	$bww show $bwID | { IFS= read -r pass; printf %s "$pass"; } | xdotool type --clearmodifiers --file -
}

if which lpass &>/dev/null ; then
	dolpass
elif [[ -f $bww ]]; then
	dobw
else
	dopass
fi
