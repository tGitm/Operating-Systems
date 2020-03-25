#!/bin/bash
dict=$(cat $1)	#preberemo slovar
text=$(cat $2)	#preberemo besedilo
#velike crke pretvorimo v male in odstranimo locila
text=$(echo $text | tr "[:upper:]" "[:lower:]")
text=$(echo $text | tr "[:punct:]" " ")
for word in ${text[@]}; do	#sprehodimo se cez besedilo po posameznih besedah
	isWrong=true	#predpostavljamo, da je beseda napacna
	for cont in ${dict[@]}; do
		if [ "$word" == "$cont" ]; then
			#ce besedo najdemo v slovarju, si to zapomnimo in koncamo iskanje
			isWrong=false
			break
		fi
	done
	if $isWrong; then	#ce besede nismo nasli, jo izpisemo
		echo $word
	fi
done
