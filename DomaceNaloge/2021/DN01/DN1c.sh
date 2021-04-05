#!/bin/bash
dir=$1  #podan imenika
end=$2  #podana končnica

fName=$(basename $dir)
find "$dir" -type f -name "*.$end" | sort > "${dir}_inventura.txt"
