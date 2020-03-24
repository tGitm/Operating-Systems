#!/bin/bash
i=1
while [ $i -le 500 ]; do
    echo $i
    i=$(expr $i + 1)
    #sleep 1
done