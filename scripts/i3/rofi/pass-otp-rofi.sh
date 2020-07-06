#!/usr/bin/env bash

set -eo pipefail
shopt -s nullglob globstar


prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=( "$prefix"/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

password=$(printf '%s\n' "${password_files[@]}" | rofi -dmenu -p "otp")

[[ -n $password ]] || exit

pass otp "$password" | { IFS= read -r pass; printf %s "$pass"; } | xdotool type --clearmodifiers --file -

