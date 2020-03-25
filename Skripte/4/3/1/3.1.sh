#!/bin/bash
sum=""
count=0
while true; do
	newSum=$(md5sum $1 | awk '{ print $1 }')	#pozenemo md5sum ter iz rezultata izlocimo hash
	if [ "$sum" != "$newSum" ]; then
		count=$(($count + 1))
		tar -zcf $1"-"$count".tar.gz" $1	#arhiviramo datoteko v skaldu z dogovorjenim imenom
		sum=$newSum
	fi
	sleep 10
done
