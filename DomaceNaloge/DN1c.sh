#!/bin/bash
imenik1="$1"
imenik2="$2"

#če ni dveh argumentov vrnem 21
if [[ "$#" -ne 2 ]];then
    exit 21
fi

if [[ "$#" -eq 2 ]]; then
    #kopira vse imenike in podimenike brez datotek ampak samo direktorije
    rsync -a -f"+ */" -f"- *" "$imenik1"/ "$imenik2"
    chmod -r 550 "$imenik2"
    chmod 1100 "$imenik2"
    #echo find . -type d
    ln -s "$imenik2" $HOME/škorenj
    exit 0
fi


