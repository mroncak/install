#!/bin/bash

scp mroncak@192.168.50.50:/opt/pihole/etc-pihole/custom.list /home/mroncak/dotfiles/scripts/hosts/pihole.list
sed -i -ne '/# Pihole Block Start/ {p; r /home/mroncak/dotfiles/scripts/hosts/pihole.list' -e ':a; n; /Pihole Block End/ {p; b}; ba}; p' /home/mroncak/dotfiles/scripts/hosts/ansible.list
if [ -z `grep "BEGIN\|END MANAGED BLOCK" /etc/hosts` ]
then
	echo '

# BEGIN MANAGED BLOCK
# END MANAGED BLOCK' | sudo tee --append /etc/hosts
fi
sudo sed -i -ne '/# BEGIN MANAGED BLOCK/ {p; r /home/mroncak/dotfiles/scripts/hosts/ansible.list' -e ':a; n; /# END MANAGED BLOCK/ {p; b}; ba}; p' /etc/hosts
