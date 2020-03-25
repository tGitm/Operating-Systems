#!/bin/bash
max=$1	#zapomnimo si dovoljeno dolzino
shift	#izbrisemo prvi parameter

while true; do	#zanko ponovimo vsakih 10 sekund
	for file in "$@"; do	#sprehodimo se cez vse preostale parametre
		size=$(stat -c%s "$file")	#preberemo velikost datoteke
		if [ $size -gt $max ]; then	
			cp $file $file"_old"	#ce je datoteka prevelika, jo skopiramo na novo lokacijo
			> $file	#ter staro datoteko izpraznemo
		fi
	done	
	sleep 10
done
