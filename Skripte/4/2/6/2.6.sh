#!/bin/bash
i=0
prev=""
count=1
max=1
while read -n1 ch; do	#beremo /dev/urandom po znakih (bajtih)
	if [ "$ch" == "$prev" ]; then
		count=$(($count + 1))	#ce sta zaporedna znaka enaka, povecamo stevec
	else
		if [ $count -gt $max ]; then
			max=$count	#ce je trenutno zaporedje daljse od najdaljsega, shranimo novega
		fi
		count=1	#ponastavimo stevec
		prev=$ch	#shranimo znak
	fi
	
	i=$((i + 1))
	if [ $i -gt $1 ]; then
		break	#ustavimo zanko, ko prekoracimo zeljeno dolzino
	fi
done < /dev/urandom

echo $max	#izpisemo dolzino zaporedja 
echo "1:"$((256 ** ($max - 1)))	#in verjetnost
