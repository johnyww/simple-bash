#!/bin/bash

# update and upgrade
echo "Updating and Upgrading Your System"
sudo apt update && sudo apt full-upgrade
sleep 1

# make directory
echo "Creating directory..."
name = whoami
mkdir /home/$whoami/docker/docker-network/imanmacvlan
mkdir /home/$whoami/portainer
mkdir /home/$whoami/ddclient
mkdir /home/$whoami/adguard
mkdir /home/$whoami/jellyfin
mkdir /home/$whoami/wireguard
echo "Directory created"
sleep 1

# remove old version
echo "Removing old version of docker"
sudo apt remove docker docker-engine docker.io containerd runc
echo "Old version of docker remove"
echo "Purging old version of docker"
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
echo "Old verison of docker purged"
sleep 1

# docker install
echo "Docker installation begin"
sudo apt install docker.io
echo "Docker installation completed"
sleep 1

# autostart docker
sudo systemctl enable --now docker
sleep 1

# test docker
sudo docker run hello-world
sleep 3

# start_script2

# get subnet & gateway & network interface
subnet = (ip address | grep scope | grep global | grep dynamic | awk '{print$2; exit}')
gateway = (ip route | grep default | awk '{print$3}')
parent = (ip address | grep LOWER_UP | grep 2 | awk '{print$2}' | sed 's/://g')

# input docker macvlan name and ip address
echo "Enter docker macvlan name : "
read macvlan
echo "Please keep in mind that your gateway is" + $gateway
echo "Enter ip address for docker portainer : "
read ipaddportainer
echo "Enter ip address for docker adguard : "
read ipaddadguard
echo "Enter ip address for docker jellyifn : "
read ipaddjellyfin

# docker networking setup
echo "Setting up docker network begin"
sudo docker create network -d macvlan \
--subnet=$subnet \
--gateway=$gateway \
-o parent=$parent \
$macvlan
echo "Setting up docker network completed"
sleep 1

# promiscuous mode on
sudo ip link set eth0 promisc on 
echo "Setting promiscuous mode on"
sleep 1

# portainer docker install - port 9000
echo "Portainer installation begin"
sudo docker run -d \
-p 9000:9000 \
--network $macvlan \
--ip $ipaddportainer \
--name=portainer \
--restart=always \
-v /var/run/docker.sock:/var/run/docker.sock \
-v portainer_data:/data \
portainer/portainer-ce:latest
echo "Portainer installation completed"
sleep 1

# end_script2
# start_script3

# ddns install
echo "Ddclient installation begin"
sudo apt install ddclient -y 
echo "Ddclient installation completed"
sleep 1
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
password=HO3x6zwy
johnvpn.ignorelist.com" >> /etc/ddclient.conf
echo "Write config file completed"
sleep 1

# restart ddclient
echo "Restarting ddclient"
sudo systemctl restart ddclient 
echo "Ddclient restarted"
sleep 1

# autostart ddclient
echo "Ddclient enabling background process"
sudo systemctl enable ddclient 
echo "Ddclient enabled background process"
sleep 1

# end_script3
# start_script4

# adguard docker install - port 3000
echo "Adguard installation begin"
docker run --name adguardhome \
--restart unless-stopped \
--network $macvlan \
--ip $ipaddadguard \
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
sleep 1

# end_script4
# start_script5

# jellyfin docker install - port 8096
echo "Jellyfin installation begin"
docker run -d \
--name=jellyfin \
--network $macvlan \
--ip $ipaddjellyfin \
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
sleep 1

# end_script5
# start_script6

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
sleep 1

# end_script6

echo "You can access Portainer via http://"  + $ipaddportainer + ":9000 or " + "https://" + $ipaddportainer + ":9000"
echo "You can access Adguard via http://"  + $ipaddadguard + ":3000 or " + "https://" + $ipaddadguard + ":3000"
echo "You can access Jellyfin via http://"  + $ipaddjellyfin + ":8096 or " + "https://" + $ipaddjellyfin + ":8096"

# hihi - imananakmama
