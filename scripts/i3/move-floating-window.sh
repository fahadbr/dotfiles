#!/bin/bash


focusedWs=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused == true).name')
export IFS=$'\n'

top_level_wins="$(i3-msg -t get_tree | jq -c -r '(.nodes[].nodes[].nodes[]) | select(.name == "'$focusedWs'").floating_nodes[]')"

_get_focused_floating() {
	local windows="$1"

	if [ -z "$windows" ]
	then
		return
	fi

	for w in "$windows"
	do
		is_focused=$(echo $w | jq -r '.focused')
		set -x
		if [ "$is_focused" == "true" ]
		then
			echo $w
			return
		fi
		set +x

		nodes=$(echo $w | jq '.nodes[]')
		_get_focused_floating "$nodes"
	done
}

_get_focused_floating "$top_level_wins"
#id=$(_get_focused_floating $top_level_wins)

