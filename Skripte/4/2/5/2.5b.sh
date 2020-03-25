#!/bin/bash
exec 200>test.LCK
flock -x 200
echo "0" > test.txt
