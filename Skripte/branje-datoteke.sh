#!/bin/bash
datoteka=$1
while read vrstica; do
    echo $vrstica
done < $datoteka #datoteko preusmerim na standardni izhod, read bere datoteko vrstico po vrstico     