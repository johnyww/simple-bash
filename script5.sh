#!/bin/bash

# update and upgrade
echo "Updating and Upgrading Your System"
sudo apt update && sudo apt full-upgrade

# make directory
echo "Creating directory..."
mkdir /home/pi/jellyfin
echo "Directory created"

# jellyfin docker install - port 8096
echo "Jellyfin installation begin"
docker run -d \
--name=jellyfin \
--network imanmacvlan \
--ip 192.168.0.192 \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=Asia/Kuala_Lumpur \
-p 8096:8096 \
-v /home/pi/jellyfin/library:/config \
-v /home/pi/jellyfin/tvseries:/data/tvshows \
-v /home/pi/jellyfin/movies:/data/movies \
--restart unless-stopped \
lscr.io/linuxserver/jellyfin:latest
echo "Jellyfin installation completed"
