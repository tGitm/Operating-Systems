#!/bin/bash
count=0
while read line; do
	if [ $count -ge $2 ]; then
		#ko je stevec vrstic vecji ali enak zeljenemu koncu izstopimo iz zanke
		break
	fi	
	if [ $count -ge $1 ]; then
		#ce je stevec vecji ali enak zeljenemu zacetku izpisovanja izpisemo vrstico
		echo $line
	fi
	count=$(($count + 1))	#povecamo stevec
done < $3	#ime vhodne datoteke za branje imamo dobimo v tretjem argumentu
