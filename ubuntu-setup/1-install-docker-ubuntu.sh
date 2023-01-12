#!/bin/bash

# update and upgrade
echo "Updating and Upgrading Your System"
sudo apt update && sudo apt full-upgrade

# make directory
echo "Creating directory..."
mkdir /home/pi/docker
echo "Directory created"

# remove old version
echo "Removing old version of docker"
sudo apt remove docker docker-engine docker.io containerd runc
echo "Old version of docker remove"
echo "Purging old version of docker"
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
echo "Old verison of docker purged"

# install dependencies
echo "Installing dependencies"
sudo apt install \
ca-certificates \
curl \
gnupg \
lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# update repository
sudo apt update

# install dependencies
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# test
sudo docker run hello-world
