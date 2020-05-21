#!/bin/bash
# naredimo datoteke ##########################

M1=$((1*1024))
M101=$((101*1024))
M102=$((102*1024))

M150=$((150*1024))
M210=$((210*1024))
M160=$((160*1024))

rm -r imenik 2>/dev/null
mkdir -p imenik/podimenik/xxx 2>/dev/null



dat1="kratki film.mkv"
dat2="a.old.zip"
dat3="dn2_resitev.zip"
dat4="test"
dat5="x3.mkv"

dd if=/dev/zero of="imenik/$dat1" bs=${M150} count=1024 2>/dev/null
dd if=/dev/zero of="imenik/podimenik/$dat2" bs=${M210} count=1024 2>/dev/null
dd if=/dev/zero of="imenik/podimenik/$dat3" bs=${M160} count=1024 2>/dev/null
dd if=/dev/zero of="imenik/podimenik/$dat4" bs=${M101} count=1024 2>/dev/null
dd if=/dev/zero of="imenik/podimenik/xxx/$dat5" bs=${M102} count=1024 2>/dev/null

touch -d    "2020-04-01 18:00" "imenik/$dat1"
touch -m -d "2020-04-02 18:00" "imenik/$dat1"

touch -d    "2020-03-28 9:00" "imenik/podimenik/$dat2"
touch -d    "2020-04-20 0:00" "imenik/podimenik/$dat3"

touch -d    "2020-04-10 0:00" "imenik/podimenik/$dat4"
touch -m -d "2020-04-05 0:00" "imenik/podimenik/$dat4"

touch -d    "2002-01-10 10:00" "imenik/podimenik/xxx/$dat5"
###########################

abs=$(pwd)

#./pocisti imenik -s 100 -d 5
izpis1="---
a.old.zip ${abs}/imenik/podimenik (210 MB) (23)
dn2_resitev.zip ${abs}/imenik/podimenik (160 MB) (0)
kratki film.mkv ${abs}/imenik (150 MB) (18)
x3.mkv ${abs}/imenik/podimenik/xxx (102 MB) (6675)
test ${abs}/imenik/podimenik (101 MB) (10)
---
skupaj 723 MB"

povezave1="out
├── 00101-test -> ${abs}/imenik/podimenik
├── 00102-x3.mkv -> ${abs}/imenik/podimenik/xxx
├── 00150-kratki film.mkv -> ${abs}/imenik
├── 00160-dn2_resitev.zip -> ${abs}/imenik/podimenik
└── 00210-a.old.zip -> ${abs}/imenik/podimenik

5 directories, 0 files"

#./pocisti imenik -s 100 -o type
izpis2="---
a.old.zip ${abs}/imenik/podimenik (210 MB) (23)
dn2_resitev.zip ${abs}/imenik/podimenik (160 MB) (0)
kratki film.mkv ${abs}/imenik (150 MB) (18)
x3.mkv ${abs}/imenik/podimenik/xxx (102 MB) (6675)
test ${abs}/imenik/podimenik (101 MB) (10)
---
zip 370 MB
mkv 252 MB
---
skupaj 723 MB"

povezave2="out
├── 0101-test -> ${abs}/imenik/podimenik
├── mkv
│   ├── 0102-x3.mkv -> ${abs}/imenik/podimenik/xxx
│   └── 0150-kratki film.mkv -> ${abs}/imenik
└── zip
    ├── 0160-dn2_resitev.zip -> ${abs}/imenik/podimenik
    └── 0210-a.old.zip -> ${abs}/imenik/podimenik

7 directories, 0 files"

#./pocisti imenik -s 100 -o 30
izpis3="---
a.old.zip ${abs}/imenik/podimenik (210 MB) (23)
dn2_resitev.zip ${abs}/imenik/podimenik (160 MB) (0)
kratki film.mkv ${abs}/imenik (150 MB) (18)
x3.mkv ${abs}/imenik/podimenik/xxx (102 MB) (6675)
test ${abs}/imenik/podimenik (101 MB) (10)
---
190 210 MB
100 203 MB
160 160 MB
130 150 MB
---
skupaj 723 MB"

povezave3="out
├── 100
│   ├── 0101-test -> ${abs}/imenik/podimenik
│   └── 0102-x3.mkv -> ${abs}/imenik/podimenik/xxx
├── 130
│   └── 0150-kratki film.mkv -> ${abs}/imenik
├── 160
│   └── 0160-dn2_resitev.zip -> ${abs}/imenik/podimenik
└── 190
    └── 0210-a.old.zip -> ${abs}/imenik/podimenik

9 directories, 0 files"

#########################################################################
# skupaj = 20  (20 dodatnih v skritih)
#######################################################################

which tree >/dev/null || {
    echo "Programa tree ni na sistemu. Namesti tree z ukazom 'sudo apt install tree'."
    exit 3
}

