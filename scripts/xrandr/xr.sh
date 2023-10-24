#!/bin/bash

if [ $# -eq 0 ]; then
	echo -e "\n$(tput setaf 1)-------------------------------------------------\nNeed argument (home or work)\n-------------------------------------------------
	$(tput sgr 0)\n"
	exit
fi

place=$1

if [ $place == 'home' ]; then
	xrandr --output eDP1 --off --output DP2-2 --primary --mode 2560x1440 --pos 2560x0 --rotate normal --output DP2-1 --mode 2560x1440 --pos 0x0 --rotate normal
	nitrogen --restore
elif [ $place == 'work' ]; then	
	xrandr --output eDP1 --off --output DP2-1 --primary --mode 2560x1440 --pos 0x0 --rotate normal --output DP2-2 --mode 2560x1440 --pos 2560x0 --rotate normal
	nitrogen --restore
elif [ $place == 'away' ]; then
	xrandr --output eDP1 --mode 1920x1080 --pos 0x0 --rotate normal --output DP2-1 --off --output DP2-2 --off
	nitrogen --restore
else
	echo -e "\n$(tput setaf 1)-------------------------------------------------\nNeed argument (home or work or away)\n-------------------------------------------------
	$(tput sgr 0)\n\n  Example: xr home\n"
	echo -e 
fi

