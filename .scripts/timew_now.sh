timew_now() {
    timew_status=$(timew)

    if [ $? -eq 0 ]
    then
        timer=$(echo "$timew_status" | sed '4q;d' | cut -w -f 3)

        h=$(echo $timer | cut -d ':' -f 1)
        m=$(echo $timer | cut -d ':' -f 2)
        s=$(echo $timer | cut -d ':' -f 2)'s'


        if [ $h -gt 0 ]
        then
            h=$h'h '
            m=$m'm '
        else
            h=''

            if [ $m -gt 0 ]
            then
                m=$m'm '
            else
                m=''
            fi
        fi


        tags=$(echo "$timew_status" | sed '1q;d' | sed 's/^Tracking //g')

        if [ ${#tags} -gt 0 ]
        then
            tags="[$tags]"
        fi

        echo $h$m$s $tags
    else
        echo 'Not tracking'
    fi
}

timew_now
