#!/bin/bash
#preberemo sliko in odstranimo vrstice s komentarji
img=$(cat $1 | grep -e "^[^#]")
#v drugi vrstici se nahaja velikost slike
size=($(echo "$img" | sed -n 2p))
#v tretji pa stevilo odtenkov sive barve
max=$(echo "$img" | sed -n 3p)
#tocke slike se nahajajo od tretje vrstice naprej
img=$(echo "$img" | tail -n +4)
shift #zamaknemo argumente
gray=(" " ${@}) #in ostale argumente (nabor znakov) skupaj s presledkom shranimo v tabelo
n=${#gray[@]}

idx=1
for pix in $img; do
	#izracunamo pozicijo sivine v tabeli
	pos=$(( ($max - $pix) * ($n - 1) / $max))
	echo -n "${gray[$pos]} "	#izpisemo ustrezen znak
	if [ $(($idx % ${size[0]})) -eq 0 ]; then
		#ce se nahajamo na koncu vrstice, izpisemo novo vrstico
		echo
	fi
	idx=$(($idx + 1))
done
