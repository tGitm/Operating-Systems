#!/bin/bash

#########################################################################
#########################################################################
# A = 6  (3 dodatnih v skritih)
# B = 12 (4 dodatnih v skritih)
# C = 10 (5 dodatnih v skritih) 
#########################################################################
#######################################################################

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Poženi me kot sudo!"
    exit 2
fi
clear

iniDir=$(pwd)
rootDir="/tmp/os-dn1"
subDir="$rootDir/podimenik"
rm -rf $rootDir
mkdir -p $rootDir
mkdir "$subDir"
rm "$HOME/škorenj" &>/dev/null

fullPrint=$( [ $# -gt 0 ] && echo '' || echo 1 )

function res {
	p=$1
	pts=$2
	c="$3"

	if [ "$fullPrint" ]; then
		[ $p -eq $pts ] && echo -e "\e[1m$p/$pts\e[0m | $c" || echo -e "\e[41;1m$p/$pts\e[0m | $c"
	else
		cS="${c:5:3}"
		echo -n "$cS$p; "
	fi
}

function printSlow {
	s="$1"
	for (( i=0; i<${#s}; i++ )); do
		sleep 0.01
		if [ "${s:$i:1}" = "|" ]; then
			echo -en "\e[3$(( $RANDOM * 6 / 32767 + 1 ))m${s:$i:1}"
		else
			echo -en "\e[0m\e[1m${s:$i:1}"
		fi
	done
	echo -e "\e[0m"
}

function supressErr {
	exec 3>&2
	exec 2> /dev/null
}

function resumeErr {
	exec 2>&3
}
if [ "$fullPrint" ]; then
	echo -e "--------------------------------------------------------------------------\n"
	echo -e "\t1. DOMAČA NALOGA IZ OPERACIJSKIH SISTEMOV 2019/2020"
	echo -e "\n--------------------------------------------------------------------------"
fi

#########################################################################
#########################################################################
# A = 6 točk (3 dodatne v skritih)
#########################################################################
#########################################################################

allP=0
cd "$iniDir"
if [ -x DN1a.sh ]; then
	cp DN1a.sh "$rootDir"
	cd "$rootDir"

	podatki=$(echo -e "medved\nveverica\nveverica\nveverica\ngozdni zajec\ngozdni zajec")
	resitev=$(echo -e "2 gozdni zajec\n1 medved\n3 veverica")

	echo "$podatki" > "zivali.txt"
	echo "$podatki" > "zivali s presledki.txt"
	
	#######################
	p=0
	pts=2
	c="Test A1: Preverba delovanja brez podane izhodne datoteke."

	o=$(./DN1a.sh "zivali.txt" 2> /dev/null | sed -e 's/^[ \t]*//')

	if [ "$o" = "$resitev" ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################

	#######################
	p=0
	pts=3
	c="Test A2: Preverba delovanja s podano izhodno datoteko."

	./DN1a.sh "zivali.txt" "$subDir/izhod" &> /dev/null
	o=$(cat "$subDir/izhod" 2> /dev/null | sed -e 's/^[ \t]*//')
	rm "$subDir/izhod" &>/dev/null

	if [ "$o" = "$resitev" ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################

	#######################
	p=0
	pts=1
	c="Test A3: Preverba delovanja z datoteko s presledki v imenu."

	o=$(./DN1a.sh "zivali s presledki.txt" 2> /dev/null | sed -e 's/^[ \t]*//')

	if [ "$o" = "$resitev" ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################

else
	echo -e "\e[31m/// Skripte DN1a.sh ni možno pognati. ///\e[0m Preverite ime in bit za izvajanje. \e[31m///\e[0m"
fi
allPa=$allP
if [ "$fullPrint" ]; then
	echo '--------------------------------------------------------------------------'
fi

#########################################################################
#########################################################################
# B = 12 točk (5 dodatnih v skritih)
#########################################################################
#########################################################################

allP=0
cd "$iniDir"
if [ -x DN1b.sh ]; then
	un='linolej'
	userdel -r $un &> /dev/null

	#######################
	p=0
	pts=5
	
	c="Test B1: Kreiranje uporabnika '$un'."

	izpis=$(echo "opica" | ./DN1b.sh -u $un 2> /dev/null | sed -e 's/^[ \t]*//' | tr -d '\n')
	isSudo=$(groups $un | grep -q '\bsudo\b' && echo 'y' || echo '')
	id -u $un &> /dev/null
	o=$?
	userdel -r $un &> /dev/null

	if [ $o -eq 0 ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################

	#######################
	p=0
	pts=2
	c="Test B2: Preverjanje pravilnosti izpisa ob uspešnem keiranju."
	if [ "$izpis" = "Uporabnik $un ustvarjen." ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################

	#######################
	p=0
	pts=2
	c="Test B3: Preverjanje stikala --superuser (brez podanega stikala)."
	if [ ! $isSudo ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################

	#######################
	p=0
	pts=3
	c="Test B4: Preverjanje delovanja superuserja ob podanem stikalu."
	echo "opica" | ./DN1b.sh -u $un --superuser &> /dev/null
	isSudo=$(groups $un | grep -q '\bsudo\b' && echo 'y' || echo '')
	userdel -r $un &> /dev/null
	if [ $isSudo ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################
else
	echo -e "\e[31m/// Skripte DN1b.sh ni možno pognati. ///\e[0m Preverite ime in bit za izvajanje. \e[31m///\e[0m"
fi
allPb=$allP
if [ "$fullPrint" ]; then
	echo '--------------------------------------------------------------------------'
fi


#########################################################################
#########################################################################
# C = 10 točk (4 dodatne v skritih)
#########################################################################
#########################################################################

allP=0
cd "$iniDir"
if [ -x DN1c.sh ]; then
	cp DN1c.sh $rootDir
	cd $rootDir
	
	#######################
	p=0
	pts=4
	
	c="Test C1: Preverjanje, če je imeniška struktura pravilno ustvarjena."
	rm -rf $subDir
	rm "$HOME/škorenj" &>/dev/null
	d1="/boot"
	d2=$subDir
	./DN1c.sh "$d1" "$d2"  &>/dev/null

	gt=$(for i in $(tree -dfi --noreport "$d1"); do echo ${i/$d1/$d2}; done)
	res1=$(tree -dfi --noreport "$d2")
	res2=$(tree -fi --noreport "$d2")

	if [ "$gt" = "$res1" ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################

	#######################
	p=0
	pts=2
	
	c="Test C2: Preverjanje, če struktura ne vsebuje datotek."

	if [ "$gt" = "$res2" ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################

	#######################
	p=0
	pts=1

	c="Test C3: Preverjanje mehke povezave."

	if [ -L  "$HOME/škorenj" ] && [ "$(readlink "$HOME/škorenj")" = "$d2" ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################

	#######################
	p=0
	pts=2

	c="Test C4: Preverjanje pravic imenika 'imenik2'."
	
	o=$(stat -c '%a' "$d2")
	
	if [ $o -eq 1100 ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################

	#######################
	p=0
	pts=1

	c="Test C5: Preverjanje izhodnega statusa 21 če podan samo en argument."

	./DN1c.sh "$d1" &>/dev/null
	o=$?
	if [ $o -eq 21 ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################

else
	echo -e "\e[31m/// Skripte DN1c.sh ni možno pognati. ///\e[0m Preverite ime in bit za izvajanje. \e[31m///\e[0m"
fi
allPc=$allP
if [ "$fullPrint" ]; then
	echo '--------------------------------------------------------------------------'
fi

grande=$(($allPa + $allPb + $allPc))

rm -rf $rootDir
rm "$HOME/škorenj" &>/dev/null

if [ "$fullPrint" ]; then
	echo -e "\n\tNaloga 1A: \e[1m$allPa\e[0m/6  (še do 3 lahko dobite po oddaji)."
	echo -e "\tNaloga 1B: \e[1m$allPb\e[0m/12 (še do 4 lahko dobite po oddaji)."
	echo -e "\tNaloga 1C: \e[1m$allPc\e[0m/10 (še do 5 lahko dobite po oddaji)."
	echo -e "\n\tSkupno število točk na tem javnem testu: \e[0m\e[1m$grande\e[0m/28\e[0m.\n"

	if [ $grande -eq 28 ]; then
		printSlow "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
		printSlow "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
		printSlow "||||||||||||||||||||||||||||||| B R A V O ||||||||||||||||||||||||||||||||"
		printSlow "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
		printSlow "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
		echo ""
	fi

	echo -e "\e[94mPo oddaji lahko dobite do 12 dodatnih točk na skritih testih (skupno je možno dobiti tako 28+12=40 točk). Na zagovorih (ki so zaenkrat še nedorečeni zaradi COVID-19) pa boste lahko dobili še do 60 točk.\e[0m\n"
else
	echo -ne "Skupaj: $grande/28\n"
fi