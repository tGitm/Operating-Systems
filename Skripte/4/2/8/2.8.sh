#!/bin/bash
#ce datoteka key ne obstaja, jo ustvarimo
if [ ! -f ./key ]; then
	touch ./key
	#zgeneriramo 32 nakljucnih stevil v sestnajstiskem sistemu ter jih zapisemo v datoteko
	for i in {1..32}; do
		printf "%x" $(($RANDOM % 16)) >> ./key
	done
fi
#preberemo zgenerirano geslo
seed=$(cat key)
read -s -p "Globalno geslo: " pass; echo #preberemo geslo
read -p "Ime spletne strani: " site	#preberemo spletno stran

#zgeneriramo zgoscen zapis gesla po md5
sitepass=$(echo $seed"_"$pass"_"$site | md5sum | awk '{print $1}')

#geslo izpisemo
echo "Geslo za spletno stran "$site" je: "$sitepass
