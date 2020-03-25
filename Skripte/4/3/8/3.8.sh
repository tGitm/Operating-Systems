#!/bin/bash
fn=$1
files=$(find $2 -type f)

mindiff=-1
mindiffFile=""

IFS=$'\n'	#polja locimo po novih vrsticah
for file in ${files[@]}; do
	diff=0
	diffTxt=$(diff "$fn" "$file")
	for line in ${diffTxt[@]}; do
		if [[ "$line" == ">"* ]] || [[ "$line" == "<"* ]]; then
			#ce se izhod zacne z > ali <, stejemo kot spremembo
			diff=$(($diff + 1))
		fi
	done
	if [ $mindiff -eq -1 -o $diff -lt $mindiff ]; then
		#ce je primerjava prva ali pa je razlika manjsa od doslej najmanjse, si shranimo novo najbolj podobno datoteko
		mindiff=$diff
		mindiffFile=$file
	fi
done

echo $mindiffFile" "$mindiff
