#!/bin/bash

curl --silent \
     --request GET \
     --header "Content-Type: application/json" \
     --header "token: r4QfuGrMLRdPnGhud0PzKYLZj5BdEg-D" \
        https://iptools.mc.local/api/mro/subnets/all/ -i -k > ipam_db.json

tail -n 1 ipam_db.json | jq -r '.data[] | [.id, .subnet, .mask, .description, .masterSubnetId, .vrfId, .sectionId] | join(";")' > ipam_db.csv

awk -F';' '{print $1}' ipam_db.csv > id.txt
awk -F';' '{print $5}' ipam_db.csv > mid.txt

lines=`cat id.txt | wc -l`

i=1
echo "Id;Subnet;Mask;IP;Description;MasterSubnetID;VRFID;SectionID" > ipam_db_clean.csv
while [ $i -le $lines ]; do
	id=`sed -n "$i"p id.txt`
	t=`cat mid.txt | grep ^$id$`
	if [ -z "$t" ]
	then
		subnet=`awk -F';' ' NR == '$i'  {print $2}' ipam_db.csv`
		mask=`awk -F';' ' NR == '$i'  {print $3}' ipam_db.csv`
		desc=`awk -F';' ' NR == '$i'  {print $4}' ipam_db.csv`
		masterid=`awk -F';' ' NR == '$i'  {print $5}' ipam_db.csv`
		vrfid=`awk -F';' ' NR == '$i'  {print $6}' ipam_db.csv`
		sectionid=`awk -F';' ' NR == '$i'  {print $7}' ipam_db.csv`
		nmap -sL -n $subnet/$mask | awk '/Nmap scan report/{print $NF}' > iplist.txt
		j=1
		while [ $j -le `cat iplist.txt | wc -l` ]; do
			ip=`sed -n "$j"p iplist.txt`
			echo "$id;$subnet;$mask;$ip;$desc;$masterid;$vrfid;$sectionid" >> ipam_db_clean.csv
			j=$((j + 1))
		done

	fi
	
	i=$((i + 1))
done

