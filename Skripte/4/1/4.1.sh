#!/bin/bash
if [ ${#@} -gt 0 ]; then	#preverimo stevilo argumentov
	> out	#pobrisemo vsebino datoteke
	for file in $@; do	#sprehodimo se cez vse argumente
		if [ -e $file ]; then	#preverimo, ce datoteka obstaja
			echo "#file: $file" >> out	#v datoteko "out" dodamo niz, ki bo loceval datoteke
			cat $file >> out	#vsebino datoteke pripnemo datoteki "out"
		fi
	done
else
	fileName=""
	while read line; do	#vhod beremo po vrsticah
		if [[ "$line" == \#file* ]]; then	#preverimo, ce smo v vrstici z locevalnim nizom
			fileName=$(echo "$line" | awk '{ print $2 }')	#iz niza izlocimo ime datoteke
			> $fileName
		else
			if [ -n "$fileName" ]; then	#ce imamo na voljo ime datoteke
				echo "$line" >> $fileName	#vanjo dodamo trenutno vrstico
			fi
		fi
	done < out	#na standardni vhod preusmerimo datoteko out
fi
