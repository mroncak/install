#!/bin/bash

i=2
lines=`cat DHCP_195.20.162.0_migration.csv | wc -l`
while [ $i -le $lines ]; do
	ip=`awk -F',' 'FNR == '$i' {print $1; exit}' DHCP_195.20.162.0_migration.csv`
	name=`awk -F',' 'FNR == '$i' {print $2; exit}' DHCP_195.20.162.0_migration.csv`
	desc=`awk -F',' 'FNR == '$i' {print $6; exit}' DHCP_195.20.162.0_migration.csv`
	mac=`awk -F',' 'FNR == '$i' {print $5; exit}' DHCP_195.20.162.0_migration.csv | sed 's/\(\w\w\)\(\w\w\)\(\w\w\)\(\w\w\)\(\w\w\)\(\w\w\)/\1:\2:\3:\4:\5:\6/g'`
	echo "edit $((i-1))
	set ip $ip
	set mac $mac
	set description $name - $desc
next"
	i=$((i + 1))
done
