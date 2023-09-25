#/bin/bash
#  ___           _        _ _  
# |_ _|_ __  ___| |_ __ _| | | 
#  | || '_ \/ __| __/ _` | | | 
#  | || | | \__ \ || (_| | | | 
# |___|_| |_|___/\__\__,_|_|_| 
#                              
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 
# Install Script for required packages
# ------------------------------------------------------

# ------------------------------------------------------
# Load Library
# ------------------------------------------------------
source $(dirname "$0")/scripts/library.sh
clear
echo "  ___           _        _ _  "
echo " |_ _|_ __  ___| |_ __ _| | | "
echo "  | ||  _ \/ __| __/ _  | | | "
echo "  | || | | \__ \ || (_| | | | "
echo " |___|_| |_|___/\__\__,_|_|_| "
echo "                              "
echo "by Stephan Raabe (2023)"
echo "-------------------------------------"
echo ""

# ------------------------------------------------------
# Check if yay is installed
# ------------------------------------------------------
#if sudo pacman -Qs yay > /dev/null ; then
#    echo "yay is installed. You can proceed with the installation"
#else
#    echo "yay is not installed. Will be installed now!"
#    git clone https://aur.archlinux.org/yay-git.git ~/yay-git
#    cd ~/yay-git
#    makepkg -si
#    cd ~/dotfiles/
#    clear
#    echo "yay has been installed successfully."
#    echo ""
#    echo "  ___           _        _ _  "
#    echo " |_ _|_ __  ___| |_ __ _| | | "
#    echo "  | ||  _ \/ __| __/ _  | | | "
#    echo "  | || | | \__ \ || (_| | | | "
#    echo " |___|_| |_|___/\__\__,_|_|_| "
#    echo "                              "
#    echo "by Stephan Raabe (2023)"
#    echo "-------------------------------------"
#    echo ""
#fi

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
# Install Arco Repositories
# ------------------------------------------------------

echo
echo "Pacman parallel downloads if needed"
FIND="#ParallelDownloads = 5"
REPLACE="ParallelDownloads = 5"
sudo sed -i "s/$FIND/$REPLACE/g" /etc/pacman.conf

sudo pacman -S wget --noconfirm --needed

echo "Getting the ArcoLinux keys from the ArcoLinux repo"

sudo wget https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/arcolinux-keyring-20251209-3-any.pkg.tar.zst -O /tmp/arcolinux-keyring-20251209-3-any.pkg.tar.zst
sudo pacman -U --noconfirm --needed /tmp/arcolinux-keyring-20251209-3-any.pkg.tar.zst

echo "Getting the latest arcolinux mirrors file"

sudo wget https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/arcolinux-mirrorlist-git-23.06-01-any.pkg.tar.zst -O /tmp/arcolinux-mirrorlist-git-23.06-01-any.pkg.tar.zst
sudo pacman -U --noconfirm --needed /tmp/arcolinux-mirrorlist-git-23.06-01-any.pkg.tar.zst
echo '

#[arcolinux_repo_testing]
#SigLevel = PackageRequired DatabaseNever
#Include = /etc/pacman.d/arcolinux-mirrorlist

[arcolinux_repo]
SigLevel = PackageRequired DatabaseNever
Include = /etc/pacman.d/arcolinux-mirrorlist

[arcolinux_repo_3party]
SigLevel = PackageRequired DatabaseNever
Include = /etc/pacman.d/arcolinux-mirrorlist

[arcolinux_repo_xlarge]
SigLevel = PackageRequired DatabaseNever
Include = /etc/pacman.d/arcolinux-mirrorlist' | sudo tee --append /etc/pacman.conf

sudo pacman -Sy

read -p "Press enter to continue"

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
echo ""
echo "-> Install main packages"

