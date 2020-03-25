#!/bin/bash
level=0 #zacnemo na nivoju 0
while read line; do	#beremo vrstice iz podane datoteke
	#zmanjsamo zamik, ce se vrstica ujema s kljucno besedo za konec zamika
	if [[ "$line" == "done" ]] || [[ "$line" == "fi" ]] || [[ "$line" == "elif"* ]] || [[ "$line" == "else" ]]; then
		level=$(($level - 1))
	fi
	#vrstici dodamo tabulatorje in jo izpisemo
	newline=$line
	for((i=0;i<$level;i++)); do	
		newline="\t"$newline
	done
	echo -e $newline
	#povecamo zamik, ce se vrstica ujema s kljucno besedo za zacetek zamika
	if [[ "$line" == "do" ]] || [[ "$line" == "then" ]] || [[ "$line" == "else" ]]; then
		level=$(($level + 1))
	fi
done < $1
