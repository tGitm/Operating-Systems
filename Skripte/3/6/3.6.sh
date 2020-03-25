#!/bin/bash
#ustvarimo seznam vseh datotek v podanem imeniku
find $1 -type f > old.log

#nastavimo znak za locevanje na novo vrstico
IFS=$'\n'
while true; do
	sleep 60
	#ustvarimo nov seznam vseh datotek
	find $1 -type f > new.log
	
	#poklicemo ukaz diff ter se sprehodimo cez rezultate
	for line in $(diff old.log new.log); do
		if [[ "$line" == ">"* ]]; then
			#ce se je vrstica zacela z >, to pomeni, da je v seznamu nova vrstica (torej dodana datoteka)
			echo -e "ustvarjena: "${line:2}
		elif [[ "$line" == "<"* ]]; then
			#ce se je vrstica zacela z <, to pomeni, da je v seznamu izginila ena vrstica (torej je nekdo odstranil datoteko)
			echo -e "izbrisana: "${line:2}
		fi
	done
	
	#cez star seznam prepisemo nov seznam
	mv new.log old.log
done
