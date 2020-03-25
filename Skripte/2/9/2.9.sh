#!/bin/bash
out="o" #krogec postavimo na zacetek vrstice
echo -n -e $out
while read -s -n 1 ch; do	#tiho beremo vhod znak za znakom
	if [ $ch == "d" ]; then
		out=" "$out	#krogec pomaknemo desno
		echo -e -n "\r$out"	#prepisemo vrstico
	elif [ $ch == "a" ]; then
		if [ ${#out} -gt 1 ]; then
			out=${out:1}	#krogec pomaknemo levo
			echo -e -n "\r$out "
		fi
	elif [ $ch == "s" ]; then
		echo -e -n "\n$out"	#izpisemo novo vrstico
	fi
done
