#!/bin/bash
TIME_PAUSE=1
#########################################################################
#########################################################################

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Poženi me kot sudo!"
    exit 2
fi
which screen &> /dev/null
if [ $? -gt 0 ]; then
	echo "Program 'screen' ni nameščen."
	exit 3
fi
clear

fullPrint=$( [ $# -gt 0 ] && echo '' || echo 1 )

FOL="/tmp/os-dn3"
rm -r $FOL &> /dev/null
mkdir $FOL
chmod 777 $FOL
cp DN3.sh $FOL &>/dev/null
cd $FOL

function supressErr {
	exec 3>&2
	exec 2> /dev/null
}

function resumeErr {
	exec 2>&3
}
if [ "$fullPrint" ]; then
	echo -e "--------------------------------------------------------------------------\n"
	echo -e "\t3. DOMAČA NALOGA IZ OPERACIJSKIH SISTEMOV 2019/2020"
	echo -e "\n--------------------------------------------------------------------------"
fi

function res {
	resumeErr
	p=$1
	pts=$2
	c="$3"

	if [ "$fullPrint" ]; then
		[ $p -eq $pts ] && echo -e "\e[1m$p/$pts\e[0m | $c" || echo -e "\e[41;1m$p/$pts\e[0m | $c"
	else
		cS="${c:5:3}"
		echo -n "$cS$p; "
	fi
	supressErr
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

#########################################################################
#########################################################################

allP=0
cd "$iniDir"
if [ -x DN3.sh ]; then

	read -sp "Vnesi sudo geslo: " sudop
	echo "Geslo vnešeno."
	bash -c "touch $FOL/aba; catch() { touch $FOL/n; }; catchu() { touch $FOL/u; }; trap 'catch' SIGTERM; trap 'catchu' SIGUSR1; while :; do sleep 1; done;" &
	pid=$!
	fpid="1212121212121"

	session_name=$(($(date +%s) - 1000000))
	screen -dmS $session_name sudo ./DN3.sh; sleep $TIME_PAUSE
	screen -r $session_name -p0 -X stuff "$sudop\n"; sleep $TIME_PAUSE
	screen -r $session_name -p0 -X stuff "$fpid\n"; sleep $TIME_PAUSE
	screen -r $session_name -p0 -X hardcopy $FOL/t1; sleep $TIME_PAUSE
	screen -r $session_name -p0 -X stuff "$pid\n"; sleep $TIME_PAUSE
	screen -r $session_name -p0 -X stuff "u"; sleep $TIME_PAUSE
	ni0=$(ps -o ni= -p $pid)
	screen -r $session_name -p0 -X stuff "+"; sleep $TIME_PAUSE
	ni1=$(ps -o ni= -p $pid)
	screen -r $session_name -p0 -X stuff "+"; sleep $TIME_PAUSE
	ni2=$(ps -o ni= -p $pid)
	screen -r $session_name -p0 -X stuff "-"; sleep $TIME_PAUSE
	ni3=$(ps -o ni= -p $pid)
	screen -r $session_name -p0 -X stuff "sSIGUSR1\n"; sleep $TIME_PAUSE
	

	supressErr
	#######################
	p=0
	pts=5
	c="Test 1: Preverba izpisa ob neveljavnem PIDu."
	
	o="Neveljaven PID\nVnesite PID:"
	
	a=$(cat $FOL/t1 | tr -d '[:space:]')
	b=$(echo -e $o | tr -d '[:space:]')

	if [ "$a" = "$b" ]; then
		p=$pts
	fi
	
	res $p $pts "$c"
	allP=$(($allP+$p))

	#######################


	#######################
	p=0
	pts=5
	c="Test 2: Preverba delovanja [u]."
	
	if [ -f $FOL/n ]; then
		p=$pts
	fi
	
	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################

	#######################
	p=0
	pts=5
	c="Test 3: Preverba delovanja [+]."

	if [ $(($ni0 + 1 )) -eq $ni1 ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################


	#######################
	p=0
	pts=5
	c="Test 4: Preverba delovanja [-]."

	if [ $(($ni0 + 1 )) -eq $ni3 ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################

	#######################
	p=0
	pts=5
	c="Test 5: Preverba delovanja [s]." #, s poslanim SIGUSR1."

	# kill -0 $pid &> /dev/null
    # if  [ $? -ne  0 ]; then
	# 	p=$pts
	# fi
	if [ -f $FOL/u ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################

	screen -S $session_name -p0 -X quit

else
	echo -e "\e[31m/// Skripte DN3.sh ni možno pognati. ///\e[0m Preverite ime in bit za izvajanje. \e[31m///\e[0m"
fi

supressErr
kill -9 $pid &> /dev/null
rm -r $FOL &> /dev/null
grande=$allP
max=25
max_rest=15
resumeErr

if [ "$fullPrint" ]; then	
	echo -e "\n\tSkupno število točk na tem javnem testu: \e[0m\e[1m$grande\e[0m/$max\e[0m.\n"

	if [ $grande -eq 25 ]; then
		printSlow "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
		printSlow "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
		printSlow "||||||||||||||||||||||||||||||| B R A V O ||||||||||||||||||||||||||||||||"
		printSlow "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
		printSlow "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
		echo ""
	fi

	echo -e "\e[94mPo oddaji lahko dobite do $max_rest dodatnih točk na skritih testih (skupno je možno dobiti tako $max+$max_rest=40 točk). Na zagovorih pa boste lahko dobili še do 60 točk.\e[0m\n"
else
	echo -ne "Skupaj: $grande/$max\n"
fi