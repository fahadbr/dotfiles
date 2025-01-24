#!/bin/bash

set -u


do_commit_and_push() {
	cd $AUTO_COMMIT_REPO
	git pull || return $?

	if [ "$(git status -uno -s)" ]
	then
		git commit -am 'auto commit' && git push
	fi
}

get_untracked() {
	cd $AUTO_COMMIT_REPO
	git status -uall -s | grep '^??' | wc -l
}

if ! res=$(do_commit_and_push 2>&1 >/dev/null); then
	if [ "$res" ]; then
		notify-send -a "$0" "$AUTO_COMMIT_REPO" "failed to auto commit: $res"
		exit 1
	fi
fi

# send notification if there's any untracked files
untracked=$(get_untracked)
if [ $untracked -gt 0 ]; then
	notify-send -a "$0" "$AUTO_COMMIT_REPO" "$untracked untracked files exist"
fi

