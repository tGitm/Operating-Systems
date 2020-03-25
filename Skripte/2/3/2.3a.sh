#!/bin/bash
max=0
function depth() {
	if [ $2 -gt $max ]; then	
		max=$2	 #ce se trenutno nahajamo globlje, kot je trenutni max, ga prepisemo
	fi
	for el in $1/*; do	#sprehodimo po imeniku, ki je podan kot parameter
		if [ -d "$el" ]; then	
			depth "$el" $(($2 + 1))	#ce smo v imeniku, rekurzivno klicemo z novo potjo in globino+1
		fi
	done
}
depth "$1" 0
echo $max
