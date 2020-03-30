#!/bin/bash
inputFile=$1
outputFIle=$2
sorted=$(sort "$inputFile" | uniq -c | sort -k 2)
if [ "$2" == '' ]; then
    echo "$sorted"
else
    echo "$sorted" > "$outputFIle"
fi
exit