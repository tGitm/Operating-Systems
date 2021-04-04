#!/bin/bash
size=0
datoteka=$1

while read line; do
    if [ -f "$line" ]; then
        $size+=$(wc -c <"$line")
    else
        echo "Napaka v inventarju!" >&1
        exit 10
    fi
done < $datoteka

#izpis velikosti
echo $size B >&1