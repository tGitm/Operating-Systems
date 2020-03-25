#!/bin/bash
#poiscemo vse datoteke, ki vsebujejo znaka pomisljaj ali presledek
files=$(find $1 -type f -name '*-*' -o -type f -name '* *')
#nastavimo znak za locevanje polj na novo vrstico
IFS=$'\n'
#sprehodimo se cez vse vrstice (rezultate)
for file in $files; do
	#v imenu datotek zamenjamo pomisljaje in presledke s podcrtaji ter preimenujemo datoteko
	if [[ "$file" == *"-"* ]]; then
		mv "$file" "${file//-/_}"
	fi
	if [[ "$file" == *" "* ]]; then
		mv "$file" "${file// /_}"
	fi
done
