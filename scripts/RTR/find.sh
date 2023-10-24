#!/bin/bash

iplist_lines=`cat iplist.csv | sed '/^\s*$/d' | wc -l`
echo "$iplist_lines"
i=1

while [ $i -le $iplist_lines ]; do
	network=`sed -n "$i"p iplist.csv | cut -d ";" -f 1`
	prefix=`sed -n "$i"p iplist.csv | cut -d ";" -f 2`
	grep "$network;$prefix" route.txt
	echo "$network - $prefix"
	i=$((i+1))
done
