#!/bin/bash
#izracunamo, koliko prostora zasede imenik z vsemi podimeniki
total=$(du -s $1 | tail -n 1 | awk '{print $1}')
tresh=$(($total * $2 / 100))	#izracun meje

function checkFolder() {
	local size=$(du -s "$1" | tail -n 1 | awk '{print $1}')
	if [ $size -lt $tresh ]; then
		return 1	#ce je podimenik manj zaseden kot meja, se rekurzija ustavi
	fi
	
	print=true
	for folder in $1/*; do
		if [ -d "$folder" ]; then
			checkFolder "$folder"	#ce so vsi pod imeniki pod mejo, bodo vrnili status 1
			if [ $? -ne 1 ] ; then
				print=false
			fi
		fi
	done
	
	if $print; then
		echo $1
	fi
	return 0
}

checkFolder "$1"	#prvi klic rekurzije

