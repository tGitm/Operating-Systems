#!/bin/bash
count=0
for num in $(grep "^$1 " $2 | cut -d " " -f 2); do	#Z ukazom grep izberemo vrstice, ki nas zanimajo, nato pa z ukazom cut izberemo drugo vrednost (polje) v vrstici, ki predstavlja cas.
	count=$(($count + $num))
done
echo $count
