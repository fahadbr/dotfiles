#!/bin/bash

set -eu

shelltocheck=$1

check_extenstions() {
	echo "Extension Name,Supported,LatestVersion"
	for f in $(find $HOME/.local/share/gnome-shell/extensions -name metadata.json)
	do
		extension=$(jq -r '.name' $f)
		latestSupportedShell=$(jq -r '.["shell-version"][-1]' $f)
		if [[ $latestSupportedShell -ge $shelltocheck ]]
		then
			echo "$extension,SUPPORTED,$latestSupportedShell"
		else
			echo "$extension,NOT SUPPORTED,$latestSupportedShell"
		fi
	done
}

check_extenstions | column -t -s ','
