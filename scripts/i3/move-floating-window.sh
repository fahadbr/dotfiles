#!/bin/bash


set -e
focusedWs=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused == true).name')
export IFS=$'\n'

top_level_wins="$(i3-msg -t get_tree | jq -r -c '(.nodes[].nodes[].nodes[]) | select(.name == "'$focusedWs'").floating_nodes[] | @base64')"

_get_focused_floating() {
	local windows="$1"

	if [ -z "$windows" ]
	then
		return
	fi

	for w in "$windows"
	do
		w_decoded=$(echo $w | base64 -d)
		is_focused=$(echo "$w_decoded" | jq -r -c '.focused')
		if [ "$is_focused" == "true" ]
		then
			echo $w_decoded
			return
		fi

		nodes=$(echo $w_decoded | jq -c -r '.nodes[] | @base64')
		_get_focused_floating "$nodes"
	done
}

_get_focused_floating "$top_level_wins"
#id=$(_get_focused_floating $top_level_wins)

