# VAJE 1 

#### type, which, echo, printf, man, info, help, who

#### vgrajeni / nevgrajeni ukazi

`type -a ime_ukaza`

external commands are commands that run outside the shell, some (echo, printf, pwd) have both builtin and external versions
                    	                        
`which ime_ukaza` &nbsp; // path to program 

`help ime_ukaza` &nbsp; &nbsp; // built-in  
`man ime_ukaza` &nbsp; &nbsp; // external traditional  
`info ime_ukaza` &nbsp; &nbsp; // external modern

### izpis

`echo -e "OS,\n63180286\tJanez Novak,\nFRI" ` 
    -e enables \n, \t ...		   

`printf "OS,\nst\time priimek,\nsmer"`	   printf doesnt end with \n

### konzole

/dev/pts are pseudo-terminals (for remote...)
tty1 etc are virtual terminals

inside terminal Alt+F#, outside Ctrl+Alt+F# to switch between virtual terminals.



win 

# VAJE 2 
#### ls, tree, pwd, cd, mkdir, rmdir, cp, mv, rm, touch, file, stat, ln, readlink

### ls

`ls -l` 
tip datoteke in dovoljenja, st trdih povezav, lastnik & skupina, dolzina, datum, cas zadnje spremembe

Dolzina - koliko prostora na disku rabi za hranjenje metapodatkov za direktorij.

-h	Lepši in bolj razumljiv izpis velikosti datotek  
-I	Odstranimo določen vzorec datotek iz izpisa, npr. –I*.txt ne bo izpisal datotek s končnico txt  
-p	Ime imenika se zaključi z znakom / , da hitreje ločimo datoteke od imenikov  
-R	Rekurziven izpis. Izpišejo se tudi vsebine imenikov.  
-S	Uredi po velikosti datotek  
-t	Uredi po času spremembe datoteke  
-1	Izpis vsake datoteke v svoji vrstici  
-g	Izpis brez lastnika pri uporabi stikala -l  
-G	Izpis brez skupine pri uporabi stikala -l  
--group-directories-first	Najprej se izpišejo imeniki, šele nato datoteke

`ls -l -t -h -p -g -G`	lepse


### imeniki
`cd /`	root   
`cd or cd ~` user's directory (~)  
`cd . or ./` curent directory


### izvajanje datotek

poganjamo lahko z absolutno ali relativno potjo do datoteke.
Če napišemo samo ime datoteke in je ukaz vgrajen se takoj izvede, drugače pa se preveri po imenikih, ki so zabeleženi v $PATH.

### skripte

`#!/bin/bash` s katerim interpreterjem naj se izvede skripta  
`chmod +x skripta.sh` datoteko naredimo izvrsljivo  
`./skripta.sh`	ker trenutni direktorij verjetno ni naveden v $PATH pred imenom uporabimo ./			

### tree

`tree -dL 2 /`			 izpis imenikov(d), globine 1 (L 2), začenši v korenu 

### pwd

`/bin/pwd`nevgrajena razlicica iz izpisane poti odstrani simbolične povezave


### mkdir, rmdir

`mkdir -p `	p aka parents - make all required directories  
`rmdir -p`	p deletes all EMPTY directories in specified path, without only deletes last

### cp, rm, mv

`cp izvor ponor` copy file  
`mv izvor ponor`	move / rename file 

`rm [-fir] file/dir`	  
remove file/directory (-fr je lahko nevarno!)  
-f ... ignoriraj napake pri brisanju (nevarno)  
-i ... zahtevaj uporabnikovo potrditev za vsako brisanje  
-r ... rekurzivno brisanje podimenikov. (force - nevarno)

### basename, dirname

`basename pot [pripona]` pri podani poti ohrani le ime datoteke. Poleg tega odstrani še pripono datoteke, če je le-ta podana.   
`dirname pot`  ohrani le ime imenika

pri obeh ni nujno da datoteka obstaja


### touch
update the access date and/or modification date of a  file or directory

`touch [-am] [-d date] file/dir`

-a ... only update access date  
-m ... only update modification date  
-d ... input date


### file 

Ni nujno, da datoteka neposredno opisuje neke fizične podatke na pomnilnem mediju. Z datoteko je lahko predstavljena poljubna naprava, ki je zmožna delovati kot tok podatkov.

'-' navadna datoteka  
d - imenik  
b - bločno orientirana naprava trdi disk -  array of bytes on disk  
c - znakovno orientirana naprava terminal - pipe-esque  
l - simbolicna povezava  
p - pipe (mkfifo)  
s - socket  


### soft link, hard link - ln, readlink
simbolicna povezava (symbolic link, soft link) - "shortcut" do imenika / datoteke, ce jo izbrisemo povezava ostane, vendar kaze na null

trda povezava (hard link) - Ni praktične razlike med ustvarjeno trdo povezavo in originalno datoteko. 
Če spremenimo originalno datoteko, spremenimo tudi hard link!
Če želimo datoteko dokončno odstraniti, moramo pobrisati prav vse trde povezave nanjo.

`ln [-s] cilj povezava` s -s, se ustvari simbolična povezava, sicer pa trda.  
`readlink datoteka`	kam kaze mehka povezava?


### stat - file metadata

`stat stikala datoteka`  
-L ... sledenje povezavam;   
-c format ... nastavitev formata izpisa  
-t ... izpis v zgoščeni obliki.

*primer:*

`stat /etc/passwd -c "%n is %F owned by %U and last time changed at %z. Size of file is %s bytes."`  
  ->  
/etc/passwd is regular file owned by root and last time changed at 2009-01-28 20:01:04.000000000 +0100. Size of file is 2176 bytes. 


# VAJE 3

### sklaplanje ukazov

lahko s podpicji `pushd .; cd ~; ls;`

pri &&, || && nima prednosti!  
`echo 1 || echo 2 && echo 3` ... izvede se prvi in zadnji echo

*Primer (izvedejo se odebeljeni):* 

/home/student/

**cd ..** && **cd ..** || cd .. && **cd ..** || cd && **cd** || cd && **cd** 



**gleda se izhodni status zadnjega IZVRSENEGA**

`{ukazi;}` "samostojna celota"   
npr. `echo 1 || { echo 2 && echo 3; }` ... izvede se le prvi echo.  
Za zadnjim ukazom v {} mora biti podpicje, med vsemi operatorji in oklepaji mora biti vsaj en presledek.


### izvajanje v podlupini

Izvedemo skupino ukazov kot samostojen proces. Proces podlupine je potomec procesa lupine! Ukazi navedeni znotraj oklepajev se izvedejo, izhodni status podlupine, pa je enak statusu zadnjega izvedenega ukaza.

Spremenljivka `$?` označuje izhodni status zadnjega ukaza   
(0 ... OK, > 0 ... error)

npr.  `( echo izpis1 ) ; ( pwd ; exit 42 ; echo "Jaz se ne izvedem" ) ; echo $?`

Pogostejsa uporaba podlupine je 'substitucija ukaza'. Včasih želimo vsebino, ki jo ukazi v podlupini izpišejo na standardni izhod nadalje uporabiti v skripti. V tem primeru uporabimo

`$(ukazi)` or \`ukazi\`

#### uporabniki, skupine

mac os enter virtual console : `OPTION + FN + CONTROL + F*`  
mac os exit virtual console: `exit` `COMMAND + left`

inside terminal `Alt+F#`, outside `Ctrl+Alt+F#` to switch


#### prijave in uporabniki

`whoami` izpiše uporabniško ime s katerim smo trenutno prijavljeni 
`users` seznam vseh uporabnikov, ki so trenutno prijavljeni v sistem
`who [-Hlmru]`informacije o trenutno prijavljenih uporabnikih  
`w` informacije o trenutno prijavljenih uporabnikih + kateri proces poganjajo v ospredju

Prijave se beležijo v datotekah: */var/log/wtmp* in */var/log/btmp*

`last [-n num] [-F]` izpis uspešnih prijav   
`lastb [-n num] [-F]`izpis neuspešnih prijav  
`finger [user]`	info o trenutnem uporabniku  
`groups [uporabnik]` katerim skupinam pripada dani uporabnik  
`id [uporabnik]` izpiše identifikacijske številke skupin in uporabnika  
`sg [-l] skupina [-c ukaz]` zagon pod drugo skupino


### su, sudo
`su [-c ukaz] [-l] [uporabnik]` zamenja uporabnika s katerim smo trenutno prijavljeni z novim uporabnikom

`sudo [-u uporabnik] ukaz` izvrševanje ukazov pod drugimi uporabniki

Geslo uporabnika root je zaklenjeno. `sudo` (`gksudo` za grafične) za ukaz katerega pravico izvrševanja ima samo root . Sistem hrani geslo 15 min.

### administracija

Uporabniški računi: */etc/passwd*  
Kriptirana gesla: */etc/shadow*  
(sekundarne) Skupine: */etc/group*

struktura */etc/passwd*

1. username
2. geslo (x oznacuje da se kriptirano geslo nahaj a v /etc/shadow)
3. UID - 0 : root, 1-99 : drugi predefinirani uporabniki, 100-999 : sistemski uporabniki in skupine
4. GID - ID primarne skupine 
5. komentarji o uporabniku (za finger)
6. domaci imenik (ce ni definiran se uporabi /)
7. ukazna lupina

`grep janez /etc/passwd` izpis vrstice, ki vsebuje janez  
`cut -c 1-7 /etc/passwd` izpis znakov 1-7 vsake vrstice

### dodajanje, brisanje, spreminjanje uporabnika, skupine

**dodajanje uporabnika**

`useradd [stikala] uporabnik` *(sudo useradd janezn)*

Brez dodatnih argumentov ne ustvari ničesar več kot uporabnika - ne ustvari domačega imenika v /home in gesla.

