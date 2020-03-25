#!/bin/bash
path=$1	#shranimo si pot do imenika
shift	#izbrisemo/zamaknemo prvi argument
#pripravimo si potrebne spremenljivke
origin=()	#obstojece koncnice
replace=()	#zamenjave
cmd=""	#za hranjenje stikala

while (( "$#" )); do
	if [[ $1 == -* ]]; then	#ce se argument zacne z -
		cmd=$1	#stikalo katerega argumente prejemamo
	elif [ $cmd == "-origin" ]; then	#ce imamo stikalo -origin
		origin=(${origin[@]-} "$1")	#si shranimo argumente v primerno tabelo
	elif [ $cmd == "-replace" ]; then	#enako storimo za argumente replace
		replace=(${replace[@]-} "$1")
	fi
	
	shift	#zamaknemo argumente
done
#preverimo ustreznost vhodnih podatkov (neobvezno)
if [ ${#origin[@]} -eq 0 -o ${#replace[@]} -eq 0 ]; then
	echo "error"
	exit 1
fi

if [ ${#origin[@]} -ne ${#replace[@]} -a ${#replace[@]} -ne 1 ]; then
	echo "error"
	exit 2
fi

count=0	#nastavimo stevec
for ((i=0;i<${#origin[@]};i++)); do	#sprehodimo se cez vse indekse v tabeli origin
	ext=${origin[$i]}	#shranimo si trenutno koncnico
	newext=${replace[0]}	#shranimo si zeljeno koncnico
	if [ ${#replace[@]} -gt 1 ]; then	#ce je ciljnih koncnic vec
		newext=${replace[$i]}	#vzmamemo tisto, ki je na istolezni poziciji
	fi
	files=$(find $path -name "*."$ext -type f)	#poiscemo vse datoteke z zeljeno koncnico
	for file in ${files[*]}; do	#sprehodimo se cez vse datoteke
		woext=${file%.$ext} #iz imena datoteke izbrisemo koncnico
		mv $file $woext"."$newext	#preimenujemo datoteko
		count=$(($count + 1))
	done
done
echo $count
