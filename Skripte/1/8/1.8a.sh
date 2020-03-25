#!/bin/bash
files=$(find $1 -name $2 -type f)	#poiscemo datoteke
for file in $files; do	#sprehodimo se cez vse najdene datoteke
	if [ -n "$(grep $3 $file)" ]; then	
		echo $file	#ce niz, ki ga vrne program grep ni prazen, izpisemo ime
	fi
done
