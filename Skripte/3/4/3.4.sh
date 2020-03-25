#!/bin/bash
freq=()	#inicializiramo tabelo za pogostost posameznih znakov
while read -n1 char; do	#preberemo datoteko po znakih
	code=$(printf '%d' "'$char")	#preberemo njegovo ASCII-kodo
	if [ $code -gt 64 -a $code -lt 91 -o $code -gt 96 -a $code -lt 123 ]; then	#preverimo ce je znak crka (med a in z ali med A in Z)
		freq[$code]=$((freq[$code] + 1))	#ter povecamo stevec na indeksu znaka
	fi
done < $1

str=""	#pripravimo spremenljivko za sortiranje in izpis
for ((i=65;i<123;i++)); do
	if [ ${freq[$i]} ]; then	#ce znak obstaja
		char=$(printf \\$(printf %o $i))	#njegovo kodo pretvorimo v znak
		str=$str${freq[$i]}"\t"$char"\n"	#ter dodamo novo vrstico za izpis
	fi
done

#vrstice izpisemo z upostevanjem posebnih znakov, nato jih numericno sortiramo in izpisemo prvih 5
echo -e $str | sort -n -r | head -n 5
