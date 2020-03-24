#!/bin/bash
x="$1"
if [ "$#" -eq 0 ]; then
    echo "Nisi podal argumenta!"
else    
    if [ "$x" -ge 10 ]; then
        while [ "$x" -gt 1 ]; do
            x=$(expr $x-1)
            echo "$x"
        done
    else
        echo "Število ni večje ali enako 10!"    
    fi
fi    
exit