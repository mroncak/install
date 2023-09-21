#!/bin/bash
#      _       _    __ _ _           
#   __| | ___ | |_ / _(_) | ___  ___ 
#  / _` |/ _ \| __| |_| | |/ _ \/ __|
# | (_| | (_) | |_|  _| | |  __/\__ \
#  \__,_|\___/ \__|_| |_|_|\___||___/
#                                    
# by Stephan Raabe (2023)
# ------------------------------------------------------
# Install Script for dotfiles and configuration
# yay must be installed
# ------------------------------------------------------

# ------------------------------------------------------
# Load Library
# ------------------------------------------------------
source $(dirname "$0")/scripts/library.sh
clear
echo "     _       _    __ _ _            "
echo "  __| | ___ | |_ / _(_) | ___  ___  "
echo " / _' |/ _ \| __| |_| | |/ _ \/ __| "
echo "| (_| | (_) | |_|  _| | |  __/\__ \ "
echo " \__,_|\___/ \__|_| |_|_|\___||___/ "
echo "                                    "
echo "by Stephan Raabe (2023)"
echo "-------------------------------------"
echo ""
echo "The script will ask for permission to remove existing folders and files."
echo "But you can decide to keep your local versions by answering with No (Nn)."
echo "Symbolic links will be created from ~/dotfiles into your home and .config directories."
echo ""

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Installation started."
        break;;
        [Nn]* ) 
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ------------------------------------------------------
# Create .config folder
# ------------------------------------------------------
echo ""
echo "-> Check if .config folder exists"

if [ -d ~/.config ]; then
    echo ".config folder already exists."
else
    mkdir ~/.config
    echo ".config folder created."
fi

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------
# name symlink source target

echo ""
echo "-------------------------------------"
echo "-> Install general dotfiles"
echo "-------------------------------------"
echo ""

_installSymLink alacritty ~/.config/alacritty ~/install/alacritty/ ~/.config
_installSymLink ranger ~/.config/ranger ~/install/ranger/ ~/.config
_installSymLink vim ~/.config/vim ~/install/vim/ ~/.config
_installSymLink nvim ~/.config/nvim ~/install/nvim/ ~/.config
_installSymLink starship ~/.config/starship.toml ~/install/starship/starship.toml ~/.config/starship.toml
_installSymLink rofi ~/.config/rofi ~/install/rofi/ ~/.config
_installSymLink dunst ~/.config/dunst ~/install/dunst/ ~/.config
_installSymLink wal ~/.config/wal ~/install/wal/ ~/.config

echo "-------------------------------------"
echo "-> Install GTK dotfiles"
echo "-------------------------------------"
echo ""

_installSymLink .gtkrc-2.0 ~/.gtkrc-2.0 ~/install/gtk/.gtkrc-2.0 ~/.gtkrc-2.0
_installSymLink gtk-3.0 ~/.config/gtk-3.0 ~/install/gtk/gtk-3.0/ ~/.config/
_installSymLink .Xresouces ~/.Xresources ~/install/gtk/.Xresources ~/.Xresources
_installSymLink .icons ~/.icons ~/install/gtk/.icons/ ~/

echo "-------------------------------------"
echo "-> Install Qtile dotfiles"
echo "-------------------------------------"
echo ""

_installSymLink qtile ~/.config/qtile ~/install/qtile/ ~/.config
_installSymLink polybar ~/.config/polybar ~/install/polybar/ ~/.config
_installSymLink picom ~/.config/picom ~/install/picom/ ~/.config
_installSymLink .xinitrc ~/.xinitrc ~/install/qtile/.xinitrc ~/.xinitrc

echo "-------------------------------------"
echo "-> Install Hyprland dotfiles"
echo "-------------------------------------"
echo ""

_installSymLink hypr ~/.config/hypr ~/install/hypr/ ~/.config
_installSymLink waybar ~/.config/waybar ~/install/waybar/ ~/.config
_installSymLink swaylock ~/.config/swaylock ~/install/swaylock/ ~/.config
_installSymLink wlogout ~/.config/wlogout ~/install/wlogout/ ~/.config

# ------------------------------------------------------
# DONE
# ------------------------------------------------------
echo "DONE! Please reboot your system!"
