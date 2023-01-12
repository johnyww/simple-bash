#!/bin/bash

# update and upgrade
echo "Updating and Upgrading Your System"
sudo apt update && sudo apt full-upgrade

# make directory
echo "Creating directory..."
mkdir /home/pi/docker/docker-network/imanmacvlan
mkdir /home/pi/portainer
echo "Directory created"

# docker networking setup
echo "Setting up docker network begin"
sudo docker create network -d macvlan \
--subnet=192.168.0.1/24 \
--gateway=192.168.0.1 \
-o parent=eth0 \
imanmacvlan
echo "Setting up docker network completed"

# promiscuous mode on
sudo ip link set eth0 promisc on 
echo "Setting promiscuous mode on"

# portainer docker install - port 9000
echo "Portainer installation begin"
sudo docker run -d \
-p 9000:9000 \
--network imanmacvlan \
--ip 192.168.0.190 \
--name=portainer \
--restart=always \
-v /var/run/docker.sock:/var/run/docker.sock \
-v portainer_data:/data \
portainer/portainer-ce:latest
echo "Portainer installation completed"
