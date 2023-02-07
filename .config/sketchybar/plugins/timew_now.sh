#!/bin/sh

timew_now() {
    timew_status=$(timew)

    if [ $? -eq 0 ]
    then
        timer=$(echo "$timew_status" | sed '4q;d' | cut -w -f 3)

        h=$(echo $timer | cut -d ':' -f 1)
        m=$(echo $timer | cut -d ':' -f 2 | sed 's/^0//')'m'

        if [ $h -gt 0 ]
        then
            h=$(echo $h | sed 's/^0//' )'h '
        else
            h=''
        fi

        tags=$(echo "$timew_status" | sed '1q;d' | sed 's/^Tracking //g')

        if [ ${#tags} -gt 0 ]
        then
            tags="[$tags]"
        fi

        echo $h$m $tags
    else
        echo '鈴'
    fi
}

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting
sketchybar --set $NAME label="$(timew_now)"
