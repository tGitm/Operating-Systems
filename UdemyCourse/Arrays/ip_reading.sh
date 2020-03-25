#!/bin/bash
#program prebere ip hosta ločeno z presldkom in pove, če deluje ali ne

echo "Vnesi Ip-je ločeno z presledki:"
read -a naslovi

for i in ${naslovi[@]}; do
    echo "-----------------------------------"
    ping -c 1 -w 3 $i 2>$1 >/dev/null
    if [ $? -eq 0 ]; then
        echo "Host $i deluje!"
    else 
        echo "Host $i ne deluje!"
    fi
done