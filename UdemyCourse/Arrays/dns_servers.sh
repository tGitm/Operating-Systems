#!/bin/bash
dns_server=("cpl.google", "rus.home", "tim.lj")
dolzina=${#dns_server[@]}

echo "Vseh dns strežnikov je: $dolzina"

for ((i=0; i<$dolzina; i++)); do
    echo "${dns_server[$i]}"
done
