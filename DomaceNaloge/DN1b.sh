#!/bin/bash
while getopts 'u:-superuser:' OPTION; do
    case $OPTION in
        u) ap=$OPTARG;;
        -superuser) bp=$OPTARG;;
    esac
done

read -s -p "Vnesite geslo za uporabnika $username" pass
#read -s pass
#echo $pass
#spodaj ustvarim uporabnika, z domačim imenikom /home/uporabniško_ime
uporabnik=$(sudo useradd -m -p $(mkpasswd "$pass" --method=SHA-512) -d /home/$ap $ap)

if [[ "$bp" != '' ]]; then
    #echo "skripta doda uporabnika v sudo skupino"
    usermod -aG sudo "$ap"
fi
if [[ $? -eq 0 ]]; then
    echo "Uporabnik $ap ustvarjen."
fi
#echo $ap
#echo "$bp"
