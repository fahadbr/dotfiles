#!/bin/bash

set -u

senderr() {
	notify-send -a "$0" "$AUTO_COMMIT_REPO" "failed to auto commit: $1"
	exit 1
}

do_commit_and_push() {
	cd $AUTO_COMMIT_REPO
	git pull && git commit -am 'auto commit' && git push
}

tmpfile=$(mktemp /tmp/autocommiterror.XXXXXXX.txt)
do_commit_and_push 2>$tmpfile || senderr $tmpfile


# send notification if there's any untracked files
if [[ "$(git status -u -s)" ]]; then
	notify-send -a "$0" "$AUTO_COMMIT_REPO" "untracked files exist"
fi

