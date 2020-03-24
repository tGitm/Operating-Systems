#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Vpisati morate samo pot do datoteke, naj ne bo več argumentov."
    exit 1 
fi

mkdir -p "$1"/skel
cp -R /etc/skel/. "$1"/skel
cd "$1"/skel
while true; do
    read -p "Enter file: " datoteka #ne gre v novo vrstico
    mkdir "$1"/$datoteka

done

ln -s /var/www www-root
