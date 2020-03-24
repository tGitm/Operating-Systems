#!/bin/bash
direktorij=$1
uporabnik=$2

sudo setfacl -R -m u:$uporabnik:rx $direktorij
 

