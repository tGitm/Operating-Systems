#!/bin/bash
#ime datoteke, v katero bomo shranjevali rezultate je pid programa, tako da ne bomo imeli tezav s socasnim poganjanjem vecih programov
fn=$$".log"
ip=$1
sl=$2
echo "0 0" > $fn

#program, preden se zakljuci, poklice funkcijo, ki pobrise datoteko ter konca vse podprocese
function myexit() {
	rm $fn
	kill $(jobs -p)	#ustavimo vse podprograme
}

trap 'myexit' EXIT

#v ozadju pozenemo neskoncno zanko, ki shranjuje rezultate ukaza ping v datoteko
while true; do
	num=($(cat $fn))	#preberemo datoteko ter jo shranimo v tabelo
	ping -c 1 $ip > /dev/null	#pozenemo ukaz ping ter zavrzemo rezultat, ker bomo potrebovali le izhodni status ukaza
		
	num[0]=$((${num[0]} + 1))	#povecamo stevilo vseh poskusov
	num[1]=$((${num[1]} + (1 - $?)))	#ce je izhodni status ukaza ping enak 0 (ping je uspel), bomo rezultatu pristeli 1, ce je status enak 1, pa bomo pristeli 0
	echo ${num[@]} > $fn	#novo stevilo shranimo v datoteko
	sleep $sl
done &

#v neskoncni zanki cakamo na uporabnikov ukaz
while true; do
	read -s -n 1 char	#tiho beremo znake
	if [ "$char" == "r" ]; then	#ce je znak enak r, izpisemo rezultat
	
		num=($(cat $fn))
		#ker bash ne pozna decimalnih stevil, bomo stevilo uspesnih poskusov pomnozili z 10000 ter sami premaknili decimalno vejico
		perc=$((${num[1]} * 100000 / ${num[0]}))
		perc=$(echo $perc | rev)
		perc=${perc:0:3}","${perc:3}
		perc=$(echo $perc | rev)
		#na koncu se izpisemo rezultat
		echo ${num[1]}" / "${num[0]}": "$perc"%"
	fi
done
