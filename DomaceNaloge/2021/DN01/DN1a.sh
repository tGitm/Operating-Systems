#!/bin/bash

#loop skozi vse argumente
for arg in "$@" 
do
    if [[ -e "$arg" && ! -d "$arg" ]]; then #pogoj: če obstaja in ni direktorij
        echo -n 1 "" >&1
    else
        echo -n 0 "" >&1
    fi
done
exit