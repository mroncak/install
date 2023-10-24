#!/bin/bash

lines=`cat vrf.txt | sed '/^\s*$/d' | wc -l`
i=1
while [ $i -le $lines ]; do 
	vrf=`sed -n "$i"p vrf.txt`
	echo "ip vrf $vrf"
	echo "snmp context $vrf community HUBpwd254_$vrf RO"
	i=$(($i + 1))
done
