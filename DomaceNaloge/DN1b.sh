#!/bin/bash
username="$2"

while getopts 'lha:' OPT; do

    echo "Vnesite geslo za uporabnika $username"
    read -s pass
done


