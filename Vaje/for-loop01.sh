#!/bin/bash
#pythonski for
for ((i=1; i<=500; i++)); do
    echo $i
    sleep 1 #pavza 1s, če dam brez sleep se izvede vse naenkrat
done
exit