#!/usr/bin/env bash
#
# assigns a number to a workspace

set -e -o pipefail

if [[ -z $1 ]]; then
	echo 'need a number to assign the workspace' 1>&2
	exit 1
fi

# renameWs attempts to rename a workspace by assigning (or removing) a number
# possible outcomes are:
#   OldWsName   Number   Result
#   "1"	     	  "2"  ->  "2"
#   "1: www"    "2"  ->  "2: www"
#   "www"       "2"  ->  "2: www"
#   "www"       ""   ->  "www"
#   "1: www"    "1"  ->  "www"
#   "1: www"    ""   ->  "www"
#   "1"         ""   ->  "$(new name from prompt)"
function renameWs() {
	local oldWsName=$1
	local newNumForWs=$2
	local newNameForWs=$newNumForWs

	# if old workspace name was only numeric
	if echo $oldWsName | grep -E '^[0-9]+$' &>/dev/null; then
		# and there is no number for the new name
		if [[ -z $newNumForWs ]]; then
			# then prompt for a new name for that workspace
			newNameForWs=$(rofi -l 0 -dmenu -P "enter name for workspace \"$oldWsName\"")
		# if the newNumForWs is the same as the oldWsName name
		elif [[ $oldWsName -eq $newNumForWs ]]; then
			# then exit and do nothing
			return
		fi
	else
		# parse the number and name component out of the old ws name
		oldWsNum=$(echo $oldWsName | sed -En 's/(^[0-9]+)(:?.*)/\1/p')
		oldWsNameStripped=$(echo $oldWsName | sed -E 's/(^[0-9]+: )(.*)/\2/')

		# if there is no new number to assign then just use the name component
		if [[ -z $newNumForWs ]]; then
			newNameForWs=$oldWsNameStripped
		# if the new number is the same as the old number
		# the action is to remove the number and only use the name component
		elif [[ $newNumForWs -eq $oldWsNum ]]; then
			newNameForWs=$oldWsNameStripped
		# otherwise prepend the new number to the name component
		else
			newNameForWs="$newNumForWs: $oldWsNameStripped"
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
focusedWs=$(echo $workspaces | jq -r '.[] | select(.focused == true).name')

#	get the number of the currently focused ws if there is one
# we will use this to swap numbers with the ws that has the number we want
numberOfFocused=$(echo $focusedWs | sed -En 's/(^[0-9]+)(:?.*)/\1/p')


# if focused is just a number then the new name will just be the numberToAssign
if echo $focusedWs | grep -E '^[0-9]+$' &>/dev/null; then
	# we need to temporarily rename the workspace in order
	# to avoid conflicts (e.g. when swapping 6 & 7, 6 can't be renamed to 7
	# while a workspace is occupying 7)
	tmpName="99"
	i3-msg "rename workspace \"$focusedWs\" to \"$tmpName\""
	focusedWs=$tmpName
fi

oldWs=$(echo $workspaces | jq -r ".[] | select(.num == $numberToAssign).name")
# if a workspace already has the number we need, we go into the flow below
if [[ $oldWs ]] && [[ "$oldWs" != "$focusedWs" ]]; then
	renameWs "$oldWs" $numberOfFocused
fi


# rename the focusedWs workspace, placing the number in front of it
renameWs "$focusedWs" $numberToAssign

