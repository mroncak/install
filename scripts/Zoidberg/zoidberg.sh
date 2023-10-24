#!/usr/local/bin/bash

ip="172.20.29.4"

komun="read-write"

meno=`snmpwalk -v 2c -c $komun $ip SysName | cut -d " " -f4`

echo "IPcKA> $ip, Meno> $meno"

 

 

#!/usr/local/bin/bash

#

# Copyright 2007 Milan Stefko

#

cd /home/mso/unrwa-script/

#zistime si pocet sledovanych sajtov

pocet=`cat zoid.db | wc -l`

#pre kazdy z nich ...

for ((  i = 1 ;  i <= $pocet;  i++  ))

do

    #aktualny cas

    cas=`date "+%d.%m.%Y %H:%M:%S"`

    #vyparsujeme si zo zoznamu pozadovane polozky, router je viacmenej relativna hodnota, skor nazov logu

    cislo=`cut -d "|" -f1 zoid.db | head -n $i | tail -n 1`

    router=`cut -d "|" -f4 zoid.db | head -n $i | tail -n 1`

    intf=`cut -d "|" -f5 zoid.db | head -n $i | tail -n 1`

    intfd=`cut -d "|" -f6 zoid.db | head -n $i | tail -n 1`

    ip=`cut -d "|" -f2 zoid.db | head -n $i | tail -n 1`

    intfn=`cut -d "|" -f3 zoid.db | head -n $i | tail -n 1`

    nazovdb=`cut -d "|" -f1 zoid.db | head -n $i | tail -n 1`

    speed=`cut -d "|" -f7 zoid.db | head -n $i | tail -n 1`

    #povodna hodnota ktoru sledujeme

    ph=`tail -n 1 $nazovdb | cut -d " " -f3`

    #vytiahneme si udaje ktore potrebujeme

    snmp=`/usr/local/bin/snmpwalk -v 2c -t 5 -c vsk-unrwa $ip 'ifOperStatus.'$intfn | cut -d " " -f4`

    #ak nam to prebehlo ok tak zapiseme do logu

    if [ -n $snmp ]; then

        echo $cas $snmp >> $nazovdb

    fi

    #terajsia hodnota

    th=`tail -n 1 $nazovdb | cut -d " " -f3`

    #teraz si to pekne porovname

    if [ "$ph" != "$th" ]

        then

        echo "Nazdar operator,

 

zaznamenal som zmenu stavu intefrejsu $intf. ($intfd) na routri $router

 

Aktualny stav interfejsu je $th

 

Dr.Zoidberg v0.2- uprava pre UNRWA monitoring-" | mail -s "ZOIDBERG FOR UNRWA $router $intfd $th" mso@vizada.sk Operators@vizada.sk

    fi

done
