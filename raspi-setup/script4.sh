#!/bin/bash

# update and upgrade
echo "Updating and Upgrading Your System"
sudo apt update && sudo apt full-upgrade

# make directory
echo "Creating directory..."
mkdir /home/pi/adguard
echo "Directory created"

# adguard docker install - port 3000
echo "Adguard installation begin"
docker run --name adguardhome \
--restart unless-stopped \
--network imanmacvlan \
--ip 192.168.0.191 \
-v /home/pi/adguard/workdir:/opt/adguardhome/work \
-v /home/pi/adguard/confdir:/opt/adguardhome/conf \
-p 53:53/tcp -p 53:53/udp \
-p 67:67/udp -p 68:68/udp \
-p 80:80/tcp -p 443:443/tcp -p 443:443/udp -p 3000:3000/tcp \
-p 853:853/tcp \
-p 784:784/udp -p 853:853/udp -p 8853:8853/udp \
-p 5443:5443/tcp -p 5443:5443/udp \
-d adguard/adguardhome
echo "Adguard installation completed"
