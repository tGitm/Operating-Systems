#!/bin/bash
max=0
for el in $1/*; do
	if [ -d "$el" ]; then
		depth=$(./$0 "$el")	#izvedemo klic samega sebe z novim imenikom
		depth=$(($depth + 1))	#globino povecamo za ena
		if [ $depth -gt $max ]; then
			max=$depth	#ce je globina vecja od trenutne najvecje, jo shranimo
		fi			
	fi
done
echo $max
