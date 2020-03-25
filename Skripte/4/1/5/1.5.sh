#!/bin/bash
ips=$(cat $1)	#preberemo dnevnik
ips=$(echo "$ips" | awk '{print $1}')	#iz vsake vrstice poberemo le IP-naslov
ips=$(echo "$ips" | sort)	#naslove sortiramo tako, da so enaki skupaj
ips=$(echo "$ips" | uniq -c)	#sortirane naslove poskupinimo ter jim dodamo stevilo pojavitev
ips=$(echo "$ips" | sort -n -r)	#naslove nato sortiramo po stevilu pojavitev
ips=$(echo "$ips" | awk '{print $2"\t"$1}')	#obrnemo vrstni red izpisa ter podatka locimo s tabulatorjem
echo -e "$ips" | head -n 5	#izpisemo zgornjih 5 naslovov, kjer programu echo povemo, da nizi vsebujejo znake z ubezno sekvenco (tabulator)
