#!/bin/bash
datoteka=$1
cat $datoteka | while [ read vrstica ]; do
    echo $vrstica
done    