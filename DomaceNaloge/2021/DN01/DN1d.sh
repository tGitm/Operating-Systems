#!/bin/bash
size=0
datoteka=$1

while read line; do
    if [ -f "$line" ]; then
        getSize=$(wc -c <"$line")
        size=$(($size+$getSize))
    else
        echo "Napaka v inventarju!" >&1
        exit 10 #nastavim izhodni status 10
    fi
done < $datoteka

#izpis velikosti
echo $size B >&1S