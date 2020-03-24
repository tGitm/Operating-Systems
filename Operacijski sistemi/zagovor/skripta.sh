#!/bin/bash

file=$1

while read vrstica; do
    x=":*"  #vsi znaki do :
    y="*:" #vsi znaki po :
    name=${vrstica%$x}
    password=${vrstica#$y}
    coda=${password:0:3} #režemo od 0 do 3 indeksa 
    if [ $coda != '$6$' ]; then #primerjamo če je koda != sha512 in če je izpišemo --> >&2 da na standardni izhod za napake
        echo $name >&2
    fi

done < $file
