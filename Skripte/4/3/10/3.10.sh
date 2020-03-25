#!/bin/bash
count=0
#shranimo si cas zacetka izvajanja (v sekundah od 1.1.1970)
start=$(date +%s)

#sledimo datoteki in jo beremo po vrsticah; dokler ni novega vpisa v datoteko, zanka miruje 
tail -n 0 -f $1 | while read msg; do
	time=$(date +%s)
	interval=$(($time - $start))
	#ce je preteklo dovolj casa
	if [ $interval -gt $2 ]; then
		
		#izpisemo pogostost na 2 decimalni mesti natancno
		echo $(echo "scale=2; $count / $interval" | bc -q)" / sec"
		
		start=$time
		count=0
	fi
	count=$(($count + 1))
done
