#!/bin/bash

ipnew=$(curl -4 icanhazip.com)
ip=$(tail -n 1 /home/mroncak/Script/ip.txt | cut -d " " -f 2)
host=$(hostname)

if [ $ipnew != $ip ]; then echo `date +"%Y%m%d "`$ipnew >> /home/mroncak/Script/ip.txt && mail -s "IP address" roncak@gmail.com <<< "$host = $ipnew" ;
fi

exit 0
