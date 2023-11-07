#!/bin/sh
#   ___ _____ ___ _     _____   ____  _             _    
#  / _ \_   _|_ _| |   | ____| / ___|| |_ __ _ _ __| |_  
# | | | || |  | || |   |  _|   \___ \| __/ _` | '__| __| 
# | |_| || |  | || |___| |___   ___) | || (_| | |  | |_  
#  \__\_\|_| |___|_____|_____| |____/ \__\__,_|_|   \__| 
#                                                        
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# My screen resolution
#xrandr --rate 120

# For Virtual Machine 

if [ -n "xrandr --listmonitors | grep Virtual" ]
	then xrandr --output Virtual-1 --mode 1920x1080
fi

# Set keyboard mapping
#setxkbmap de
# setxkbmap en

# Load picom
picom &

# Load power manager
xfce4-power-manager &

# Load notification service
dunst &

# Launch polybar
#~/install/polybar/launch.sh &

# Setup Wallpaper and update colors
~/install/scripts/updatewal.sh &

# Polkit
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
# systray battery icon
#cbatticon -u 5 &
# systray volume
pasystray --include-monitors &
# systray Network Manager Applet
nm-applet &
# systray Remmina 
#remmina -i &
# bluetooth blueman-applet
#blueman-applet &
# Nextcloud Client
nextcloud &
# Keepass Tray
keepassxc &
# Kde Connect - Phone connection
kdeconnect-indicator &
# Play With MPV Server
play-with-mpv &


# Load Windows 11 VM
# virsh --connect qemu:///system start win11
