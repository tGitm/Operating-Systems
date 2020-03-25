#!/bin/bash
function readFolder() {
	unset files	#pobrisemo spremenljivko files
	local i=0	#deklariramo stevec i kot lokalno spremenljivko
	for file in $1/*; do	#sprehodimo se cez vse datoteke
		files[$i]=$(basename "$file")	#shranimo le ime
		i=$((i + 1))	#povecamo stevec
	done
}
readFolder $1	#poklicemo funkcijo s prvim imenikom
files1=("${files[@]}")	#tabelo files, ki jo je napolnila funkcija, skopiramo v tabelo files1
readFolder $2
files2=("${files[@]}")
for file1 in "${files1[@]}"; do	#sprehodimo se cez tabeli
	for file2 in "${files2[@]}"; do
		if [ "$file1" == "$file2" ]; then
			echo $file1	#izpisemo datoteko, ce se imeni ujemata
			break
		fi
	done
done
