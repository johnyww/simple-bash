#!/bin/bash

# update and upgrade
echo "Updating and Upgrading Your System"
sudo apt update && sudo apt full-upgrade

# make directory
echo "Creating directory..."
mkdir /home/pi/wireguard
echo "Directory created"

# wireguard docker install - port 51820
echo "Wireguard installation begin"
docker run -d \
--name=wireguard \
--cap-add=NET_ADMIN \
--cap-add=SYS_MODULE \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=Asia/Kuala_Lumpur \
-e SERVERURL=johnvpn.ignorelist.com `#optional` \
-e SERVERPORT=51820 `#optional` \
-p 51820:51820/udp \
-v /home/pi/wireguard/appdata/config:/config \
--sysctl="net.ipv4.conf.all.src_valid_mark=1" \
--restart unless-stopped \
linuxserver/wireguard
echo "Wireguard installation completed"
