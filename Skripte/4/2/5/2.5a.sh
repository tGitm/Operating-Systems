#!/bin/bash
#datotecni deskriptor 200 povezemo na datoteko test.LCK
exec 200>test.LCK

echo "0" > test.txt

while true; do
	#zaklenemo datoteko
	flock -x 200
	val=$(cat test.txt | tail -n 1)
	sleep 1
	echo $(($val + 1)) >> test.txt
	#odklenemo datoteko
	flock -u 200
done
