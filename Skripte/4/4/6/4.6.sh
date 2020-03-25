#!/bin/bash
width=$2
height=$3
#izracunamo stevilo tock, ki jih bomo racunali za vsak stolpec rastrske slike
step=$(echo "scale=0; $width * $6 / ($5 - $4)" | bc -q)
#pomnozimo zacetno in koncno vrednost r-ja s stevilom korakov, tako da dobimo celo stevilo
start=$(echo "scale=0; $4 * $step / 1" | bc -q)
stop=$(echo "scale=0; $5 * $step / 1" | bc -q)

#pripravimo si tabelo za tocke
map=()

#nastavimo zacetno vrednost spremenljivke x na 0.5
x='0.5'
for ((r=$start;r<$stop;r++)); do
	#izracunamo naslednjo vrednost x-a
	nx="$x * ($r / $step) * (1 - $x)"
	x=$(echo "scale=10; $nx" | bc -q)
	
	#pretvorimo vrednosti v pozicije na sliki
	px=$(echo "scale=0; $width * ($r - $start) / ($stop - $start)" | bc -q)
	py=$(echo "scale=0; $x * $height / 1" | bc -q)
	
	#pretvorimo koordinati x in y v enodimenzionalni prostor (za PGM)
	p=$(($py * $width + $px))
	#shranimo tocko na sliki
	map[$p]="x"
done

#ker je izpis vrstic v datoteko zahteven postopek, si sliko zacasno shranimo v pomnilnik in s tem pohitrimo zapisovanje
fn="/dev/shm/"$1

#izpisemo glavo slike
echo "P2" > $fn
echo "$width $height" >> $fn
echo "1" >> $fn

#izpisemo tocke
for ((i=0;i<$(($width * $height));i++)); do
	if [ -n "${map[$i]}" ]; then
		#ce ima tabela na poziciji i vrednost, bomo na tem mestu sliko obarvali crno
		echo "0" >> $fn
	else
		echo "1" >> $fn
	fi
done
#premaknemo sliko iz pomnilnika v trenutni imenik
mv $fn $1
