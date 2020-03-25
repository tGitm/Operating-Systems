#!/bin/bash
dict=$(cat $1)

function isunique {
	word=""
	for w in $dict; do
		#preverimo, ce se iskana beseda ujema z besedo v slovarju
		if [[ $w == $1* ]]; then
			#ce to ni prva najdena beseda, spraznemo najdeno besedo in koncamo zanko
			if [ $word ]; then
				word=""
				break
			fi
			word=$w
		fi
	done

	echo $word
}

while read line; do	#beremo vrstice iz vhoda
	match=$(isunique $line)	#poiscemo besedo
	if [ $match ]; then	#ce beseda ni prazna jo izpisemo in koncamo program
		echo $match
		exit 1
	fi
done
