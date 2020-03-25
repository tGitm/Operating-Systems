#!/bin/bash
#preberemo vse procese, odstranimo glavo, izlocimo stolpca user in pid ter procese sortiramo, tako da bodo pocesi od istega uporabnika skupaj
proc=$(ps aux | tail -n +2 | awk '{print $1" "$2}' | sort)
user=""
memory=0
sum=0

IFS=$'\n'	#nastavimo znak za locevanje na novo vrstico
for line in $proc; do
	usr=${line% *}	#preberemo uporabnika
	pid=${line#* }	#preberemo pid
	
	if [ "$usr" != "$user" ]; then	#ce se je uporabnik spremenil
		if [ $memory -gt 0 ]; then
			#izpisemo njegove podatke, ce je poraba pomnilnika vecja od 0
			echo $user": "$(($memory / 1000))" MB"
		fi
		#nastavimo na naslednjega uporabnika
		user=$usr
		memory=0
	fi
	
	#preberemo podatke o porabi pomnilnika ter izlocimo le stevilko
	mem=$(pmap $pid | tail -n 1 | awk '{print substr($2,0,length($2) - 1)}')
	if [ $mem -gt 0 2>/dev/null ]; then
		#pristejemo porabo, ce je ta vecja od nic; pri tem zavrzemo napake
		memory=$(($memory + $mem))
		sum=$(($sum + $mem))
	fi
done
echo "skupaj: "$(($sum / 1000))" MB"
