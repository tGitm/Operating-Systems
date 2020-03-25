#!/bin/bash
#poiscemo vse datoteke formata mp3 v podanem imeniku
files=$(find $1 -type f -name '*.mp3')

#shranimo si ciljni imenik
folder=$2

#funkcija za branje posameznih znack
function gettag() {
	#poiscemo vrstico z zeljeno znacko in preberemo del za dvopicjem
	tag=$(echo "$1" | grep "$2:" | awk -F':' '{print $2}')
	#preberemo le del, ki se nahaja med prvo in zadnjo crko ter tako odstranimo nepotrebne prazne znake
	tag=$(echo "$tag" | grep -o -e "[a-zA-Z].*[a-zA-Z]")
	
	echo $tag
}

IFS=$'\n'
for file in ${files[@]}; do
	#preberemo vse znacke za zeljeno datoteko
	tags=$(id3tool "$file")
	
	#ce datoteka nima znack, jo preskocimo
	if [ "$tags" != "No ID3 Tag" ]; then
		#s pomocjo nase funkcije preberemo vse potrebne znacke
		artist=$(gettag "$tags" "Artist")
		album=$(gettag "$tags" "Album")
		song=$(gettag "$tags" "Song Title")
		
		#ce datoteka nima vseh potrebnih znack, jo preskocimo
		if [ -n "$artist" -a -n "$album" -a -n "$song" ]; then
			#dolocimo novo ime datoteke
			newfile=$song".mp3"
			#dolocimo novo pot do datoteke
			newfolder="$folder/$artist/$album"
			#ce potrebni imeniki ne obstajajo, jih ustvarimo
			if [ ! -d "$newfolder" ]; then
				mkdir -p "$newfolder"
			fi
			
			#skopiramo datoteko na novo lokacijo
			cp "$file" "$newfolder/$newfile"
		fi
	fi
done
