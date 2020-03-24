#!/bin/bash -x
i=1
while $(seq 1 500); do
    echo $i
    i=$(($i+1))
    sleep 1
done
exit