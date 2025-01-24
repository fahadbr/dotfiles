#!/usr/bin/env bash

set -eo pipefail
shopt -s nullglob globstar


prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=( "$prefix"/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

password=$(printf '%s\n' "${password_files[@]}" | rofi -dmenu -p "otp")

[[ -n $password ]] || exit

otp=$(pass otp "$password" | { IFS= read -r pass; printf %s "$pass"; })

if [[ $WAYLAND_DISPLAY ]]; then
	wtype $otp
else
	echo $otp | xdotool type --clearmodifiers --file -
fi


