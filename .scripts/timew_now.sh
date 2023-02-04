timew_now() {
    timew_status=$(timew)

    if [ $? -eq 0 ]
    then
        timer=$(echo "$timew_status" | sed '4q;d' | cut -w -f 3)
        tags=$(echo "$timew_status" | sed '1q;d' | sed 's/^Tracking //g')

        if [ ${#tags} -gt 0 ]
        then
            tags="[$tags]"
        fi

        echo  $timer $tags
    else
        echo ''
    fi
}

timew_now
