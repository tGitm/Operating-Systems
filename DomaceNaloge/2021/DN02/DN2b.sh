#!/bin/bash

while true
do
    echo -n "Vnesite ime ukaza: "
    read input
    if [[ $(type -at $input) != "" ]]; then
        if [[ $(type -at "$input") == "builtin" ]]; then
            echo "VGRAJEN"
        elif [[ $(type -at "$input") == "file" ]]; then
            echo "nevgrajen"
        else
            echo "ObOjE"
        fi
    fi
done