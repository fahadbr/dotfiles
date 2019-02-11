#!/usr/bin/env bash
#
# assigns a number to a workspace

set -e -o pipefail

if [[ -z $1 ]]; then
	echo 'need a number to assign the workspace' 1>&2
	exit 1
fi

function renameWs() {
	local oldWsName=$1
	local numberOfFocused=$2
	local newNameForWs=$numberOfFocused

	if echo $oldWsName | grep -E '^[0-9]+$' &>/dev/null; then
		if [[ -z $numberOfFocused ]]; then
			# if the old workspace name was only a number then prompt for a new name for that workspace
			newNameForWs=$(rofi -l 0 -dmenu -P "enter name for workspace \"$oldWsName\"")
		fi
	else
		# otherwise proceed to remove the number from the old ws
		oldWsNameStripped=$(echo $oldWsName | sed -E 's/(^[0-9]+: )(.*)/\2/')

		if [[ -z $numberOfFocused ]]; then
			newNameForWs=$oldWsNameStripped
		else
			newNameForWs="$numberOfFocused: $oldWsNameStripped"
		fi
	fi

	if [[ -z $newNameForWs ]]; then
		echo "new name for workspace is empty" 1>&2
		exit 1
	fi

	resp=$(i3-msg "rename workspace \"$oldWsName\" to \"$newNameForWs\"" 2>&1)
	if echo $resp | grep ERROR &>/dev/null ; then
		notify-send -a $0 "failed to rename workspace" "$resp"
		exit 1
	fi
}

numberToAssign=$1
workspaces=$(i3-msg -t get_workspaces)

# get the currently focused workspace
focused=$(echo $workspaces | jq -r '.[] | select(.focused == true).name')

#	get the number of the currently focused ws if there is one
# we will use this to swap numbers with the ws that has the number we want
numberOfFocused=$(echo $focused | sed -En 's/(^[0-9]+)(:?.*)/\1/p')

if [[ "$numberToAssign" == "$numberOfFocused" ]]; then
	exit 0
fi

# if focused is just a number then the new name will just be the numberToAssign
if echo $focused | grep -E '^[0-9]+$' &>/dev/null; then
	tmpName="99"
	i3-msg "rename workspace \"$focused\" to \"$tmpName\""
	focused=$tmpName
fi

oldWs=$(echo $workspaces | jq -r ".[] | select(.num == $numberToAssign).name")
# if a workspace already has the number we need, we go into the flow below
if [[ $oldWs ]]; then
	renameWs "$oldWs" $numberOfFocused
fi


# rename the focused workspace, placing the number in front of it
renameWs "$focused" $numberToAssign