packagesPacman=(
    "pacman-contrib"
    "alacritty" 
    "rofi" 
    "chromium" 
    "nitrogen" 
    "dunst" 
    "starship"
    "neovim" 
    "mpv" 
    "freerdp" 
    "xfce4-power-manager" 
    "thunar" 
    "mousepad" 
    "ttf-font-awesome" 
    "ttf-fira-sans" 
    "ttf-fira-code" 
    "ttf-firacode-nerd" 
    "figlet" 
    "lxappearance" 
    "breeze" 
    "breeze-gtk" 
    "vlc" 
    "exa" 
    "python-pip" 
    "python-psutil" 
    "python-rich" 
    "python-click" 
    "xdg-desktop-portal-gtk"
    "pavucontrol" 
    "tumbler" 
    "xautolock" 
    "blueman"
    "arcolinux-app-glade-git"
    "onlyoffice-bin"
    "virt-manager"
    "virt-viewer"
    "qemu-desktop"
    "qemu-emulators-full"
    "firewalld"				# Firewall Daemon - firewall-cmd
    "ntfs-3g"				# NTFS Filesystem Driver
    "brave-bin"				# Brave Browser
    "freerdp"				# RDP Client
    "keepassxc"				# KeePassXC Password Manager
    "nextcloud-client"			# Nextcloud Client GUI
    "openfortivpn"			# Fortigate VPN
    "timeshift"				# Incremental System Backup
    "timeshift-autosnap"		# Automatic Incremental System Backup - BRTFS
    "transmission-gtk"			# Torrent Downloader
    "ranger"				# CLI File Explorer
    "kdeconnect"			# Desktop to Phone Connection
    "gnome-calculator"			# Calculator
    "spotifywm-git"			# Spotify for adapted for WM
    "bibata-cursor-theme" 
    "pfetch"				# System Info CLI
    "yay"				# Yet Another Yogurth - AUR Helper
    "ttf-ms-fonts"			# Microsoft Fonts
    "sublime-text-4"			# Text Editor
    "ferdium-bin"			# Whatsup Electron Wrapper
    "meld"				# GUI Compare files
    "arandr"				# Display Settings
    "cups"				# Printing Server
    "system-config-printer"		# Printer GUI Setup
);

packagesYay=(
#    "pfetch" 
#    "bibata-cursor-theme" 
#    "trizen"
    "microsoft-edge-stable-bin"		# Microsoft Edge Browser
    "xerox-phaser-3020"			# Xerox Workstation 3215 driver
);
  
# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
_installPackagesPacman "${packagesPacman[@]}";
read -p "Press enter to continue"
_installPackagesYay "${packagesYay[@]}";
read -p "Press enter to continue"

# ------------------------------------------------------
# Install pywal
# ------------------------------------------------------
if [ -f /usr/bin/wal ]; then
    echo "pywal already installed."
else
    yay --noconfirm -S pywal
fi

clear

# ------------------------------------------------------
# Install .bashrc
# ------------------------------------------------------
echo ""
echo "-> Install .bashrc"

_installSymLink .bashrc ~/.bashrc ~/install/.bashrc ~/.bashrc

# ------------------------------------------------------
# Install custom issue (login prompt)
# ------------------------------------------------------
echo ""
echo "-> Install login screen"
while true; do
    read -p "Do you want to install the custom login promt? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            sudo cp ~/install/login/issue /etc/issue
            echo "Login promt installed."
        break;;
        [Nn]* ) 
            echo "Custom login promt skipped."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ------------------------------------------------------
# Install wallpapers
# ------------------------------------------------------
echo ""
echo "-> Install wallapers"
while true; do
    read -p "Do you want to clone the wallpapers? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            if [ -d ~/wallpaper/ ]; then
                echo "wallpaper folder already exists."
            else
                git clone https://gitlab.com/stephan-raabe/wallpaper.git ~/wallpaper
                echo "wallpaper installed."
            fi
            echo "Wallpaper installed."
        break;;
        [Nn]* ) 
            if [ -d ~/wallpaper/ ]; then
                echo "wallpaper folder already exists."
            else
                mkdir ~/wallpaper
            fi
            cp ~/install/default.jpg ~/wallpaper
            echo "Default wallpaper installed."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ------------------------------------------------------
# Init pywal
# ------------------------------------------------------
echo ""
echo "-> Init pywal"
wal -i ~/install/default.jpg
echo "pywal initiated."

# ------------------------------------------------------
# DONE
# ------------------------------------------------------
clear
echo "DONE!"
