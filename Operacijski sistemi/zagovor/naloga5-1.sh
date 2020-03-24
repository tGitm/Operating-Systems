#!/bin/bash

if test -f "$1"; then
    ln "$1" $(basename "$1")
    echo "koncano"
    else
        touch $(basename "$1")
        echo "datoteka ustvarjena"
fi



