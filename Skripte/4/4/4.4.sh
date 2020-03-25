#!/bin/bash
#s standardnega vhoda preberemo podatke za posiljanje
echo "Mail from:"; read from
echo "Mail to:"; read to
echo "Subject:"; read subject
echo "Message:"; read body
#definiramo izmenjavo sporocil v skladu s protokolom SMTP
smtp[0]="helo bash_smtp_client\r\n"
smtp[1]="mail from: <$from>\r\n"
smtp[2]="rcpt to: <$to>\r\n"
smtp[3]="data\r\n"
smtp[4]="from: $from\r\nto: $to\r\nsubject: $subject\r\n$body\r\n.\r\n"
smtp[5]="quit\r\n"
#iz ciljnega naslova izlocimo ime domene, s pomocjo programa host poiscemo naslov streznika MX, izlocimo prvi vnos in nato naslov
domain=$(host -t MX ${to#*@} | head -n 1 | awk '{print $NF}')
#odpremo datotecni deskriptor 3 in ga preusmerimo na povezavo TCP do streznika MX na vratih 25
exec 3<>/dev/tcp/$domain/25
#preberemo pozdravno sporocilo
read msg <&3	#preberemo vrstico preko deskriptorja 3
echo $msg
#izvrsimo komunikacijo
for i in {0..5}; do
	printf "${smtp[$i]}" >&3	#pisemo preko deskriptorja 3
	read msg <&3
done
