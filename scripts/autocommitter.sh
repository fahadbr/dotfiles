#!/bin/bash

set -u

senderr() {
	if [ "$1" ]
	then
		notify-send -a "$0" "$AUTO_COMMIT_REPO" "failed to auto commit: $1"
		exit 1
	fi
}

do_commit_and_push() {
	cd $AUTO_COMMIT_REPO
	git pull && git commit -am 'auto commit' && git push
}

tmpfile=$(mktemp /tmp/autocommiterror.XXXXXXX.txt)
trap "rm -f $tmpfile" EXIT
do_commit_and_push 2>$tmpfile >/dev/null
senderr "$(cat $tmpfile)"


# send notification if there's any untracked files
untracked=$(git status -uall -s | grep '^??' | wc -l)
if [ $untracked -gt 0 ]; then
	notify-send -a "$0" "$AUTO_COMMIT_REPO" "$untracked untracked files exist"
fi

