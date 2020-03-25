#!/bin/bash
#nastavimo spremenljivke za stetje nivojev
sec=0
subsec=0
list=0

verbatim=false

#nastavimo vzorce za iskanje
secp="\\\\section *{"
subsecp="\\\\subsection *{"
listp="\\\\lstinputlisting *\["
vstart="\\\\begin{verbatim}"
vend="\\\\end{verbatim}"

echo -n "" > $2	#ustvarimo prazno izhodno datoteko

IFS=$'\n'	#izvorno datoteko bomo brali le po vrsticah
while read -r line; do
	#preverimo ce se nahajamo v obmocju dobesednega navajanja
	if echo "$line" | grep -q -e "$vstart"; then
		verbatim=true
	elif echo "$line" | grep -q -e "$vend"; then
		verbatim=false
	fi
	
	if $verbatim; then
		#ce se nahajamo v obmocju dobesednega navajanja, ignoriramo ukaze
		echo "$line" >> $2
	else
		#ce vrstica oznacuje novo poglavje ali podpoglavje, si to zapomnimo
		if echo "$line" | grep -q -e "$secp"; then
			sec=$(($sec + 1))
			subsec=0
			list=0
		elif echo "$line" | grep -q -e "$subsecp"; then
			subsec=$(($subsec + 1))
			list=0
		fi
	
		if echo "$line" | grep -q -e "$listp"; then
			#ce vrstica vsebuje vkljucitev izvorne kode, povecamo stevec
			list=$(($list + 1))
		
			#preberemo nastavitve
			setts=$(echo "$line" | awk -F'[' '{print $(NF)}' | awk -F']' '{print $1}')
			#preberemo pot do datoteke
			fn=$(echo "$line" | awk -F'{' '{print $(NF)}' | awk -F'}' '{print $1}')
		
			#zgradimo blok za izpis izvorne kode
			block="\begin{lstlisting}[$setts]
	$(cat $fn)
	/%\textbackslash%/end{lstlisting}"
		
			#izpisemo blok z izvorno kodo v novo datoteko
			echo "$block" >> $2
		
			#nastavimo novo pot do datoteke
			folder="files/"$sec"/"$subsec
			if [ ! -d $folder ]; then
				#ce je potrebno, ustvarimo imenike
				mkdir -p $folder
			fi
		
			#preberemo koncnico datoteke
			ext=$(echo "$fn" |awk -F'.' '{print $NF}')
		
			#datoteko skopiramo na novo lokacijo
			cp $fn $folder"/"$list"."$ext
		else
			#izpisemo vrstico v novo datoteko
			echo "$line" >> $2
		fi
	fi
done < $1