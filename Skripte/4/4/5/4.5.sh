#!/bin/bash

#preberemo meje terminala
width=$(tput cols)
height=$(tput lines)

#dolocimo nakljucno pozicijo in hitrost
px=$(($RANDOM % $width))
py=$(($RANDOM % $height))
sx=$(($RANDOM % 2 * 2 - 1))
sy=$(($RANDOM % 2 * 2 - 1))

step=0	#stetje korakov, ki niso izrisali nove sledi
full=0	#stetje izrisane sledi
fields=()	#tabela s sledjo

echo -n -e $(tput clear)	#pobrisemo vsebino terminala

while true; do
	p=$(($py * $width + $px))	#dolocimo trenutno pozicijo v tabeli
	if [ ! -n "${fields[$p]}" ]; then
		#ce na tej poziciji se nismo bili, si jo zapomnimo, pristejemo korak in  nastavimo stevec za korake, ki niso izrisali nove sledi, na 0
		fields[$p]="x"
		step=0
		full=$(($full + 1))
		
		#kurzor premaknemo na zeljeno mesto ter izpisemo znak
		echo -e -n $(tput cup $py $px)
		echo -n "o"
	else
		#ce smo na tej poziciji ze bili, povecamo stevec za korake ki niso izrisali nove sledi in ce je bilo taksnih korakov vec kot 200, koncamo zanko
		step=$(($step + 1))
		if [ $step -gt 200 ]; then
			echo -e $(tput cup $height $width)	#premaknemo se na konec terminala
			echo "Program je zapolnil "$(($full * 100 / ($width * $height)))"% terminala"
			break
		fi
	fi
	
	#izracunamo odboje
	if [ $px -le 0 -o $px -ge $(($width - 1)) ]; then
		sx=$(($sx * -1))
	fi
	if [ $py -le 0 -o $py -ge $(($height -1)) ]; then
		sy=$(($sy * -1))
	fi
	
	#pristejemo hitrost k poziciji
	px=$(($px + $sx))
	py=$(($py + $sy))
	
	#pocakamo 0.001 sekunde
	sleep 0.001
done
