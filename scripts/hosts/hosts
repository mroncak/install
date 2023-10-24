#!/bin/bash

if [ $# -eq 0  ]; then
	cat /etc/hosts
elif [ $# -eq 1 ]; then
	v=`echo $1`
	grep --color=auto -i $v /etc/hosts
elif [ $# -ge 2 ]; then
	echo "$(tput setaf 1)Showing results only for first argument!$(tput sgr 0)"
	v=`echo $1`
	grep --color=auto -i $v /etc/hosts

fi
