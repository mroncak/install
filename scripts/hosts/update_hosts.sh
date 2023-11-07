#!/bin/bash

scp mroncak@192.168.50.50:/opt/pihole/etc-pihole/custom.list /home/mroncak/install/scripts/hosts/pihole.list
sed -i -ne '/# Pihole Block Start/ {p; r /home/mroncak/install/scripts/hosts/pihole.list' -e ':a; n; /Pihole Block End/ {p; b}; ba}; p' /home/mroncak/install/scripts/hosts/ansible.list
sudo sed -i -ne '/# BEGIN ANSIBLE MANAGED BLOCK/ {p; r /home/mroncak/install/scripts/hosts/ansible.list' -e ':a; n; /# END ANSIBLE MANAGED BLOCK/ {p; b}; ba}; p' /etc/hosts
