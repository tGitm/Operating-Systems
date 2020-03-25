#!/bin/bash
interval=$2
log=$(cat "$1") #preberemo datoteko

dates=()

#iz datoteke preberemo le case in jih shranimo v tabelo
IFS=$'\n'
for line in $log; do
	date=$(echo "$line" | awk -F'[' '{print $NF}' | awk -F']' '{print $1}')
	#ker streznik Apache izpisuje case v nenavadnem formatu, bomo obliko rahlo predelali
	date=${date//'/'/' '}
	date=${date/':'/' '}
	
	#casovni niz pretvorimo v stevilo potecenih sekund od 1.1.1970
	date=$(date -d "$date" +%s)
	
	dates[${#dates[@]}]=$date
done

start=0
stop=0

max=-1

#sprehodimo se cez vse zapise v dnevniku
for ((;start<${#dates[@]};start++)); do
	startdate=${dates[$start]}
	
	#ter za vsak zapis poiscemo tistega, ki je najvec N sekund oddaljen
	for ((;$stop<${#dates[@]};stop++)); do
		stopdate=${dates[$stop]}
		if [ $(($stopdate - $startdate)) -ge $interval ]; then
			break
		fi
	done
	
	#izracunamo stevilo zapisov v intervalu
	freq=$(($stop - $start))
	if [ $max -eq -1 -o $max -lt $freq ]; then
		max=$freq
	fi
	
done

echo $max" / "$interval"sec"
