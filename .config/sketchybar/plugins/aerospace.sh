#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/aerospace_convert_displayid.sh"

sid=$1

if [[ -z "$FOCUSED_WORKSPACE" && "$sid" == "1" ]]; then
	sketchybar --set "$NAME" background.drawing=on
elif [[ "$sid" == "$FOCUSED_WORKSPACE" ]]; then
	sketchybar --set "$NAME" background.drawing=on
else
	sketchybar --set "$NAME" background.drawing=off
fi

json_data=$(aerospace list-windows --workspace "$sid" --json)

# summary of apps in workspace
short_app_string=$(
	echo "$json_data" |
		jq -r '.[] | .["app-name"]' |
		sort -r |
		uniq -c |
		awk '{print $2 "(" $1 ")"} ' |
		tr '\n' ' '
)

# per application with window names
long_app_string=$(echo "$json_data" | jq -r '
    group_by(.["app-name"])[] | 
    "[\(.[0]["app-name"]): \"\([.[]."window-title"] | join("\" \""))\"]"
' | tr '\n' ' ')

#label="$short_app_string"
label="$short_app_string $long_app_string"

display=$(convert_aerospace_display_id "$(get_display_num_for_workspace_name "$sid")")

sketchybar --set "$NAME" display="$display" label="$label"
