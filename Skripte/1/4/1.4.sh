#!/bin/bash
files=$(find $1 -type f)	#poiscemo vse datoteke
IFS=$'\n'	#nastavimo znak za locevanje polj na novo vrstico
for file in $files; do	#sprehodimo se cez vse vrstice oz. rezultate
	name=$(basename $file) #preberemo ime datoteke brez poti
	date=$(stat -c %y $file | awk '{print $1}')	\#preberemo in izlocimo datum zadnje spremembe datoteke
	datename=$date"_"$name
	mv "$file" "${file/%$name/$datename}"	\#preimenujemo datoteko
done
