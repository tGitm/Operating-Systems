#!/bin/bash

izpis=$(cat /etc/passwd | awk -F':' '{print $1}') 

for i in ${izpis[@]}; do
    echo "Username is bss_${i}"
done