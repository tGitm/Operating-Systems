#!/bin/bash
limits=($(head -n 1 $1))	#preberemo meje
domains=$(tail -n +2 $1)	#ter domenska imena
#pripravimo si tabele za izpis domenskih imen
urgent=()
warning=()
#shranimo si danasnji datum v obliki stevila dni od leta 1.1.1970
today=$(date +%s)
today=$(($today / (60 * 60 * 24)))
for domain in ${domains[@]}; do
	whois=$(whois $domain)	#preberemo podatke o domeni
	#iscemo vec nacinov izpisa datuma, ko bo domensko ime poteklo
	date=$(echo "$whois" | grep "Expiration Date")
	if [ ! -n "$date" ]; then
		date=$(echo "$whois" | grep "Renewal date")
	fi
	if [ ! -n "$date" ]; then
		date=$(echo "$whois" | grep "expire")
	fi
	if [ -n "$date" ]; then
		#ce smo podatke nasli, iz njih izlocimo datum
		date=$(echo $date | awk -F':' '{print $2}')	
		#ga prevedemo na stevilo dni od leta 1.1.1970
		date=$(date -d "$date" +%s)
		date=$(($date / (60 * 60 * 24)))	
		#ter od njega odstejemo danasnji dan
		left=$(($date - $today))	
		#ce datum poteka ustreza meji, si domeno shranimo v ustrezno tabelo
		if [ $left -lt ${limits[1]} ]; then
			urgent[${#urgent[@]}]=$domain
		elif [ $left -lt ${limits[0]} ]; then
			warning[${#warning[@]}]=$domain
		fi
	else
		#ce podatkov nismo dobili, izpisemo napako
		echo "error on "$domain
	fi
done
#izpisemo urgentna in navadna opozorila
echo "Urgentno:"
for domain in ${urgent[@]}; do
	echo -e "  $domain"
done
echo "Opozorilo:"
for domain in ${warning[@]}; do
	echo -e "  $domain"
done
