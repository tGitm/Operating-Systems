#!/bin/bash
folder=""
for cmd in $@; do	#sprehodimo se cez argumente
	if [ "$cmd" == "[" ]; then	#pri argumentu [ bomo vstopili v imenik
		if [ -n "$folder" -a -e "$folder" ]; then	#preverimo ce obstajata ime (-n) in (-a) mapa (-e)
			cd "$folder"	#stopimo v imenik
		else
			echo "error"
			break
		fi
	elif [ "$cmd" == "]" ]; then	#ko zakljucimo s trenutnim imenikom
		cd ..	#se vrnemo en nivo navzgor
	else
		folder="$cmd"	#kadar je argument ime imenika, ga shranimo
		mkdir "$folder"	#in ustvarimo imenik
	fi
done