if ! [ -x pocisti ]; then
  echo "Datoteka z imenom pocisti ne obstaja ali pa ni izvršljiva."
  exit 4
fi


#clear

datum=$(date +%D)
#da bo izpis pravilen nastavimo datum na 20. april
sudo date -s "04/20/20 $(date +%H:%M:%S)" >/dev/null




tocke=0

#preverimo pravilnost nekaterih stikal ostale bom preveril s skritimi testi

tocke1=0
############################ Napaka: obvezno stikalo -s [3T]
izpis=$(./pocisti 2>&1)
status=$?
#ustrezni izhodni status
[ $status -gt 0 ] && tocke1=$(($tocke1+1))

#izpis napake na ustrezen izhod
izpis=$(./pocisti 2>&1 1>/dev/null)
[ -n "$izpis" ] && tocke1=$(($tocke1+1))

tocke=$((tocke+tocke1))
echo -e "Test: obvezno stikalo -s.\t\t\t\t\t$tocke1/2: skupaj=$tocke"


tocke1=0
################### ni argumenta [1T]

#izpis napake na ustrezen izhod
izpis=$(./pocisti -s 2>&1 1>/dev/null)
status=$?
[ -n "$izpis" ] && [ $status -gt 0 ] && tocke1=$(($tocke1+1))

tocke=$((tocke+tocke1))
echo -e "Test: ni argumenta.\t\t\t\t\t\t$tocke1/1: skupaj=$tocke"



tocke1=0
################### ni numerična vrednost [1T]

#izpis napake na ustrezen izhod
izpis=$(./pocisti -s a 2>&1 1>/dev/null)
status=$?
[ -n "$izpis" ] && [ $status -gt 0 ] && tocke1=$(($tocke1+1))

tocke=$((tocke+tocke1))
echo -e "Test: argument ni numerična vrednost.\t\t\t\t$tocke1/1: skupaj=$tocke"



tocke1=0
################### podani imenik obstaja [1T]

#izpis napake na ustrezen izhod
izpis=$(./pocisti taimenikneobstaja -s 100  2>&1 1>/dev/null)
status=$?
[ -n "$izpis" ] && [ $status -gt 0 ] && tocke1=$(($tocke1+1))

tocke=$((tocke+tocke1))
echo -e "Test: imenik ne obstaja.\t\t\t\t\t$tocke1/1: skupaj=$tocke"


rm -r out 2>/dev/null
tocke1=0
#pravilen izpis za $./pocisti imenik -s 100 -d 5 [5T]
izpis=$(./pocisti imenik -s 100 -d 5 | tail +6)
[ "$izpis" = "$izpis1" ] && tocke1=$(($tocke1+5))
tocke=$((tocke+tocke1))
echo -e "Test: pravilen izpis za $./pocisti imenik -s 100 -d 5.\t\t$tocke1/5: skupaj=$tocke"

tocke1=0
#pravilne povezave [2T]
povezave=$(tree out)
[ "$povezave" = "$povezave1" ] && tocke1=$(($tocke1+2))
tocke=$((tocke+tocke1))
echo -e "Test: pravilne povezave.\t\t\t\t\t$tocke1/2: skupaj=$tocke"


rm -r out 2>/dev/null
tocke1=0
#pravilen izpis za $./pocisti imenik -s 100 -o type [2T]
izpis=$(./pocisti imenik -s 100 -o type | tail +6)
[ "$izpis" = "$izpis2" ] && tocke1=$(($tocke1+2))
tocke=$((tocke+tocke1))
echo -e "Test: pravilen izpis za $./pocisti imenik -s 100 -o type.\t$tocke1/2: skupaj=$tocke"

tocke1=0
#pravilne povezave [2T]
povezave=$(tree out)
[ "$povezave" = "$povezave2" ] && tocke1=$(($tocke1+2))
tocke=$((tocke+tocke1))
echo -e "Test: pravilne povezave.\t\t\t\t\t$tocke1/2: skupaj=$tocke"


rm -r out 2>/dev/null
tocke1=0
#pravilen izpis za $./pocisti imenik -s 100 -o 30 [2T]
izpis=$(./pocisti imenik -s 100 -o 30 | tail +6)
[ "$izpis" = "$izpis3" ] && tocke1=$(($tocke1+2))
tocke=$((tocke+tocke1))
echo -e "Test: pravilen izpis za $./pocisti imenik -s 100 -o 30.\t\t$tocke1/2: skupaj=$tocke"

tocke1=0
#pravilne povezave [2T]
povezave=$(tree out)
[ "$povezave" = "$povezave3" ] && tocke1=$(($tocke1+2))
tocke=$((tocke+tocke1))
echo -e "Test: pravilne povezave.\t\t\t\t\t$tocke1/2: skupaj=$tocke"









#postavimo datum nazaj, da ne boste živeli v preteklosti (in posledično zamudili oddajo domače naloge)
sudo date -s "$datum $(date +%H:%M:%S)" >/dev/null
