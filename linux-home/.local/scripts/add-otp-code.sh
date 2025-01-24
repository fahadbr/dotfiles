#!/bin/bash

set -eo pipefail

function notifyError {
	notify-send -a $0 $1
	exit 1
}

# check for missing dependencies
for b in import zbarimg pass; do
	if ! which $b &>/dev/null; then
		notifyError "'$b' binary not installed"
	fi
done

otpname=$(rofi -dmenu -l 0 -p 'otp name')
[[ -z $otpname ]] && exit 0

tmpfile=$(mktemp "/tmp/qr.XXXXXXX.png")
trap "rm -f $tmpfile" EXIT


origSize=$(stat -c '%s' $tmpfile)
import -format png $tmpfile
if [[ $origSize -eq $(stat -c '%s' $tmpfile) ]]; then
	# no image was captured so just exit
	exit 0
fi

zbarimg -q --raw $tmpfile | pass otp insert $otpname
notify-send -a $0 "successfully added $otpname"

pass git push
