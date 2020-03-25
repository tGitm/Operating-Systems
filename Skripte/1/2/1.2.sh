#!/bin/bash
filen="$1.conf"	#ime konfiguracijske datoteke
> $filen	#ustvarimo prazno datoteko
while read line; do	#preberemo template.conf po vrsticah
	echo ${line/"_user_"/$1} >> $filen	#zamenjamo znacko z uporabniskim imenom
done < template.conf
mkdir $1	#ustvarimo imenik
ln -s $(pwd)/$filen $(pwd)/$1/$filen	#in vanj dodamo simbolicno povezavo do konfiguracijske datoteke
