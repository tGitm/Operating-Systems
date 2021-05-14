#!/bin/bash
BUFFER=0.1
#########################################################################
#########################################################################


which screen &> /dev/null
if ! [ -x "$(command -v screen)" ]; then
	echo "Program 'screen' ni nameščen. Namestite ga s 'sudo apt install screen' in ponovno poženite testno scripto."
	exit 3
fi
clear

fullPrint=$( [ $# -gt 0 ] && echo '' || echo 1 )

FOL="/tmp/os-dn2"
rm -r $FOL &> /dev/null
mkdir $FOL

function supressErr {
	exec 3>&2
	exec 2> /dev/null
}

function resumeErr {
	exec 2>&3
}
if [ "$fullPrint" ]; then
	echo -e "--------------------------------------------------------------------------\n"
	echo -e "\t2. DOMAČA NALOGA IZ OPERACIJSKIH SISTEMOV 2020/2021"
	echo -e "\n--------------------------------------------------------------------------"
fi

function res {
	# resumeErr
	p=$1
	pts=$2
	c="$3"

	if [ "$fullPrint" ]; then
		[ $p -eq $pts ] && echo -e "\e[1m$p/$pts\e[0m | $c" || echo -e "\e[41;1m$p/$pts\e[0m | $c"
	else
		cS="${c:5:3}"
		echo -n "$cS$p; "
	fi
	# supressErr
}

function printSlow {
	s="$1"
	for (( i=0; i<${#s}; i++ )); do
		sleep 0.005
		echo -en "\e[1m"
		if [ "${s:$i:1}" = "#" ]; then
			echo -en "\e[3$(( $RANDOM * 6 / 32767 + 1 ))m${s:$i:1}"
		else
			echo -en "\e[0m\e[1m${s:$i:1}"
		fi
	done
	echo -e "\e[0m"
}

echo "V zgornjem predalu imam trenutno:
- origano 2g
- trava 5g
- drobljena paprika 12g

Danes mi je Vekoslava dala naslednje tri začimbe: sušeni koriander 18, žar mix 20g, sveži koriander 16g. 

Pri plinski bombi sem zadaj našel nekaj plesnivega, na papirnati vreči pa piše: drobljena paprika 40 " > $FOL/arhiv.txt

#########################################################################
#########################################################################
# supressErr
allP=0

if [ -x DN2a.sh ]; then

	# read -sp "Vnesi sudo geslo: " sudop
	# echo "Geslo vnešeno."
	

	#######################
	p=0
	pts=5
	c="Test 1: Preverba izpisa pri podnalogi a, z uporabo vsebine iz arhiv.txt in argumenta koriander."
	a=$(./DN2a.sh $FOL/arhiv.txt koriander | tr -d '[:space:]')
	b="koriander34"

	if [ "$a" = "$b" ]; then
		p=$pts
	fi
	
	res $p $pts "$c"
	allP=$(($allP+$p))

	#######################

else
	echo -e "\e[31m/// Skripte DN3a.sh ni možno pognati. ///\e[0m Preverite ime in bit za izvajanje. \e[31m///\e[0m"
fi

if [ -x DN2b.sh ]; then

	#######################
	p=0
	pts=4
	c="Test 2: Preverba delovanja za b, pri vhodih cd, echo, ls."

	session_name=$(($(date +%s) - 1000000))
	screen -dmS $session_name ./DN2b.sh; sleep $BUFFER
	screen -r $session_name -p0 -X stuff "cd\n"; sleep $BUFFER
	screen -r $session_name -p0 -X stuff "echo\n"; sleep $BUFFER
	screen -r $session_name -p0 -X stuff "ls\n"; sleep $BUFFER
	screen -r $session_name -p0 -X hardcopy $FOL/t2; sleep $BUFFER
	screen -X -S $session_name kill
	a=$(cat $FOL/t2 | tr -d '[:space:]')
	b="Vnesiteimeukaza:cdVGRAJENVnesiteimeukaza:echoObOjEVnesiteimeukaza:lsnevgrajenVnesiteimeukaza:"
	bb="Vnesiteimeprocesa:cdVGRAJENVnesiteimeprocesa:echoObOjEVnesiteimeprocesa:lsnevgrajenVnesiteimeprocesa:"
	
	if [[ "$a" = "$b" ||  "$a" = "$bb" ]]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################
else
	echo -e "\e[31m/// Skripte DN3b.sh ni možno pognati. ///\e[0m Preverite ime in bit za izvajanje. \e[31m///\e[0m"
fi

if [ -x DN2c.sh ]; then	

	#######################
	p=0
	pts=3
	c="Test 3: Preverba izpisa pri podnalogi c, za PID 1."

	a=$(./DN2c.sh | head -1 | tr -d '[:space:]')

	if [[ "$a" =~ ^1.* ]]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################
else
	echo -e "\e[31m/// Skripte DN3c.sh ni možno pognati. ///\e[0m Preverite ime in bit za izvajanje. \e[31m///\e[0m"
fi

if [ -x DN2d.sh ]; then

	#######################
	p=0
	pts=3
	c="Test 4: Preverba ustreznosti formata izpisa za podnalogo d."

	a=$(./DN2d.sh | grep -E .+\ [0-9]+,[0-9]+\ [0-9]+,[0-9]+ | wc -l)

	if [ $a -eq 3 ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################

else
	echo -e "\e[31m/// Skripte DN3d.sh ni možno pognati. ///\e[0m Preverite ime in bit za izvajanje. \e[31m///\e[0m"
fi

rm -r $FOL &> /dev/null
grande=$allP
max=15
max_rest=5
# resumeErr

if [ "$fullPrint" ]; then	
	echo -e "\n\tSkupno število točk na tem javnem testu: \e[0m\e[1m$grande\e[0m/$max\e[0m.\n"

	if [ $grande -eq $max ]; then
		printSlow "##########################################################################"
		printSlow "##########################################################################"
		printSlow "############################### B R A V O ################################"
		printSlow "##########################################################################"
		printSlow "##########################################################################"
		echo ""
	fi

	echo -e "\e[94mPo oddaji lahko dobite do $max_rest dodatnih točk na skritih testih (skupno je možno dobiti tako $max+$max_rest=20 točk).\nNa zagovorih boste lahko dobili še do 80 točk.\e[0m\n"
else
	echo -ne "Skupaj: $grande/$max\n"
fi