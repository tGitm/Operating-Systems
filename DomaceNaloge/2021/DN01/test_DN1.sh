#!/bin/bash

esc='\033'
regular=$esc'[0m'
red=$esc'[91m'
green=$esc'[92m'
bold=$esc'[1m'
format="$bold"'  * %-50s'

assert_equal () {
	if [ "$2" = "$1" ]; then
		message="$3 
OK"
	else
	expected=$1
	found=$2
		message="$3 
NAPAKA (prebrano: ${found//$'\n'/'\\n' }, pričakovano: ${expected//$'\n'/'\\n'})"
	fi
	print_message "$message"
}


assert_OK () {
	if [ "$2" = "$1" ]; then
		message="$3
OK"
	else
		expected=$(echo "$1" | tr "\n" "$")
		found=$(echo "$2" | tr "\n" "$")
		message="$3 
NAPAKA"
	fi
	print_message "$message"
}

print_message () {
	echo "$1" >> "$results"
	let test_counter++
	echo "Test $test_counter zaključen".
}

timeout_checker () {
	sleep 12
	echo -e "Program zaključil:\nNAPAKA (prekoračena časovna omejitev 12 s)" >> "$results"
	wrap_up
}

wrap_up () {
	points=0
	while read line; do
		if [ "$line" = "OK" ]; then
		  printf " [  $green$line$regular$bold  ]$regular\n"
		  let points+=1
		elif [ "${line:0:6}" = "NAPAKA" ]; then
		  printf "[ $red${line:0:6}$regular$bold ]$regular${line:6}\n"
		else
		  awk -v text="$line" -v format="$format" 'BEGIN {printf(format, text)}'
		fi
	done < "$results"
	echo "Skupaj uspešnih testov: $points"
    
    test_counter=0
	if [ $# -gt 0 ] && [ $1 = clean ]; then
          cleanup_process_subtree
	  kill -9 -$$ &> /dev/null
	fi
}

cleanup_process_subtree () {
	kill -9 -$pid &> /dev/null
}

prepare () {
	if [ -e "$results" ]; then
		rm "$results"
	fi

	if [ -e "$errlog" ]; then
    	rm "$errlog"
		touch "$errlog"
	fi

	if [ $(pgrep -c "$(basename $1)") -gt 0 ]; then
		pkill -9 $(basename $1)
	fi

}

test_counter=0

testroot="/tmp/OS-DN1"
mkdir -p "$testroot"
resultsroot="$testroot"


####### 1a #######
testedscript="DN1a.sh"
results="$resultsroot/results-1a.log"
errlog="$resultsroot/err-1a.log"
prepare "$testedscript"

echo "-----------------------------"
echo "Testi za nalogo $testedscript:"
testedscript=./"$testedscript"

if [[ -e $testedscript ]]; then 
	# Given example
	rm -f $testroot/testfile.txt  &>/dev/null
	rm -f $testroot/missingfile.txt  &>/dev/null
	rm -f $testroot/testfifo  &>/dev/null
	rm -rf $testroot/testdir  &>/dev/null
	echo "some content" > $testroot/testfile.txt
	mkfifo $testroot/testfifo
    mkdir $testroot/testdir

	output=$("$testedscript" "$testroot/testfile.txt" 2>&1)  || { test $? -eq 126 && exit; }
	output=${output% }
	assert_equal "1" "$output" "Podana datoteka obstaja."
	
	output=$("$testedscript" "$testroot/missingfile.txt" 2>&1) 
	output=${output% }
	assert_equal "0" "$output" "Podana datoteka ne obstaja."
	  
    output=$("$testedscript" "$testroot/missingfile.txt" /etc/passwd $testroot/testfile.txt $testroot/testfifo $testroot/testdir 2>&1) 
    output=${output% }
	assert_equal "0 1 1 1 0" "$output" "Preverjanje z več vhodnimi argumenti."
	wrap_up
else 
	echo "Skripte $testedscript ni v trenutnem imeniku ali pa še ne obstaja." 
fi

####### 1b #######
testedscript="DN1b.sh"
results="$resultsroot/results-1b.log"
errlog="$resultsroot/err-1b.log"
prepare "$testedscript"

echo "-----------------------------"
echo "Testi za nalogo $testedscript:"
testedscript=./"$testedscript"

if [[ -e $testedscript ]]; then 
    
    # Test obstoječih uporabnikov 
    users=(student administrator)
    rez=0
    for usr in ${users[@]}; do
       id $usr &>/dev/null || rez=1;
    done
    assert_OK 0 $rez "Predpogoji za test izpolnjeni:"
    test $rez -eq 1 && { wrap_up; echo "Testni uporabniki ne obstajajo. Prepričajte se, da naslednji uporabniki obstajajo na vašem sistemu: (${users[*]}). Za ustrezno nastavitev uporabnikov sledite navodilom na učilnici v dokumentu \"Virtualka v računalniških učilnicah in virtualka doma\"."; exit 1; };
    
    # Test za pravice
    rm -f $testroot/testfile.txt &>/dev/null
    echo "some content" > $testroot/testfile.txt
    chmod 700 $testroot/testfile.txt
          
    users=(root student administrator)
    "$testedscript" "$testroot/testfile.txt" ${users[*]} || { test $? -eq 126 && exit; }
    
    rez=1
    for usr in ${users[@]}; do
        echo $(getfacl $testroot/testfile.txt 2>/dev/null) | grep "user:$usr:r-x" >/dev/null || rez=0
    done
    assert_OK 1 $rez "Pravilne pravice za podane uporabnike."
    
    rez=0
    perm=$(stat -c "%a" $testroot/testfile.txt)
    test ${perm:2:1} -eq 0 && rez=1
    assert_OK 1 $rez "Nespremenjene pravice za ostale uporabnike."    
    wrap_up 
else 
	echo "Skripte $testedscript ni v trenutnem imeniku ali pa še ne obstaja." 
fi



####### 1c #######
testedscript="DN1c.sh"
results="$resultsroot/results-1c.log"
errlog="$resultsroot/err-1c.log"
prepare "$testedscript"

echo "-----------------------------"
echo "Testi za nalogo $testedscript:"
testedscript=./"$testedscript"


if [[ -e $testedscript ]]; then 
        
    # Postavitev 
    rm -rf $testroot/imenik &>/dev/null
    rm -f $testroot/imenik_inventura.txt &>/dev/null
    mkdir $testroot/imenik $testroot/imenik/imenik1 $testroot/imenik/imenik1/imenik1 $testroot/imenik/imenik1/imenik1/imenik1 $testroot/imenik/imenik2
    touch $testroot/imenik/datoteka1.txt $testroot/imenik/datoteka4.txt $testroot/imenik/datoteka12.txt $testroot/imenik/datoteka23 $testroot/imenik/slika.png 

    LC_COLLATE="C" "$testedscript" "$testroot/imenik" txt || { test $? -eq 126 && exit; }
    
    rez=0
    [ -e "$testroot/imenik_inventura.txt" ] || rez=1;
    assert_OK 0 $rez "Datoteka z inventuro obstaja."
     
    output=$(cat "$testroot/imenik_inventura.txt")
    expected="/tmp/OS-DN1/imenik/datoteka1.txt
/tmp/OS-DN1/imenik/datoteka12.txt
/tmp/OS-DN1/imenik/datoteka4.txt"
    
    assert_equal "$expected" "${output%'\n'}" "Najdene datoteke na nivoju 0 v podanem imeniku."
    
    touch $testroot/imenik/slika1.jpg $testroot/imenik/slika51.jpg $testroot/imenik/imenik1/imenik1/imenik1/slika1.jpg $testroot/imenik/imenik1/imenik1/slika3.jpg $testroot/imenik/imenik2/slika5.jpg $testroot/imenik/imenik2/slika26.jpg 
    
    
    LC_COLLATE="C" "$testedscript" "$testroot/imenik" jpg
    output=$(cat "$testroot/imenik_inventura.txt")
    expected="/tmp/OS-DN1/imenik/imenik1/imenik1/imenik1/slika1.jpg
/tmp/OS-DN1/imenik/imenik1/imenik1/slika3.jpg
/tmp/OS-DN1/imenik/imenik2/slika26.jpg
/tmp/OS-DN1/imenik/imenik2/slika5.jpg
/tmp/OS-DN1/imenik/slika1.jpg
/tmp/OS-DN1/imenik/slika51.jpg"

    assert_equal "$expected" "${output%'\n'}" "Najdene datoteke rekurzivno na ostalih nivojih."
    
    wrap_up 
else 
	echo "Skripte $testedscript ni v trenutnem imeniku ali pa še ne obstaja." 
fi

####### 1d #######
testedscript="DN1d.sh"
results="$resultsroot/results-1d.log"
errlog="$resultsroot/err-1d.log"
prepare "$testedscript"

echo "-----------------------------"
echo "Testi za nalogo $testedscript:"
testedscript=./"$testedscript"


if [[ -e $testedscript ]]; then 
        
    rm -rf $testroot/inventura &>/dev/null
    mkdir $testroot/inventura
 
    echo "$testroot/inventura/testfile_star.txt" > $testroot/inventura/inventura.txt

    rez=0    
    output=$("$testedscript" "$testroot/inventura/inventura.txt") || { status=$?; test $status -eq 126 && exit; }
    assert_equal "10" "$status" "Izhodni status ob napačni inventuri."
    assert_equal "Napaka v inventarju!" "${output%'\n'}" "Izpis ob napačni inventuri."
    
    fallocate -l 1 $testroot/inventura/testfile1.txt
    fallocate -l 31 $testroot/inventura/testfile2.txt
    fallocate -l 51 $testroot/inventura/testfile3.txt
    touch $testroot/inventura/testfile4.txt
    
    echo "$testroot/inventura/testfile1.txt
$testroot/inventura/testfile2.txt
$testroot/inventura/testfile3.txt
$testroot/inventura/testfile4.txt" > $testroot/inventura/inventura.txt
    
    output=$("$testedscript" "$testroot/inventura/inventura.txt") || { status=$?; test $status -eq 126 && exit; }    
    assert_equal "83 B" "$output" "Izračunana velikost se ujema."
    
    wrap_up 
else 
	echo "Skripte $testedscript ni v trenutnem imeniku ali pa še ne obstaja." 
fi


####### 1e #######
testedscript="DN1e.sh"
results="$resultsroot/results-1e.log"
errlog="$resultsroot/err-1e.log"
prepare "$testedscript"

echo "-----------------------------"
echo "Testi za nalogo $testedscript:"
testedscript=./"$testedscript"


if [[ -e $testedscript ]]; then 
    
    # Find a free user uid
    checkid=10001
    for i in $(seq 5000 10000);do 
        id $i &>/dev/null || { checkid=$i; break; };    
    done
    
    output=$("$testedscript" $checkid)    
    expected="prosto!
rezerviran: NE"
    assert_equal "$expected" "${output%'\n'}" "Uporabnik je prost."    
    
    output=$("$testedscript" 66)    
    expected="prosto!
rezerviran: DA"
    assert_equal "$expected" "${output%'\n'}" "Uporabnik je prost in rezerviran."
    
    output=$("$testedscript" 0)    
    expected="uid: 0
uporabnik: root
imenik: /root
lupina: bash
rezerviran: DA"
    assert_equal "$expected" "${output%'\n'}" "Uporabnik je root."    
    
    wrap_up
else 
	echo "Skripte $testedscript ni v trenutnem imeniku ali pa še ne obstaja." 
fi


exit 0