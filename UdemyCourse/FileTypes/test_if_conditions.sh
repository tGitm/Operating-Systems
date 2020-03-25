#!/bin/bash
filename=$1
if [ -e $filename]; then
    echo "Datoteka $filename obstaja!"
else
    echo "Datoteka $filename ne obstaja!"
fi
exit