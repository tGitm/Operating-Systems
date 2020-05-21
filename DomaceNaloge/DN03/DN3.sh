#!/bin/bash

while true; do
    read -p "Vnesite PID: " pid

    if [[ -z $(ps -p "$pid" -o pid= 2> /dev/null) ]]; then
        clear
        echo -e "\e[38;5;1mNeveljaven PID \e[38;5;15m"
        #ponovno preberem PID
        #read -p "Vnesite PID: " pid
    
    else
        #nrdim izpis
        prijaznost=$(ps -p "$pid" -o ni=)
        echo $(ps -p "$pid" -o cmd=) "$pid" $(readlink /proc/"$pid"/exe) "$prijaznost"
        echo ""
        #pwdx "$pid"
        echo "[u] poskusi ubiti, [+] povišaj prijaznost, [-] znižaj prijaznost, [s] pošlji signal"
        read -s -p -n 1 vneseno

        if [[ "$vneseno" = "+" ]]; then
            prijaznost=$(($prijaznost + 1))
        
        elif [[ "$vneseno" = "-" ]]; then
            prijaznost=$(($prijaznost - 1))
        fi

        renice -n "$prijaznost" -p "$pid" &> /dev/null
    fi


done