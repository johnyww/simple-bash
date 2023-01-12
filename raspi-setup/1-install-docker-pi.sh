#!/bin/bash

# update and upgrade
echo "Updating and Upgrading Your System"
sudo apt update && sudo apt full-upgrade

# make directory
echo "Creating directory..."
mkdir /home/pi/docker
echo "Directory created"

# docker install
echo "Docker installation begin"
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker pi
sudo systemctl enable docker
echo "Docker installation completed"

# end of script1
echo "Please log back in in order for the changes to take effect"
logout
