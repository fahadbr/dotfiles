#!/bin/bash

set -u

cd $AUTO_COMMIT_REPO
git commit -am 'auto commit' && git push

# send notification if there's any untracked files
if [[ "$(git status -u -s)" ]]; then
	notify-send -a "$0" "$AUTO_COMMIT_REPO" "untracked files exist"
fi

