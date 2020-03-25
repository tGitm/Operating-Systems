#!/bin/bash
width=$(tput cols)	#preberemo sirino terminala
height=$1
max=$(free -m | tail -n +2 | head -n 1 | awk '{print $2}')	#preberemo celotno kolicino pomnilnika
#inicializiramo tabelo, v kateri bomo hranili zasedenost pomnilnika
values=()
for ((i=0;i<width;i++)); do
	values[$i]=0
done

#funkcija za branje ter dodajanje novih vrednosti v tabelo zasedenosti
function newValue() {
	#preberemo, izracunamo ter shranimo kolicino prostega pomnilnika
	ram=($(free -m | tail -n +2 | head -n 1 | awk '{print $2" "$4" "$6" "$7}'))
	ram=$((${ram[0]} - ${ram[1]} - ${ram[2]} - ${ram[3]}))
	values[$width]=$ram
	#tabelo zamaknemo v levo
	for ((i=1;i<=width;i++)); do
		values[$i - 1]=${values[$i]}
	done
	
	return 1
}

while true; do
	#poklicemo funkcijo za dodajanje novih vrednosti
	newValue
	
	#sprehodimo se po vrsticah
	for ((i=height;i>=0;i--)); do	
		#v vsaki se sprehodimo cez vse stolpce
		for ((j=0;j<width;j++)); do
			ram=$((${values[$j]} * $height / $max))
			#ce je relativna poraba pomnilnika vecja od trenutne vrstice
			if [ $ram -gt $i ]; then
				echo -n "*"	#izpisemo zvezdico
			else
				echo -n " " #v nasprotnem primeru pa presledek
			fi
		done
	done
	echo #na koncu izpisemo se eno prazno vrstico

	sleep $2	#pocakamo N sekund
	echo -e -n "\033["$(($height + 1))"A"	#premaknemo se za M + 1 vrstic navzgor
done
