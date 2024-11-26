#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

get_display_num_for_workspace_name() {
	local target_workspace="$1"
	for as_monitor_id in $(aerospace list-monitors --format '%{monitor-id}'); do
		for as_workspace_name in $(aerospace list-workspaces --monitor "$as_monitor_id"); do
			if [[ "$as_workspace_name" == "$target_workspace" ]]; then
				echo "$as_monitor_id"
				return 0
			fi
		done
	done
}

convert_aerospace_display_id() {
	local as_id="$1"

	local num_monitors
	local as_main_id
	local as_second_id

	# get_display_num_for_workspace_name is expensive - trying to minmise calls
	# by checking num monitors first
	num_monitors="$(aerospace list-monitors --count)"
	if [[ "$num_monitors" == 1 ]]; then
		echo 1
		return 0
	fi

	# workspace 1 is always on main display
	# sketchybar main is always 1
	as_main_id="$(get_display_num_for_workspace_name 1)"
	if [[ "$as_id" == "$as_main_id" ]]; then
		echo 1
		return 0
	fi

	if [[ "$num_monitors" == 2 ]]; then
		# if only 2 monitors and haven't returned can shortcut here
		echo 2
		return 0
	fi

	# workspace 2 is pinned to secondary display
	as_second_id="$(get_display_num_for_workspace_name 2)"
	if [[ "$as_id" == "$as_second_id" ]]; then
		echo 2
		return 0
	fi

	echo 3 # only assuming max 3 monitors
	return 0
}
