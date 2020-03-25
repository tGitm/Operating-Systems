#!/bin/bash
head -n $2 $3 | tail -n $(($2 - $1))
#najprej izlocimo vrstice od zacetka do zeljenega konca, nato pa iz dobljenih vrstic izlocimo vrstice od konca do zeljenega zacetka 
