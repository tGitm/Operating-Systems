#!/bin/bash
echo "$(find $1 -type d)" | awk '{gsub(/[^\/]/, "");print}' | wc -L
#poiscemo vse imenike, v vsakem rezultatu pobrisemo vse znake razen "/" in izpisemo dolzino najdaljse vrstice
#pozor: Ta program deluje pravilno le v primeru, da pot do imenika ne vsebuje znakov "/".
