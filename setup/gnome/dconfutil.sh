#!/bin/bash

declare -A filemap
filemap[gtile]='/org/gnome/shell/extensions/gtile/'
filemap[keybindings_shell]='/org/gnome/shell/keybindings/'
filemap[keybindings_mutter]='/org/gnome/mutter/keybindings/'
filemap[keybindings_mutter_wayland]='/org/gnome/mutter/wayland/keybindings/'
filemap[keybindings_wm]='/org/gnome/desktop/wm/keybindings/'

dump() {
	for key in "${!filemap[@]}"
	do
		dconf dump "${filemap[$key]}" > "${key}-dconfdump.txt"
	done
}

load() {
	for key in "${!filemap[@]}"
	do
		<"${key}-dconfdump.txt" dconf load "${filemap[$key]}"
	done
}

case "$1" in
	dump) dump ;;
	load) load ;;
esac

