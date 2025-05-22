#!/bin/bash

marked_pane="$(tmux list-panes -aF '#{pane_id} #{pane_marked}' | awk '$2 == "1" {print $1}')"
tmux switch-client -t "${marked_pane}"

