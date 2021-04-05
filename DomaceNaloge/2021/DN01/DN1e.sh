#!/bin/bash
uid=$1
user=$(getent passwd "$uid" | cut -f1 -d:)
dir=$(getent passwd "$uid" | cut -f6 -d:)
get=$(getent passwd "$uid")
shell=$(basename $get | cut -f7 -d:)

getent passwd "$uid" > /dev/null 2&>1

if [ $? -eq 0 ]; then
    echo "uid: $uid"
    echo "uporabnik: $user" 
    echo "imenik: $dir"
    echo "lupina: $shell"
    
else
    echo "prosto!"
fi

if [ "$uid" -lt 1000 ]; then
    echo "rezerviran: DA"
else
    echo "rezerviran: NE"
fi