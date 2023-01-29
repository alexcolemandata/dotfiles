yabai -m query --windows --space \
  | jq -re "map(select(.minimized != 1)) | sort_by(.frame.y, .frame.x, .id) | reverse | nth(index(map(select(.focused == 1))) - 1).id" \
  | xargs -I{} yabai -m window --focus {}
