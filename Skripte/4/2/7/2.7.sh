#!/bin/bash
#prestejemo procesorska jedra
cpucount=$(cat /proc/cpuinfo | grep processor | wc -l)

while true; do
	#preberemo obremenitev
	load=$(uptime | awk '{print $10}')
	#odstranimo vejico
	load=${load/","/""}
	#za primerjanje odstranimo se decimalno piko, saj bash ne pozna decimalnih stevil
	loadd=${load/"."/""}
	
	#obarvamo izpis
	if [ $loadd -gt $(($cpucount * 80)) ]; then
		echo -e -n "\033[0;31m"
	elif [ $loadd -gt $(($cpucount * 50)) ]; then
		echo -e -n "\033[0;32m"
	else
		echo -e -n "\033[0;34m"
	fi
	
	echo -n $load 
	
	#ponastavimo barvo
	echo -e "\033[0m"
	sleep 10
done
