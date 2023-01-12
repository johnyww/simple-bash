#!/bin/bash

# update and upgrade
echo "Updating and Upgrading Your System"
sudo apt update && sudo apt full-upgrade

# make directory
echo "Creating directory..."
mkdir /home/pi/ddclient
echo "Directory created"

# ddns install
echo "Ddclient installation begin"
sudo apt install ddclient -y 
echo "Ddclient installation completed"
echo "Write config file begin"
sudo echo "daemon=5m
timeout=10
syslog=no # log update msgs to syslog
#mail=root # mail all msgs to root
#mail-failure=root # mail failed update msgs to root
pid=/var/run/ddclient.pid # record PID in file.
ssl=yes # use ssl-support. Works with
# ssl-library

use=if, if=eth0
server=freedns.afraid.org
protocol=freedns
login=johnwick78
password=BdJoWuEQIhjHUY
johnvpn.ignorelist.com" >> /etc/ddclient.conf
echo "Write config file completed"

# restart ddclient
echo "Restarting ddclient"
sudo systemctl restart ddclient 
echo "Ddclient restarted"

# autostart ddclient
echo "Ddclient enabling background process"
sudo systemctl enable ddclient 
echo "Ddclient enabled background process"
