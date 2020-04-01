#!/bin/bash
imenik1="$1"
imenik2="$2"
#$(find $imenik1 -type d) > dat.txt

if [[ "$imenik2" != '' ]]; then
    cd "$imenik1" && find . -type d -exec mkdir -p -- "$imenik2"{} \;
    echo find . -type d
    if [ $? -eq 0 ];then
        ln -s "$imenik1" "škorenj"
    else
        exit 21
    fi

    exit 0
else
    exit 21
fi