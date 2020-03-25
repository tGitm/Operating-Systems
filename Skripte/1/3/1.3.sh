#!/bin/bash
str=$1
while [ -n "$str" ]; do	#ponavljamo dokler niz ni prazen
	echo $str
	str=${str:0:$((${#str} - 1))}	#niz zamenjamo s podnizom, ki se zacne pri znaku 0 in je dolg za en znak manj od prejsnjega niza
done