`-m` ustvari domači imenik /home/janezn  
`-c` dodamo informacije, ki jih lahko izpišemo z ukazom finger  
`-d` nastavimo domači imenik (privzeto: /home/janezn)  
`-g` nastavitev osnovne uporabnikove skupine  
`-G` nastavitev dodatnih uporabnikovih skupin  
`-p` nastavitev uporabnikovega gesla  
`-s` nastavitev uporabnikove prijavne lupine  
`-u` nastavitev uporabnikove identifikacijske številke


`useradd -D` izpis privzetih vrednosti *(/etc/default/useradd)*


### adduser - bolj prijazen (interaktiven)
Privzete nastavitve so shranjene v datoteki: */etc/adduser.conf*

### geslo

`sudo useradd -m janezn`

Uporabnik nima definiranega gesla. V */etc/shadow*:  
:!: - uporabnik nima gesla in posledično se ne moremo se prijaviti v sistem  
:*: - uporabniški račun je zaklenjen  
:!!: - geslo je poteklo  

`sudo useradd –p $(mkpasswd geslo) janezn` slabo,  zgodovina ukazov se hrani -> `sudo passwd janezn` 

`mkpasswd --method=SHA-512 -S "your_salt"` produces your password in */etc/shadow*

### odstranjevanje uporabnika

`userdel [-r] uporabnik` -r odstrani njegov imenik

### spreminjanje uporabnika

`usermod` stikala uporabnik  

`usermod –c "Metka Novak" –d /home1/metkan –m metkan`  
-m premakne vsebino v nov imenik definiran s stikalom -d


### dodajanje / brisanje / spreminjanje skupine

`groupadd stikala skupina`  
`groupdel skupina`  
`groupmod stikala skupina`  

*primer:*   
`sudo groupadd osvaje`  
`sudo usermod –a -G osvaje student`  
za novega: `sudo useradd -G osvaje student`

*( addgroup - bolj prijazen vnos ) *

# VAJE 4 - zascita uporabe datotek

rwx - read, write, execute  
Dovoljenja so opisana v treh sklopih: 

1. lastnik datoteke  (U)
2. uporabniki, ki pripadajo skupini datoteke  (G)
3. vsi ostali uporabniki  (O)
   

Navadna datoteka - branje vsebine, pisanje v datoteko, izvajanje datoteke

Imenik - izpis imenika, ustvarjanje/brisanje datotek v imeniku, dostop do datotek v imeniku

### nastavitev lastnika in skupine - chown in chgrp

Ko ustvaris datoteko si njen lastnik.
Kasneje lahko lastnistvo spreminja le root.

`chown [-R] [lastnik][:][skupina] datoteka(e)`

`-R` vklopimo rekurzivno nastavitev dovoljenj (vse v imeniku, podimenikih)

`chgrp [-R] skupina datoteka(e)` skupino lahko spremeni tudi lastnik

### nastavitev dovoljenj uporabe datoteke: chmod

omogoča nastavitev dovoljenj za izvedbo operacij nad datoteko. Ukaz omogoča dva načina podajanja dovoljenj. 


Prvi način - podajanje dovoljenj v simbolni obliki:

`chmod [-R] [augo][+-=][rwxs] datoteka`

all user(owner) group other

`+` ... dodaj dovoljenje  
`-` ... odvzemi dovoljenje  
`=` ... nastavi dovoljenje  

Drugi nacin - stevilcna oblika:

`chmod [-R] vrednost datoteka`

vrednost = owner#:group#:other#  
vrednost z lepljivim bitom = lepljivi bit:vrednost

---		->		0  
--x		->		1  
r-x		->		5  
.
.

**STICKY BIT** - only the file/directory owner or the root user can delete or rename the file.  

Pri stevilcni obliki, stevila 1 3 5 in 7 podajo sticky bit vendar vsi razen 1 dodajo tudi nekatere druge bite (SUID, SGID)!

*Primeri:*

`chmod u=rwx struca.jpg` ... dovoljenja za lastnika  
`chmod g+r kruha.jpg` ... dodajanje branja za skupino  
`chmod 755 igra.sh` ... številčna oblika dovoljenj   
`chmod -R o+r naloge` ... ostali uporabniki,  rekurzija  
`chmod 1777 imenik/` ... dovoljena za imenik, lepljivi bit  


## osnove basha, spremenljivke, test

### spremenljivke

Tip vseh spremenljivk je niz. Deklariramo enostavno:
 `x=12`  
Pri tem je pomembno da ni presledkov ob enacaju, saj x ni ukaz!

Dva nacina uporabe spremenljivk v programu : 
`${var}` in `$var`

Podatek, ki ga spremenljivka vsebuje, mora biti združljiv z operacijo, ki jo izvajamo nad spremenljivko. (ne moremo sestevati nizov ki ne predstavljajo stevil..)

`unset ux` brisanje spremenljivke

### vgrajene (rezervirane) spremenljivke

`$_` - Zadnji argument predhodno izvedenega ukaza, le ob zagonu skripta vsebuje polno ime skripta.  
`$#` - Število podanih argumentov  
`$0` - ime skripte  
`${1}, ${2}, ...` - argumenti skripte   
`$?` - izhodni status zadnjega v ospredju izvedenega ukaza  
`$$` - PID lupine (najbolj zunanje, glavne)  
`$!` - PID zadnjega v ozadju zagnanega procesa  
`$*, $@` - vsi argumenti skripte   
`$-` opcije podane lupini, ki poganja skripto  

### spremenljivke okolja (shell variables)

Spremnljivke, ki se nastavijo ob zagonu lupine. (`man bash` - Shell Variables)

### test

Preko statusa vrne rezultat evaluacije izraza.

#### enakosti med nizi
`x = y` : preverimo če je niz x enak nizu y  
`x != y`: preverimo če x ni enak y  
`-n x` : preverimo če x ni ničeln (null)  
`-z x` : preverimo, če je x ničeln (null)  

#### enakosti med stevili
`x -eq / -ne / -gt / -ge / -lt / -le y`

`test $((1+9)) -eq 10 && echo "yes" || echo "no"`

#### preverjanje datotek
`-e datoteka` Ali datoteka obstaja?   
`-d datoteka` Ali je datoteka imenik?   
`-f datoteka` Ali je datoteka navadna datoteka?   
`-s datoteka` Ali velikost datoteke ni enaka 0?  
`-b datoteka` Ali je datoteka bločno-orientirana?   
`-c datoteka` Ali je datoteka znakovno-orientirana?   
`-h datoteka` Ali je datoteka simbolična povezava?   
`-L datoteka` Ali je datoteka simbolična povezava?   
`-r datoteka` Ali lahko datoteko (kot trenutni uporabnik) beremo  
`-w datoteka` Ali lahko v datoteko (kot trenutni uporabnik) zapisujemo?  
`-x datoteka` Ali lahko datoteko (kot trenutni uporabnik) poganjamo?  


#### narekovaji

`""` - obicajno za niz znakov

Če imamo spremenljivko znotraj `""`, se spremenljivka zamenja z svojo vrednostjo, pri `''` pa se dobesedno izpise ime spremenljivke.

