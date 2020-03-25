#!/bin/bash
upper=true	#Prvo besedo vedno pisemo z veliko zacetnico
for word in $*; do	#sprehodimo se cez vse besede (argumente skripte)
	if $upper; then
		word=$(echo $word | awk 'sub(".", substr(toupper($i),1,1) , $i)')	#besedi spremenimo zacetnico
	fi
	echo -n $word" "	#izpisemo besedo brez nove vrstice
	if [[ $word == *. ]]; then	#uporabimo iskanje vzorcev, da ugotovimo, ce se beseda konca s piko
		upper=true
	else
		upper=false
	fi
done

echo	#na koncu izpisemo se novo vrstico