\` \` - namesto `$( )` (podlupina)


# VAJE 5 - programiranje

bash je skriptni jezik - tolmaci se (prevaja sproti)

skripte - neinteraktivni nacin

```bash
#!/bin/bash
echo "testni izpis"
exit
```
Koncnica je po dogovoru .sh.  
Namesto tolmača */bin/bash* lahko uporabimo tudi npr. */bin/sh*, */usr/bin/python* ali celo */bin/cat*, */bin/rm*. 

`chmod +x skripta.sh` datoteko naredimo izvrsljivo  
`./skripta.sh`ker trenutni direktorij verjetno ni naveden v $PATH

### zaključek skripte

Vsak ukaz in skripta po končanem izvajanju vrne izhodni status izvajanja. Izhodni status je število med 0 in 127, oz. 128+n, če se je ukaz končal s signalom številka n. 0 - uspesno, > 0 - neuspesno  
Status zadnjega v ospredju ( foreground) izvedenega ukaza se nahaja v vgrajeni spremenljivki `$?`

`exit [status]`	eksplicitno konca izvajanje skripte

Če tega ukaza ni, se skripta konča, ko tolmač naleti na konec datoteke. V tem primeru je izhodni status enak statusu zadnjega izvedenega ukaza. Pravila lepega programiranja vseeno narekujejo, da se skripta konča z ukazom exit.

`exit` izhodni status skripte bo status zadnjega izvedenega ukaza
`exit 42` izhodni status skripte bo 42

*primer skripte ki pobrise vse datoteke:*
``` bash
#!/bin/bash
mkdir trash
mv * trash
rm -rf trash
mkdir trash
echo "Vse datoteke so zbrisane!"
```

### spremenljivke

Spremenljivke uporabljamo na dva nacina:  
`${var}` in `$var`

*Primeri nekaj zanimivejsih zamenjav:*

`echo ${ime:-veronika}` če ime ni definirano, potem izpiše veronika (spremenljivka ime se ne nastavi)  
`echo ${ime:=veronika}` če spremnljivka ime ni definirana, potem jo nastavi in izpiše

`stringZ=abcABC123ABCabc`

`${#stringZ}` dolžina niza: 15  
`${stringZ:position}` ali   `${stringZ:position:length}` kopiranje podniza    
`echo ${stringZ:0}` izpiše abcABC123ABCabc  
`echo ${stringZ:1}` izpiše bcABC123ABCabc  
`echo ${stringZ:7}` izpiše 23ABCabc  
`echo ${stringZ:7:3}` izpiše 23A  

*Opomba:* spremenljivka `$*` določa seznam vseh vhodnih argumentov:  
`echo ${*:2}`izpiše vse vhodne argumente ukaza od 2. naprej   
`echo ${*:2:2}` izpiše 2 argumenta od 2. Naprej

#### kopiranje podniza od desne
`${stringZ: -position}` ali   
`${stringZ: -position:length}` ali  
`${stringZ: (-position)}` ali   
`${stringZ: (-position):length}`

`echo ${stringZ:&nbsp(-4)}` Cabc  
`echo ${stringZ: -4}` Cabc

#### odstranitev podniza

`${string#substring}` odstrani najkrajše ujemanje podniza $substring s sprednje strani iz niza $string

`${string##substring}` odstrani najdaljse ujemanje podniza $substring s sprednje strani iz niza $string  

z zadnje strani niza:  `${string%substring}`in `${string%%substring}`  

`echo ${stringZ#a*C}` 123ABCabc  
`echo ${stringZ##a*C}` abc  
`echo ${stringZ%b*c}` abcABC123ABCa   
`echo ${stringZ%%b*c}` a  


#### zamenjava podniza

`${string/substring/replacement}` zamenja prvo ujemanje
`${string//substring/replacement}` zamenja vsa ujemanja

`echo ${stringZ/abc/xyz}` xyzABC123ABCabc

`${string/#substring/replacement}` zamenja začetek niza 
`${string/%substring/replacement}` zamenja konec niza 

`echo ${stringZ/#abc/XYZ}` XYZABC123ABCabc


##  if, case, while, for

### if

``` bash
if [ expression1 ];
then
   statement1
   statement2
   .
elif [ expression2 ];
then
   statement3
   statement4
   .
else
   statement5
fi
```

Zamik vrstic v desno omogoča večjo berljivost kode.

*Primer programa ki kopira datoteke iz direktorija*

``` bash
#!/bin/bash
if test -f /etc/blabla
then         
  cp /etc/blabla .
  echo "Končano."
else         
  echo "Datoteka ne obstaja"
  exit
fi
```
#### []

Namesto test lahko uporabimo `[]`.   
Pazimo na prazne presledke v oklepajih.   
Podpičje označuje konec ukaza  

`if [ "$ime" -eq 5 ]; then` dobro ce spremenljivke damo v ""

#### [[ ]]

V novejših inačicah BASH-a lahko pogoje evalviramo z `[[ ]]`. V tem primeru gre za sintaktično strukturo in ne ukaz.  
**Pozor: v izrazih tukaj velja prednost `&&` pred `||`.**

namesto   
`if [ "$spr1" -eq 5 ] && [ "$spr2" -gt 10 ]; then`  
lahko uporabimo   
`if [[ $spr1 -eq 5 && $spr2 -gt 10 ]]; then`

`[[ ]]` omogoca s pomocjo operatorja `=~` tudi regularne izraze. 


#### negacija

Znak ! s presledkom pred ukazom (ali skupino ukazov) negira izhodni status ukaza (ali skupine).

`! test a = b; echo $?`  status bo 0  
`! [[ a = a && b = b ]]; echo $?` status bo 1  
`! ls ~ ; echo $?`  status bo 1  


### case
``` bash
case  in
   Pattern 1) Statement 1;;
   Pattern n) Statement n;;
esac
```

*primer:*  

``` bash

#!/bin/bash
x=5 
case $x in
0) echo "Vrednost x je 0."
;;
5) echo "Vrednost x je 5."
;;
9) echo "Vrednost x je 9."
;;
*) echo "Nepoznana vrednost."
esac
```

### while

``` bash
while command
do
   statements
done
```

*Primeri:*

I.

``` bash
#!/bin/bash
while true; do	
   echo "Za izhod pritisni CTRL-C."
done
```
`true` je pocasen ukaz, ker ni vgrajen. hitreje bo z vgrajenim null ukazom `:`

``` bash
#!/bin/bash
while :; do
   echo "Za izhod pritisni CTRL-C."
done
```

II.

``` bash
#!/bin/bash
x=0; # prenastavimo x na 0
while [ "$x" -le 10 ]; do
   echo "Trenutna vrednost spremenljivke x: $x"
   x=$(expr $x + 1)
   sleep 1
done
```

`x=$(expr $x + 1)` x poveča za 1  
`$()`izvrši ukaz v oklepajih (v našem primeru: expr $x + 1)

III.

```bash
sort $1 | uniq | while read line; do
		echo $line
done 
```

### for

Struktura for omogoča ponavljamo po seznamu vrednosti.

``` bash
for var in word1 word2 ...wordn
do
   Statement to be executed
done
```

*Primeri:*

I.

``` bash
#!/bin/bash
echo -n "Kontrola sistema za napake"
for dots in 1 2 3 4 5 6 7 8 9 10; do
   echo -n "."
   sleep 1
done
echo "Sistem je pregledan." 
```

II.

``` bash
#!/bin/bash
for x in papir svincnik pero; do
   echo "The value of variable x is: $x"
   sleep 1
done 
```

III. uporabno - doda končnico .html vem datotekam v trenutni mapi

``` bash
#!/bin/bash
for file in *; do 
   echo "Dodaj koncnico .html datoteki $file..."
   mv $file $file.html
   sleep 1
done 
```
IV.  
```bash 
for ((i=24; i<=42; i++)); do echo -n "$i "; done
```

## aritmetika

Za izvajanje uporabimo ukaz `expr`, ki ni vgrajen in je pocasen. Uporabimo lahko `$((  ))` npr. `z=$(($x + $y))`


## testiranje in razhroscevanje

Lahko si pomagamo z dodatnimi izpisi posameznih spremenljivk med izvajanjem z echo.

 Lahko pa skripo poženemo v načinu s slednjem izvajanja ukazov. V tem načinu se bo vsaka vrstica (z že zaključeno substitucijo spremenljivk) izpisala v konzolo.

`bash -x skripta.sh`
ali 
`#!/bin/bash -x`

Če ne želimo izpisovati celotne skripte, lahko izpis vklapljamo in izklapljamo v kodi s `set -x` oz. `set +x`.

`bash -n` preverjanje sintakse skripte

## branje vhoda - read

``` bash
#!/bin/bash
echo -n "Vpisi svoje ime: "
read user_name
if [ -z "$user_name" ]; then
   echo "Nisi mi povedal svojega imena!"
   exit 10
fi
echo "Pozdravljen $user_name"
exit 0
```

Če na standardni vhod preusmerimo datoteko, bo read bral datoteko vrstico za vrstico.

``` bash
datoteka=$1
while read vrstica; do 
    echo $vrstica
done < $datoteka
```


# VAJE 6 - splosno iskanje, preusmerjanje in obdelava datotek

## splosno iskanje

`find [stikala] [imenik] [izraz]`

Isce datoteke v hiearhiji imenikov s korenom v *imenik*.

*nekaj stikal:*

`-P` ... ne sledi simboličnim povezavam (privzeto delovanje)   
`-L` ... sledi simboličnim povezavam  
`-H` ... ne sledi simboličnim povezavam, razen če je povezava podana kot argument ukaza  
`-depth` ... obdela poddirektorije preden obdela sam direktorij  
`-maxdepth globina` ... obdela le poddirektorije do podane globine   
`-mindepth globina` ... obdela le poddirektorje vsaj na podani globini  

*nekaj izrazov:*

`-false` ... neresnično  
`-true` ... resnično  
`-name vzorec` ... ime datoteke ustreza podanemu vzorcu  
`-iname vzorec` ... ime datoteke ustreza podanemu vzorcu (neobčutljivo na velikost črk)  
`-empty` ... datoteka je prazna (in je navadna datoteka ali imenik)  
`-size n[cwbkMG]` ... velikost datoteke je n, pri čemer je enota podane velikosti lahko naslednja:   
 b – 512B bloki, c – B, w – 2B besede, k – kB, M – MB in G – GB  
`-type tip` ... datoteka je podanega tipa    
`-perm dovoljenja` ... datoteka ima podana dovoljenja (-### najde rang dovoljenj)
`-amin n` ... zadnja uporaba datoteke je bila pred n minutami  
`-atime n` ... zadnja uporaba datoteke je bila pred n dnevi  

*primeri:*  
`find -name "MyCProgram.c"` iskanje v trenutnem imeniku  
`sudo find / -maxdepth 3 -name passwd`  
`sudo find / -iname *tmp –type f –exec ls –l {} \;`  
Na najdenih datotekah (ki se zakljucijo s tmp (case insensitive)) zelimo izvesti ukaz ls.  
*(znaka \; zaključita argumente ukaza ki ga želimo izvajati)*

`find -maxdepth 1 -not -iname "MyCProgram.c"` -not filtrira

https://www.grymoire.com/Unix/Find.html



## preusmerjanje in obdelava datotek

*vmesniki* 

· **standard input** z oznako stdin in datotečnim deskriptorjem 0,  
· **standard output** z oznako stdout in datotečnim deskriptorjem 1   
· **standard error** z oznako stderr in datotečnim deskriptorjem 2.

### preusmerjanje vhoda/izhoda

`ukaz < datoteka` Standardni vhod programa *ukaz* preusmerimo na datoteko z imenom *datoteka*, ki mora obstajati. Program bo podatke bral iz preusmeritvene datoteke namesto iz konzole.

`ukaz > datoteka` Standardni izhod programa *ukaz* preusmerimo na datoteko z imenom *datoteka*.
Na ta način izpis programa ujamemo v datoteko, pri tem se obstoječa vsebina datoteke **izgubi** oz. se ustvari nova datoteka, če le-ta še ne obstaja.

`ukaz >> datoteka` izpis se doda na konec datoteke (ne overwrite)

*Primeri:*

`echo "primer besedila" > dat.txt` … zapis niza v datoteko   
`cat < dat.txt` … datoteka kot standardni vhod ukaza cat   
`echo "dodamo na konec" >> dat.txt` … dodamo niz v datoteko   
`cat < dat.txt` … izpis datoteke


### cevovod
`ukaz1 | ukaz2` standardni izhod programa ukaz1 se poveže na standardni vhod programa ukaz2

Možno je sestavljati poljubno dolge cevovode. Izhodni status cevovoda je enaka izhodnemu statusu zadnjega programa.   
Vsi programi, ki so del cevovoda, se izvajajo vzporedno. Vsak program je samostojen proces, izvajan 
v pod-lupini.

`ls | sort -r` ... izpis vsebine imenika v nasprotnem abecednem redu

#### named pipe

`mkfifo poimenovan_cevovod`
Poimenovan cevovod lahko potem uporabimo s pomočjo preusmerjanja standardnega vhoda in izhoda, na primer:

`cat > cev`  
`cat < cev` 


#### splošno preusmerjanje

Splošno preusmerjanje - preusmerjanje iz poljubnega deskriptorja na nek že obstoječ deskriptor.  

1, in this context, is a file descriptor that points to the standard output (stdout).

`ukaz 1>datoteka` ... preusmerjanje deskriptorja 1 (ki kaze na standardni izhod stdout) na datoteko *datoteka*, kar je popolnoma enakovredno preusmerjanju standardnega izhoda (`ukaz > datoteka`). 

`ukaz 2>datoteka ` ali   
`ukaz 2>>datoteka` preusmerimo standardni izhod za napake

`ukaz &>datoteka` ali   
`ukaz 1>datoteka 2>&1` preusmerimo standardni izhod in standardni izhod za napake

`>&` is the syntax to redirect a stream to another file descriptor - 0 is stdin, 1 is stdout, and 2 is stderr.



*Primer:*  
`ls *.txt &> /dev/null && echo "so txt datoteke" || echo "ni txt datotek"`

Gre pravzaprav za dve preusmeritvi, prva je preusmeritev standardnega izhoda, druga pa preusmeritev standardnega izhoda za napake na že preusmerjeni standardni izhod.

Vrsti red preusmeritev je pomemben, ker se preusmeritve izvedejo od leve proti desni. Zgornji primer v nasprotnem vrstnem redu ne bi deloval. Brez `&` bi šlo za preusmeritev standardnega izhoda za napake na datoteko z imenom 1.

ls -l  2>izhod.txt 1>&2

*Se en primer:*  
`find /etc -iname "*.service" 1>services.txt 2>&1`  
1 is pointing at services.txt right from the beginning, so anything that pops into 2 gets piped through 1, which is already pointing to the final resting place in services.txt, and that is why it works.

Datoteka /dev/null je posebna datoteka, v katero lahko pišemo, vendar pa se zapisana vsebina nikamor ne shrani.


### preusmerjanje vhoda lupine

**here document** - začasno poveže trenutni vhod lupine s standardnim vhodom programa. Pri tem preusmeritev velja le toliko časa, dokler se v trenutnem vhodu ne pojavi vrstica, ki se začne s podanim ločilom.

`ukaz << ločilo` 

Če lupina izvaja neko skripto, potem je vhod lupine v resnici besedilo, ki se nadaljuje za ukazom do zaključne vrstice. Pri tem se pogosto uporablja ukaz cat.

`cat<<KONEC`   
Tukaj lahko napišemo poljubno besedilo.   
KONEC LONEC   
Lahko v več vrsticah, dokler se ne pojavi vrstica oblike:   
KONEC

*Kaj se v resnici zgodi? Ko se izvede cat<<KONEC, se opravi opisana preusmeritev, dokler v sledeči vrsticah ne nastopi ustrezno ločilo. Torej se vse nadaljnje vrstice do vrstice, ki vsebuje le KONEC, preusmerijo na standardni vhod ukaza cat. Ta ukaz pa na standardni izhod izpiše svoj standardni vhod, torej gre preprosta za več vrstični izpisa poljubnega teksta.  
Pri tem se moramo zavedati, da se znotraj preusmerjenega besedila izvede razširitev spremenljivk. Da se to ne zgodi, lahko preprečimo na tri načine: 
ločilo damo v enojne narekovanje, npr. 'KONEC', 
pred ločilo danomo nazaj-poševnico, npr. \EOF, 
pred vsako uporabo razširitve spremenljivke navedemo nazaj-poševnico, t.j. pred vsemi znaki $, npr. \$1.*

**here string** - razširi nek niz in ga dostavi programu na standardni vhod. Strogo gledano ne gre ravno za preusmerjanje vhoda lupine, vendar je uporaba zelo sorodna zgoraj opisanem načinu.   
`ukaz <<< niz`

### cat

*cat - concatenate files and print on the standard output*

`-b` . . . oštevilčenje nepraznih vrstic  
`-n` . . . oštevilčenje vseh vrstic  
`-s` . . . stisk zaporednih praznih vrstic   
`-E` . . . na koncu vsake vrstice bo dodan znak $   
`-T` . . . prikaz tabulatorjev z znakom ^I  
`-v` . . . prikaz neizpisljivih znakov  
`-A` . . . enakovredno -vET  
`-e` . . . enakovredno -vE   
`-t` . . . enakovredno -vT  

#### more, less
`more /etc/passwd` .. lahko se premikamo naprej, zaključimo s tipko q
`less /etc/passed` .. lahko se poljubno premikamo 


### head, tail

`head [-c stevilo] [-n stevilo] [-q] datoteka` … izpiše sprednji del datoteke  
`tail [-c stevilo] [-n stevilo] [-q] datoteka` … izpiše zadnji del  

`-c stevilo` … izpiše podano število bajtov   
`-n stevilo` (okrajšava -stevilo) … izpiše podano število vrstic   
`-q` … ne izpisuje imen ko podamo več datotek  

`seq 1 100 | head -n 2` … prvi 2 vrstici 
`seq 1 42 | tail -2` … zadnji 2 vrstici

`seq 1 42 | tail -n +2` … vse razen prve vrstica



pri head lahko uporabimo negativno število (od konca proti začetku):   
`seq 1 100 | head -n -7` … vse razen zadnjih 7 vrstic  

pri tail lahko uporabimo +stevilo (zahtevamo izpis od tega stevila naprej):  
`seq 1 666 | tail -n +665` … začnemo z 665. vrstico   
`seq 1 100 | tail -n +50 | head` … vrstice 50 do 59

# VAJE 7 - obdelava datotek

## obdelava vsebine datotek 

#### sort - urejanje po vrsticah

`-b` ... ignoriraj vodilne presledke;
`-d` ... ignoriraj vse razen presledkov in alfanumeričnih znakov;
`-f` ... ignoriraj velikost črk;
`-g` ... urejanje splošnih številskih vrednosti, npr. 15=0xF
`-i` ... ignoriraj nevidne znake;
`-n` ... urejanje številskih vrednosti;
`-R` ... urejanje v naključnem vrstnem redu;
`-r` ... urejanje v nasprotnem vrstnem redu;
`-s` ... stabilno urejanje;
`-u` ... izpiši samo prvega izmed enakih; in
`-z` ... vrstice končaj z bajtom 0 namesto EOL.

`ls -1 > ls.txt` ... najprej naredimo neko datoteko
`sort -r ls.txt` ... nato pa uredimo vsebino po obratnem vrstnem redu

#### shuf - generiranje nakljucne permutacije

`-e argumenti` … namesto datoteke permutiraj vhodne argumente
`-i razpon` … permutira števila od-do in
`-n stevilo` … izpiše do stevilo vrstic

`shuf -e alfa beta gama delta` … pomeša argumente
`shuf -i 13-666 -n 5` … iz pomešanega zaporedja izpiše prvih 5

#### uniq - odstranjevanje duplikatov

odstrani zaporedoma enake vrstice

`-c` … izpiše število ponovitev
`-d` … izpiše samo ponavljajoče vrstice
`-i` … ignorira velikost črk
`-u` … izpiše enolične vrstice

`cat /etc/passwd | cut -d: -f7 | sort | uniq -c` … število uporabnikov, ki uporabljajo določeno ukazno lupino

#### nl - oštevilčenje vrstic

#### tr - zamenjava znakov

`-c` … vzemi komplement
`-d` … briši znake iz niza
`-s` … stisni zaporedne ponovitve
`-t` … skrajša

`seq 1 10 | tr "\n" ","` .. 1,2,3,4,5,6,7,8,9,10,

`seq 1 10 | tr -d 13579 | tr -s "\n "` .. 2 4 6 8 0

`echo "Operacijski Sistemi" | tr a-z A-Z` ... OPERACIJSKI SISTEMI

#### split - delitev datoteke 

`split [stikala] [datoteka [predpona]]`

razdelitev datoteke na vec delov, privzeto razdeli datoteko v več datotek (predpona+pripona={aa,ab,ac}) do 1000 vrstic

*stikala:*

`-a dolzina` … uporabi pripone podane dolžine
`-d` … uporabi številčne pripone
`-l stevilo` … razdeli na podano število vrstic

`seq 1 100 | split -d -a 2 -l10 - stevila-`

Razdeli zaporedje števil od 1 do 100 v posamezne datoteke dolžine 10 vrstic (-l10), predpona naj bo stevila-, pripone pa naj bodo dvomestna (-a 2) števila (-d).

#### cut, paste - cut in paste

**cut **- *izločanje izbranih stolpcev iz datoteke*

`-c spisek` . . . izloči znake iz podanega spiska;
`-d locilo` . . . pri ločevanju polj uporabi podano ločilo; in
`-f spisek` . . . izloči polja iz podanega spiska 

*spisek* podamo v naslednji obliki:

- N … N -to polje (štejemo od 1 naprej);
- N1,N2 … polji N1 in N2;
- N-M … zaporedna polja od N do M ;
- N- … polja od N do konca vrstice; ali
- -M … polja od prvega do M tega.

`uname -a | cut -d" " -f1,3 `   izpis imena jedra OS

`cut -d: -f1 /etc/passwd `  izpis vseh uporabnikov iz datoteke /etc/passwd:

**paste - lepljenje stolpcev skupaj**

`cut -d: -f1 /etc/passwd > prvi`
`cut -d: -f3 /etc/passwd > tretji `
`paste tretji prvi`

#### join - naravni stik po določenem stolpcu

`join [-stikala] dat1 dat2`

`-1 št_stolpca` ... stik po podanem stolpcu iz prve datoteke
`-2 št_stolpca` ... stik po podanem stolpcu iz druge datoteke
`-t znak` ... določi ločilni znak med stolpci

Stolpca po katerih delamo stik morata biti sortirana.

#### column - urejanje izpisa v obliki stolpcev

*primer:*

`ps -e | column` ... izpiše rezultat v več stolpcih (najprej polni prvi stolpec, potem drugi, itd.)

`column /etc/passwd -t -s ":"`

*stikala:*

`-s` ... določi znake, ki se upoštevajo kot ločila stolpcev pri stikalu -t
`-t` ... ugotovi število stolpcev in izpiše tabelo; meje med stolpci so privzeto presledki
`-x` ... najprej polni vrstice



## ANALIZA VSEBINE DATOTEK

#### wc - štetje znakov, besed, vrstic

brez stikal: izpiše število vrstic, besed in bajtov v podani datoteki

*stikala:*

`-c` … izpis števila bajtov
`-m` … število znakov
`-l` … število vrstic
`-L` … izpis dolžine najdaljše vrstice
`-w` … število besed

#### cmp, diff - primerjava vsebine datotek 

`cmp dat1 dat2` ... primerja dve datoteki. Ce sta enaki vrne status 0. Ce sta razlicni izpise razliko in vrne status 1.

`-s` … utišamo izpis

`cmp –s dat1.txt dat1.txt ; echo $?`

`diff dat1 dat2` ... zraven izpise se vrstice kjer se datoteki razlikujeta



#### grep - iskanje po vsebini

`grep vzorec [datoteka]`

V datoteki išče vzorec, ki je lahko niz ali regularni izraz.

`-i` … iskanje neodvisno od velikosti črk
`-w` … ujemanje s celo besedo
`-l` … izpiše samo datoteko v kateri je našel ujemanje in ne vrstic
`-r` … preišče datoteke v trenutnem imeniku in vse h podimenikih
`-n` … poleg vrstic izpiše še številko vrsti
`-v` … izpiše vrstice ki NE vsebujejo podanega vzorca
`-c` … izpiše število pojavitev v vrsticah in ne izpis vrstic

`ps -e | grep firefox` izpis procesa ki vsebuje besedo firefox

#### tee - izpis v vec datotek

Ukaz bere iz standardnega vhoda in izpisuje na standardni izhod ter v datoteke, ki jih podamo kot argumente.

`tee dat1 dat2 ... datN `

`-a` ... vsebine datoteke ne prepišemo, ampak vanjo dopišemo

#### xargs - izvajajnje ukaza nad vrsticami iz standardnega vhoda

`xargs ime_ukaza` 

`-0` ... kot ločilo med vhodnimi nizi vzame nulti znak (namesto presledka)
`-I zamenjalni_niz` ... zamenja pojavitve zamenjalnega_niza v ukazu s posameznimi vhodnimi nizi, ki jih dobi preko standardnega vhoda
`-p` ... preden izvede ukaz zahteva potrditev

*primer:*

`echo dat1 dat2 dat3 | xargs cat` ... xargs na standardnem vhodu dobi seznam datotek, nad katerimi izvede ukaz cat.

`echo dat1 dat2 dat3 | tr " " "\n" | xargs -I {} -p ln -s {} {}_link` ... xargs na standardnem vhodu dobi seznam datotek in na posamezni datoteki izvede ukaz ln, ki ustvari simbolično povezavo s pripono _link na izvorno datoteko.



# VAJE 8 - funkcije, procesi in signali

## funkcije

V BASH-u lahko definiramo funkcije, ki jih potem uporabljamo enako kot ostale ukaze. Funkcije je potrebno definirati preden jih uporabimo. Obstajata dva načina definiranja funkcij:

```bash
function ime_funkcije { ukazi }
ime_funkcije () { ukazi } 
```


Funkcijo pokličemo preprosto po imenu (kot ostale ukaze): `ime_funcije`

V tem primeru se funkcija izvede v isti lupini. Lahko pa jo izvedemo v podlupini in tudi shranimo izpise funkcije (kot pri ostalih ukazih):

```
(ime_funkcije)
izpis=$(ime_funkcije)
```



*Primer:*

```bash
#!/bin/bash
hello()
{
  echo " si="" v="" funkciji="" hello()"
}

echo "Klicanje funkcije hello()..."
hello
echo "Prišel si iz funkcije hello()"
```



**Funkcija mora biti definirana preden jo kličemo...**

*Drugi primer:*

```bash
#!/bin/bash
# admin.sh – administrativno orodjel
# funkcija nov_uporabnik() ustvari nov uporabniski racun

nov_uporabnik()
{
  echo "Priprava na dodajanje novega uporabnika..."
  sleep 2 
  read ime
  sudo adduser $ime      # izvrsi program adduser
}

echo "1. Dodaj uporabnika"
echo "2. izhod"
echo "vnesi izbiro: "
read choice
case $choice in
  1) nov_uporabnik       # klic funkcije nov_uporabnik()
     ;;
  *) exit
     ;;
esac
```

Argumenti, ki jih podamo funkciji, so znotraj funkcije dostopni z enakim mehanizmom kot argumenti skripte ($1, $2 itd.). 
Funkcijo zaključimo z ukazom return:

```
return [vrednost]
```

Ce v funkciji vrnemo neko vrednost (0-255) bo ta dostopna kot izhodni status, če pa ni return-a, bo status enak izhodnemu statusu zadnjega ukaza. 

*Primer funkcije, ki izračuna fakulteto:*

```bash
function factorial {
  if (( $1 <= 1 )); then
    return 1
  else
    factorial $(( $1 - 1 ))
    return $(( $1 * $? ))
  fi
}

factorial $1
echo $?
exit
```

Vendar pa prek statusa (ki je omejen na vrednosti od 0 do 255) ne smemo vračati rezultatov funkcije. Rezultat funkcije lahko izpišemo na standardni izhod, funkcijo kličemo v podlupini in nato prestrežemo izpis te funkcije:

```bash
#!/bin/bash
function fakulteta {
  if (( $1 <= 0 )); then
    echo 1
  else
    rez=`fakulteta $(( $1 - 1 ))`
    echo $(( $1 * $rez ))
  fi
} 

echo `fakulteta $1`
exit 
```



**Vidljivost spremenljivk**

```bash
#!/bin/bash
function funkcija () { 
  a=vrednost1 
}

echo $a     # spremenljivka a ni definirana
funkcija
echo $a     # spremenljivka a vsebuje vrednost1
```



Če želimo, da spreminjanje vrednosti spremenljivke a ni vidna izven funkcije, jo deklariramo kot local ali pa poženemo funkcijo v podlupini.

```bash
#!/bin/bash
function funkcija () {
  local a=vrednost1
}
echo $a     # spremenljivka a ni definirana
funkcija
echo $a     # spremenljivka a ni definirana 
```

```bash
#!/bin/bash
function funkcija () {
  a=vrednost1
}

echo $a     # spremenljivka a ni definirana
(funkcija)
echo $a     # spremenljivka a ni definirana

```

Če želimo, da je spremenljivka (in njena trenutna vrednost) vidna kot okolijska spremenljvika v programih, ki so potomci naše lupine, potem uporabimo export: `export ime_spremenljivke`

Vendar pa se vrednost prenese ob zagonu programa in se ne spreminja, če se spremeni njena vrednost v izvorni lupini. Prav tako se nobena sprememba v programih, ki so potomci izvorne lupine, ne vidi v ostalih programih in izvorni lupini.



## procesi 

proces ... izvajajoči se program

večopravilni sistem ... hkrati se izvaja več procesov

razvrščevalnik ... omogoča delitev procesorskega časa med več procesov

Pojmi povezani s procesi:

- strojna koda
- identiteta procesa (PID, lastnik, skupina procesa)
- okolje procesa (argumenti in okoljske spremenljivke)
- kontekst procesa (stanje, prioriteta, registri, sklad, odprte datoteke, itd.)

#### pidof in pgrep - izpis PIDa procesa

##### pidof

`pidof proces` ... izpise PID procesa

Stikala: 

`-s` ... izpise PID samo enega procesa

`-o pid` ... ignorira procese z danim PIDom

`-x` ... pregleda tudi procese lupinskih skript

*Primer (vkljucimo vec terminalov)* 

`pidof bash` … izpiše PIDe vseh terminalov;
`pidof –s bash` … izpiše samo enega.

```bash
if pidof –x –o $$ $(basename $0); then
  echo "skripta ze tece"
  exit 1
fi
```

Spremenljivka`$$`hrani PID procesa, v katerem se spremenljivka kliče. Spremenljivka `$0` pa nosi ime programa, ki se izvršuje. Da dobimo res samo ime, se kliče basename.

**pgrep** 

Iskanje PIDov po vzorcu

Stikala:

`-u uporabnik` … izbiranje po uporabniku;
`-g skupina` … izbiranje po skupini;
`-t term` … izbiranje po terminalu;
`-P ppid` … izbiranje po PPID;
`-n` … najnovejši;
`-o` … najstarejši;
`-c` … izpiše le število izbranih procesov;
`-d niz` … za ločilo se uporabi niz;
`-l` … izpiše tudi ime procesa.

*Primeri:*

`pgrep –nl` … izpiše številko in ime zadnjega procesa;
`pgrep –ol` … izpiše številko in ime procesa, ki se ustvari kot prvi proces v OSu in je prastarš vseh procesov. Kateri proces je to?
`pgrep –cP 1` … izpiše število procesov, katerih oče je proces INIT;
`pgrep –d ", " –lu root ".*/."`
Izpiše vse procese uporabnika root, ki imajo na predzadnjem mestu poševnico = sistemski procesi, ki se izvajajo na več procesorjih. Številka označuje procesor.



#### Navidezni imenik */proc/PID*

Ko nastane nov proces, se ustvari tudi podimenik v imeniku */proc* s število procesa. Vsebina imenika so datoteke s podatki o procesu:

`cmdline` - ukazna vrstica procesa (argumenti so ločeni z znakom \0);
`cwd` - simbolična povezava na trenutni delovni imenik;
`environ` - seznam okoljskih spremenljivk in njihovih vrednosti (ločilo je \0);
`exe` - simbolična povezava na program procesa;
`stat` - informacije o kontekstu procesa;
`status` - enako kot stat (bolj razumljivo);
`fd` - simbolične povezave na odprte datoteke;
`task` - vsaka nit ima svoj podimenik.

*Primeri:*

1. konzola: 

```
$ vi pocitnice.txt
```

2. konzola:

```
$ pidof vi
2359
$ cd /proc/2359
$ cat cmdline | tr "\0" " "
$ cat environ | tr "\0" "\n"
$ readlink exe
$ cat status | grep Pid
```



#### ps - informacije o procesih

`ps` … izpiše procese trenutnega uporabnika v trenutnem terminalu.

Stikala:

`-A` ali `-e` … izpis vseh procesov;
`-C ime` … izbira po imenu procesa;
`-U` … uporabnik;
`-G` … skupina;
`-p` … pid;
`-t` … terminal;
`-N` … negacija izbire.

Stikala za izpis:

`-f` … polni izpis;
`-l` … dolgi izpis;
`-j` … izpis opravil v lupini;
`-H` … izbira hierarhije
`-o polja` … nastavitev izpisa polj (pid, ppid, user, priority, size);

*Primer izpisa procesov uporabnika student:*

`ps –u student –o ppid,user,priority,size`

#### top - dinamicni izpis procesov 

Nenehen izpis procesov.

`q` izhod, `h` pomoc

top -o %CPU

#### pstree - izpis hiearhije procesov 

pstree 1
pstree $$

#### Zagon programa v ospredju ali ozadju 

Zaganjanje v ospredju je privzeto (lupina takoj kliče wait in čaka, da se program konča).

Da program poženemo v ozadju, ga pokličemo z znakom & . Po zagonu procesa (otroka) se izpiše PID in izvajanje se vrne staršu (lupini). Ko se otrok konča, postane t.i. zombi in to sporoči staršu, ki kliče funkcijo wait (in oprazuje status), da se je program končal.

*Primer zagona v ozadju:*

`sleep 5 &`

Opomba: proces takoj zaspi za 5 sekund, ker teče v ozadju (znak &), potem se v lupini izpiše številka PID in nadzor se vrne lupini. Ko se proces zaključi (po 5 sekundah), vrne lupini signal (SIGCHLD). Obvestilo o koncu se bo izpisalo, ko se bo ponovno izpisal pozivnik (pritisnemo tipko Enter).

#### jobs - izpis tekocih poslov

Izpis seznama procesov v ozadju v trenutni lupini.

Stikala:

`-l` … izpiše še PID
`-p` … izpiše samo PID
`-n` … izpiše samo nove procese (od zadnjega klica ukaza)

*Primer:*

```
xeyes &
xclock &
sleep 100
jobs -l
```



#### Premik procesa v ospredje ali ozadje

**fg** - postavljanje procesa v ospredje, **bg** - postavljanje procesa v ozadje

```
$ sleep 10 &
[3] 123
$ fg 3
```

#### Cakanje na konec procesa

Ustvarimo dva (speča) procesa in počakamo na krajšega:

```
{ sleep 10 & } ; { sleep 5 & }
```

`wait PID-drugega` … čakanje na drugega;
`wait` … čakanje na vse otroke;
`wait 123; echo $?` … izhodni status je 127 = proces nima otrok.

#### Ukaz sleep

Uporabimo ga v ukazih, kjer hočemo, da se določeno opravilo zgodi čez določen čas.

*Primer: če želimo, da se nekaj izvrši vsakih 5 minut, v zanko dodamo stavek: `sleep 5m`.*



## signali

Signal je kratko "sporočilo" (označimo ga s številom od 1 do 64, odvisno od vrste Unixa), ki ga pošljemo nekemu procesu. Signal lahko posamezen proces pošlje programsko z ustreznim sistemskim klicem. Nekatere signale generirajo dogodki v terminalu (pritisk Ctrl-C, Ctrl-Z), druge dogajanje s procesi (ukinitev).

#### Vrste signalov

Začetne številke signalov so rezervirane, njihov pomen je definiran po različnih standardih (POSIX, ANSI, 4.2 BSD), pripisana so jim tudi simbolična imena. Nekaj zanimivejših signalov:

`Številka : Oznaka : Privzet odziv`

 `1 : SIGHUP : exit` 	   Hangup. Signalizira ukinitev pripadajočega terminala. 
 `2 : SIGINT : exit` 	   Prekinitev procesa (Ctrl+C). 
 `3 : SIGQUIT : core`      Ukinitev procesa (Ctrl+\). 
 `4 : SIGILL : core` 	   Napačen ukaz procesorja. 
 `8 : SIGFPE : core`	    Izjema pri delu s števili v plavajoči vejici. 
 `9 : SIGKILL : exit`      Brezpogojna ukinitev procesa. 
`10 : SIGUSR1 : exit`     Prvi uporabniški signal. 
`12 : SIGUSR2 : exit`     Drugi uporabniški signal. 
`13 : SIGPIPE : exit`     Neuspeh pri pisanju v cev ali vtičnico. 
`14 : SIGALRM : exit`     Alarm. 
`15 : SIGTERM : exit`     Ukinitev procesa. 
`17 : SIGCHLD : ingore` Obvestilo staršu o ukinitvi otroka. 
`18 : SIGCONT : ignore` Nadaljuje ustavljen proces. 
`19 : SIGSTOP : stop`     Brezpogojna (začasna) ustavitev procesa. 
`20 : SIGTSTP : stop` 	(Začasna) ustavitev procesa (Ctrl+Z). 
`21 : SIGTTIN : stop` 	Proces v ozadju skuša brati s terminala. 
`22 : SIGTTOU : stop` 	Proces v ozadju skuša pisati na terminal.

#### Rokovanje s signali

V tretjem stolpcu zgornje tabele navajamo tudi privzeti odziv prejemnika na signal. Možni so naslednji odzivi:

`core` – zapis pomnilniške slike prejemika na disk;
`exit` – ukinitev prejemnika;
`ignore` – ignoriranje signala; in
`stop` – ustavitev prejemnika.

Privzeti odziv na določen signal lahko spremenimo tako, da za signal nastavimo svoj *rokovalnik*. Pri tem za nekatere signale ni mogoče spreminjati rokovalnika, npr. `KILL` in `STOP`.

`trap rokovalnik INT` ... prestrežemo signal INT in pokličemo funkcijo rokovalnik.

#### Signali v ukazni lupini

**kill - pošiljanje signalov**

Signal številka *NUM* lahko pošljemo procesu *PID* z ukazom `kill -NUM PID`

Na naslednji način pa lahko uporabimo tudi simbolično ime signala: `kill -s SIG PID`

Če ne podamo vrste signala, se privzame signal SIGTERM. Spisek signalov dobimo z ukazom `kill -l` ali pa `trap -l`

*Primeri:*

`kill 12345` ... Zaustavitev procesa s PID=12345
`kill -KILL 12345` ... Brezpogojna ukinitev procesa.
`kill -9 -1` ... Ukinitev vseh procesov, ki jih lahko.
`kill %1` ... Zaustavitev opravila št. 1

`kill -l 2` ... Zanima nas oznaka signala 2.
INT

`kill -l SIGCONT` ... Zanima nas številka signala SIGCONT.
18

**pkill - posiljanje signalov (naprednejsa izbira procesov)** 

`pkill [stikala] vzorec`

`-signal` . . . vrsta signala;
`-u uporabnik` . . . izbiranje po uporabniku;
`-g skupina` . . . izbiranje po skupini;
`-t term` . . . izbiranje po terminalu;
`-P ppid` . . . izbiranje po PPID;
`-n` . . . izbira najnovejšega procesa;
`-o` . . . izbira najstarejšega procesa;
`-v` . . . negacija izbire; in
`-x` . . . natančno ujemanje vzorca z imenom procesa.

**killall**

Ukaz pošlje signal procesom, katerih ime je enako podanemu.

`killall [stikala] ime`

`-I` . . . ignoriraj velikost črk;
`-i` . . . zahtevana potrditev pred pošiljanjem signala;
`-q` . . . ne sporoča napak;
`-r` . . . podano ime je regularni izraz;
`-s signal` . . . pošiljanje signala; in
`-w` . . . počaka na izbrane procese, da se ukinejo.

Podobno kot kill deluje tudi killall:

`killall -NUM PROG`
`killall -SIG PROG`

Kako bi preprečili zapiranje otroka, če zapremo njegovega starša (kadar starš pošlje signal SIGHUP)? 

`nohup gedit &` 

#### Prestreganje signalov

V programu lahko uporabimo ukaz `trap`, da prestrežemo signal. Na ta način preprečimo npr. nenaden zaključek programa, ki ga je povzročil zunanji signal.

Na primer: če s pomočjo kombinacije tipk CTRL-C pošljemo prekinitveni signal, ga lahko s pomočjo ukaza trap zaznamo in se odločimo ali bomo program res zaključili ali želimo nadaljevati.

`trap akcija signal`

**ukaz trap**

 `trap -l` - seznam vseh signalov

Pri pisanju imena signala lahko izpustimo prve tri črke (običajno SIG).

*Primer prestreganja signala:*

V spodnji skripti je prekinitveni signal SIGINT (oz. INT ali samo numerčno 2).

```bash
#!/bin/bash
# uporaba ukaza trap
# ulovi signal CTRL-C in izvedi funkcijo sorry():
trap sorry INT

sorry()
{
   echo "Tega ne morete narediti."
   sleep 3
}

for i in 10 9 8 7 6 5 4 3 2 1; do    # odstevaj od 10 do 1:
  echo "$i sekund do sistemske napake."
  sleep 1
done

echo "Sistemska napaka."
```



Če uporabimo: `trap - INT` s tem resetiramo ukaz trap (povrnemo signal v prvotno stanje). 										Če uporabimo: `trap '' INT` ne bomo reagirali na signal (program se bo nadaljeval, kot da ni bilo signala).



#### prioriteta ukaza: nice in renice

Ukaz lahko z zvišano ali z zmanjšano prioriteto poženemo s pomočjo ukaza `nice`. Večja številka pomeni nižjo prioriteto. Manjša vrednost (negativna) pa pomeni, da ima proces višjo prioriteto pri izvajanju – to pomeni, da mu bo razvrščevalnik namenil več procesorskega časa. Vrednost lahko zmanjša samo root. Kadar ukaz že teče, lahko spremenimo njegovo prioriteto z ukazom `renice`.

Primer: poženemo ukaz `sort` z nižjo prioriteto, da ne obremenimo sistema:

`nice -n 10 sort input.txt > output.txt`

če program že teče:

`renice -10 `pid_of_process`



# VAJE 9 - izvajanje po urniku, datotečni sistem

#### select

Z ukazom **select** lahko ustvarimo preprost **meni**.

```bash
select var in spisek; do 
   ukazi
done
```



## sinhronizacija

#### lockfile - datotečni semafor

`lockfile datoteka` ... "vstop v semafor"

V lupini bash ni nekega neposrednega mehanizma za uporabo semaforjev. Obstaja mehanizem zaklepanja datotek, ki ga lahko izkoristimo na zanimiv način. Neko datoteko lahko zaklenemo le, če ta ni že predhodno zaklenjena. Podobno je s semaforjem, v katerega lahko vstopimo, če je semafor prost. Zato mehanizem zaklepanja datoteke lahko uporabimo za implementacijo semaforja.

Zaklepanje datoteke torej predstavlja vstop v semafor. Če je datoteka že zaklenjena, potem je potrebno na vstop v semafor počakati. Izstop iz semaforja je predstavljen z brisanjem datoteke. Ime same datoteke predstavlja tudi ime semaforja.

Ukaz torej izvede operacijo vstopa v semafor. Če vstop ni mogoč, potem počaka nekaj časa in ponovno poskuša (privzeto 8 sekund).

`rm -f datoteka` ... "izstop iz semaforja" (-f, ker imajo datoteke, ki jih ustvari lockfile, dovoljenje le za branje.)

```bash
lockfile myscript.lock
# zacetek kriticnega odseka 
. . .
# konec kriticnega odseka 
rm −f myscript.lock
```

*Primer:*

Zagotoviti hočemo, da sočasno dostopa do določenega vira samo 1 proces. Ukaz lockfile ustvari datotečni semafor, ki ga na koncu kritične koda odstranimo. Lockfile počaka 8 sekund in nato ponovno preveri, če datoteka še vedno obstaja.

```bash
#!/bin/bash
if [ -e number.txt ]; then
   echo "Datoteka obstaja"
else
   echo "Datoteke ni, zato ustvarimo novo"
   echo 1 > number.txt
fi 

lockfile script.lock
a=$(/usr/bin/tail -n 1 number.txt)
if [ $a -gt 1 ]; then
   a=$(/usr/bin/tail -n 1 number.txt)
   expr $a - 1 >> number.txt
fi
if [ $a -lt 2 ]; then
   a=$(/usr/bin/tail -n 1 number.txt)
   expr $a + 1 >> number.txt
fi
rm -f script.lock
```



#### flock

V nadaljevanju si bomo ogledali dva različna načina uporabe ukaza flock. Prvi način uporabe ukaza je naslednji:

`flock datoteka -c ukaz`

Ta način bomo uporabili, kadar bomo kritični odsek implementirali s funkcijo. Naj se ta funkcija imenuje *kriticniodsek*. Funkcijo je potrebno še izvoziti in nato lahko uporabimo flock na naslednji način:

```bash
function kriticniodsek {
   # tukaj implementiramo kriticni odsek
}

export −f kriticniodsek              # izvozimo funkcijo
flock semafor.lock −c kriticniodsek  # uporabimo datoteko semafor.lock za zaklepanje 
```



Drugi način je morda bolj preprost za uporabo, vendar je potrebno poznavanje datotečnih deskriptorjev.

Uporaba   je sledeča:

`flock deskriptor`

Kritični odsek implementiramo in izvedemo v podlupini, v kateri tudi takoj izvedemo zaklepanje datoteke preko datotečnega deskriptorja. Še pred tem pa je potrebno datotečni deskriptor pripraviti.

Celotna shema uporabe je sledeča:

```bash
(  
   flock 200
   # tukaj implementiramo kriticni odsek
) 200>semafor.lock
```



## zakasnjeno izvajanje ukazov (izvajanje po urniku)

#### at - izvajanje ukazov z zamikom

Ukaz prebere ukaze, ki naj jih izvede iz standardnega vhoda. Kot parameter mu moramo podati, kdaj naj te ukaze izvede. Ukazi se bodo izvedli v lupini */bin/sh*

`at 23:45` - podamo uro, kdaj naj se izvede

`at Jul 2` - podamo datum 

`at 02.07.12` - druga možnost za datum

`at 10am Jul 2` - podamo datum in uro

`at now + 5 hours` - izvedemo čez 5 ur

`at 10am + 3 days` - izvedemo čez 3 dni ob 10h zjutraj

Stikalo:

`-f datoteka` ... podamo datoteko, v kateri so zapisani ukazi, ki naj jih izvede

#### atq - pregled vrste za izvajanje

Izpiše seznam nalog, ki čakajo v vrsti. Vsaka vrstica vsebuje zaporedno številko, kdaj se bodo ukazi izvršili, oznako vrste in ime uporabnika.

#### atrm - brisanje naloge iz vrste

`atrm stevilka_naloge`

#### cron, crontab - periodično izvajanje ukazov


Z ukazom `crontab` lahko popravljamo datoteko, kamor lahko zapišemo ukaze, ki bi jih radi izvajali periodično npr. enkrat na dan. Proces `cron` vsako minuto preveri vse datoteke crontab in izvede ukaze, ki so na vrsti za izvajanje.

stikala ukaza crontab :

`-l` ... izpiše trenutno nastavitev crontaba - kateri ukazi se izvršujejo in kdaj 

`-r` ... zbriše trenutno nastavitev

`-e` ... odpre urejevalnik, kjer lahko dodamo/popravimo nastavitve

Vrstica v nastavitvah crontaba je sestavljena iz šestih stolpcev:

`minuta(0-59)  ura(0-23)  dan(1-31)  mesec(1-12)  dan_v_tednu(0-6, 0=nedelja)  ukaz`

*Primeri vrstic:* 

`10  11  5  4  1  /usr/bin/program`

Datoteka /usr/bin/program se bo zagnala ob 11:10 dne 5. aprila in poleg tega tudi vsak ponedeljek v aprilu. 

`10  11  *  *  *  /usr/bin/program`

Datoteka /usr/bin/program se bo zagnala ob 11:10 vsak dan v vsakem mesecu. 

`10,20  11,12  5-10  4,6  * /usr/bin/program`

Datoteka /usr/bin/program se bo zagnala ob 10 in 20 minut čez 11 in 12 na dneve od 5. do 10. aprila in junija. 

`*/10  *  *  *  *  /usr/bin/program`

Datoteka /usr/bin/program se bo zagnala vsak dan, vsakih 10 minut (ko bodo minute deljive z 10 - minute bodo enake 0,10,20,30,40 ali 50)

**Opomba: **

Za zadnjo vnešeno vrstico v datoteki mora biti obvezno vsaj še ena (lahko prazna) vrstica. V nasprotnem primeru se ta vrstica ne bo izvajala.



## priklapljanje datotečnih sistemov

Priklop datotečnega sistema v določen imenik: **mount**

Odklop datotečnega sistema: **umount**

V Linuxu lahko dostopamo do datotek na npr. CD-ROMu tako, da datotečni sistem CD-ROMa priklopimo na določen imenik na našem datotečnem sistemu. Datoteke, ki so na CD-ROMu bodo potem vidne znotraj tega imenika. Po zaključenem delu moramo pred odklopom naprave uporabiti ukaz `umount`, saj se sicer pri zunanjih diskih ali usb ključih lahko zgodi, da vsebina na njih še ne bo pravilna, če smo jo kaj popravljali. Z ukazom umount sistemu povemo, da naj takoj zapiše vse manjkajoče podatke na napravo, saj bi jo radi odklopili.

Uporaba:

`mount naprava imenik`

Kot napravo navedemo datoteko iz imenika */dev/*, ki predstavlja želeno napravo, kot imenik pa lokacijo, kamor bi radi priklopili datotečni sistem naprave.

Primer:

`mount /dev/cdrom /cdrom`

Stikala:

`-t tip` ... tukaj podamo tip datotečnega sistema naprave. Če tega stikala ne podamo, ga poskusi ugotoviti samodejno.

V datoteki */etc/fstab* so lahko shranjeni podatki o tem, katere naprave se priklopijo na kateri imenik vključno z vsemi parametri. 

Tako lahko, recimo, če v tej datoteki obstaja vrstica za cdrom:

`/dev/cdrom  /cdrom  iso9660  ro,user,noauto,unhide`

priklopimo cdrom kar z ukazom:

`mount /cdrom `

ali 

`mount /dev/cdrom`

 

##### df - Izpis (ne)zasedenosti datotečnih sistemov in lokacije v datotečnem sistemu, kamor so priklopljeni

Izpis koliko prostora porabijo podane datoteke/imeniki: **du** 

uporabno stikalo:

`-h` ... izpis z merskimi enotami KB, MB,...

*Primer:*

`du -h . ` ... izpiše koliko prostora zasede na disku trenutni imenik z vsemi podimeniki



# VAJE 10 - regularni izrazi

### regularni izrazi

 Po POSIXu dve specifikaciji sintakse:

- osnovni regularni izrazi (basic)
- razširjeni regularni izrazi (extended)

Če uporabljamo ukaz **grep**, je potrebno za uporabo razširjenih regularnih izrazov uporabiti stikalo `-E` ali pa namesto grepa uporabiti **egrep**.

Metaznaki za tvorjenje regularnih izrazov: \ . ^ $ | ? * + - : , ( ) [ ] { }

| **Regularni izraz** | **Pomen**                      |
| ------------------- | ------------------------------ |
| *znak*              | iskanje znaka (če ni metaznak) |
| ^                   | začetek vrstice                |
| $                   | konec vrstice                  |
| \<*beseda*\>        | določa niz "beseda"            |
| \b                  | rob besede                     |
| \B                  | znotraj besede (ne rob besede) |



| Operator | Effect                                                       |
| :------- | :----------------------------------------------------------- |
| .        | Matches any single character.                                |
| ?        | The preceding item is optional and will be matched, at most, once. |
| *        | The preceding item will be matched zero or more times.       |
| +        | The preceding item will be matched one or more times.        |
| {N}      | The preceding item is matched exactly N times.               |
| {N,}     | The preceding item is matched N or more times.               |
| {N,M}    | The preceding item is matched at least N times, but not more than M times. |
| –        | represents the range if it’s not first or last in a list or the ending point of a range in a list. |
| ^        | Matches the empty string at the beginning of a line; also represents the characters not in the range of a list. |
| $        | Matches the empty string at the end of a line.               |
| \b       | Matches the empty string at the edge of a word.              |
| \B       | Matches the empty string provided it’s not at the edge of a word. |
| \<       | Match the empty string at the beginning of word.             |
| \>       | Match the empty string at the end of word.                   |

Primeri:*

`echo -e "konec prve vrstice\nzacetek 2." | grep "." `… iščemo poljuben znak (metaznak ".")

`echo -e "konec prve vrstice\nzacetek 2." | grep "\."`… iščemo piko (ki je tudi metaznak zato poševnica)

`echo -e "konec prve vrstice\nzacetek 2." | grep "^zac" ` ... izpiše vrstico, ki se začne na "zac"

`echo -e "konec prve vrstice\nzacetek 2." | grep "\.$"` ... izpiše vrstico, ki se konča s piko

`echo -e "konec prve vrstice\nzacetek 2." | grep "\Bce" `… išče besede, ki imajo pred "ce" znake

`echo -e "konec prve vrstice\nzacetek 2." | grep "ce\b" ` … izpiše prvo - niz "ce" je rob besede "vrstice"

`echo -e "the\nthem,\nthere,\nother" | grep "the"`… izpiše vse besede, ker vsebujejo besedo the

`echo -e "the\nthem,\nthere,\nother" | grep "\<the\>"`… izpiše samo the



### poljuben znak in znak iz določenega nabora znakov

`.` … poljuben znak;

`[znaki]` … nabor znakov (lahko uporabljamo okrajšave za zapis intervalov [a-z], [1-5]);

`[^znaki]` … komplement nabora znakov.

*Primeri:*

`[yYnN]` … črke y, Y, n in N;

`[a-z]` … mala črka abecede;

`[^a-z]` … znak, ki ni mala črka abecede;

`[a-z0-9]` … mala črka ali desetiška števila;

`[-+0-9]` … znaka - in + ali desetiška števila;

`[^aeiou]` … soglasniki.



### stik in izbira

stik: v besedi *banana* imamo stik šestih izrazov (posamezne črke).

Izbira/disjunkcija: `a|e|i|o|u`, ena izmed črk, ekvivalentno `[aeiou]`.

Za uporabo izbire po zgornji sintaksi moramo uporabljati razširjeno različico regularnih izrazov: *grep* s stikalom `–E` ali *egrep*).

*Primeri:*

`echo a | egrep "a|ab|abc"`

`echo ab | egrep "a|ab|abc"`

`echo abc | egrep "a|ab|abc"`


*Še nekaj primerov:*

`proces|opravilo` … niz proces ali niz opravilo

`[a-z]|[A-Z]` … črke angleške abecede

`[a-z] [a-z] [a-z]` (brez presledkov) … trimestni nizi aaa, aab, aac, … zzz

`[a-z]|[a-z]|[a-z]` … ekvivalentno le enemu `[a-z]`



### ponavljanje

Večkratno ponavljanje danega regularnega izraza. Operacijo zapišemo **za** izrazom, ki ga želimo ponavljati.

| **Regularni izraz** | **Pomen**                     |
| ------------------- | ----------------------------- |
| ?                   | nič ali ena ponovitev         |
| *                   | nič ali več ponovitev         |
| +                   | ena ali več ponovitev         |
| {n}                 | natanko n ponovitev           |
| {n,}                | več ali enako kot n ponovitev |
| {n,m}               | med n in m ponovitev          |

*Primeri:*

`a?` … prazen niz ali črka a

`ab*a` … niz ki se začne in konča z a, vmes je nič ali več črk b

`[01]+` … poljubno dolgo dvojiško število

`[0-9]{7}` … sedemmestno število

`o?os | O?OS` … nizi os, oos, OS, OOS

`no+ro+st` … nizi norost, nooroost, noorost, noroost, itd.

Zaviti oklepaji `{}`, znak `+` in znak `?` delujejo v razširjeni različici (ukaz egrep) brez predhodnih poševnic, pri **osnovni** različici pa moramo uporabljati **poševnico** nazaj pred oklepajem. Primer:

`echo 1234567 | grep "[0-9]\{7\}`… sedemmestno število (osnovni regularni izraz)

`echo 1234567 | egrep "[0-9]{7}" `… sedemmestno število (razširjen regularni izraz)



### skupinjenje in povratni sklic

Povratni sklici so pogosto na voljo v kombinaciji z regularnimi izrazi.

`(izraz)` ... skupinjenje izraza;

`\n` ... sklic na n-to skupino.

*Primer:*

`([01]+)\1 `

… vsi dvojiški nizi, katerih prva polovica je enaka drugi (sklic pomeni, da se sklicani del v celoti ponovi, ampak ne kot regularni izraz, ampak niz, ki se je v prvi skupini ujemal z regularnim izrazom).



### sed - spreminjanje vsebine datotek

Vsebino besedila lahko spreminjamo s skriptnim jezikom, ki ga poženemo s programom *sed* (**s**tream **ed**itor).

Program bere vsebino s svojega standardnega vhoda, lahko pa mu tudi podamo datoteko s stikalom `-f` 

`-f datoteka_s_skripto` ... podamo ime datoteke, v kateri je zapisana skripta.

 

**Skripni jezik za sed**

Ukaz za menjavo nizov:

`s/star_niz/nov_niz/`

... ukaz za zamenjavo se začne z znakom `s`, `/` pa je znak, ki ločuje posamezne dele. Namesto znaka `/` si lahko izberemo tudi kakšen drug znak, kar je koristno v primeru, če naši nizi vsebujejo znak `/`. Ukaz bo zamenjal vse pojavitve niza *star_niz* z nizom *nov_niz.* Kot niz lahko uporabljamo regularni izraz.

*Primer:*

`echo "Zunaj je svetlo." | sed 's/svetlo/temno/' `

Znak `&` se uporablja kot referenca za celoten star_niz

`echo "Število je 123" | sed -E 's/[0-9]+/(&)/'`...  izpiše *Število je (123)*

 

Enako lahko uporabljamo sklicevanja `\1`, `\2`, le da je treba tukaj pred oklepaj/zaklepaj napisati znak \ 

`echo "ime priimek" | sed 's/\([a-z]*\) \([a-z]*\)/\2 \1/'` ...  vrne priimek ime

 

`g` na koncu ukaza za zamenjave pomeni, da se izvršijo vse zamenjave in ne le ena v vsaki vrstici.  Več sed-ukazov običajno zapišemo v datoteko, vsakega v svojo vrstico. 

*Primer - datoteka ukazi.txt, v katero smo zapisali sledeče ukaze:*

```sed
s/a/A/g
s/e/E/g
s/i/I/g
s/o/O/g
s/u/U/g
```

Poženemo: 

`sed -f ukazi.txt < tekst.txt > izhod.txt`

Zaporedje ukazov v datoteki *ukazi.txt* zamenja vse male samoglasnike v datoteki *tekst.txt* z velikimi samoglasniki in rezultat zapiše v datoteko *izhod.txt*.

*Še en primer iskanja vrstic, v katerih naj se zgodi zamenjava:*

`sed '/^#/ s/[0-9][0-9]*//' `... zbriše številke v vrsticah, ki se začnejo z znakom #; pred zamenjavo iščemo vrstice, kjer se # nahaja na začetku vrstice (^)

Ukaze lahko izvajamo tudi samo na določenih vrsticah:

`sed '1,100 s/A/a/'` ... naredi zamenjavo samo na prvih 100 vrsticah.

 

Poleg zamenjave podniza lahko izvedemo tudi druge operacije:

`d` - brisanje

`sed '/pattern to match/d' file`

`sed '5,$ d' `

... iz besedila izbriše vse vrstice od 5 naprej - zadnjo vrstico označimo z znakom $.

`a` - dodajanje nove vrstice za trenutno vrstico

`echo "Za to vrstico vstavi novo vrstico" | sed '/vstavi/ a\Nova vrstica'` 

... vstavi novi vrstico z nizom Nova vrstica za vrstico v kateri je niz vstavi.

`i` - dodajanje nove vrstice pred trenutno vrstico

`echo "Pred to vrstico vstavi novo vrstico" | sed '/vstavi/ i\Nova vrstica' `

... vstavi novi vrstico z nizom Nova vrstica pred vrstico v kateri je niz vstavi.

`c` - zamenjava trenutne vrstice

`echo "To vrstico zamenjaj" | sed '/zamenjaj/ c\Nova vrstica' `

... zamenja vrstico v kateri je niz zamenjaj z vrstico z nizom Nova vrstica.



# GREP

`grep -q ^lojze /etc/passwd` je lojze na zacetku vrstice? 



# TAR

**tar** -xvf yourfile