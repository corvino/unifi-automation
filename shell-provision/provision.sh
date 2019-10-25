#! /usr/bin/env bash

sudo apt update && sudo apt -y install ca-certificates apt-transport-https openjdk-8-jre-headless
echo 'deb http://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
echo 'deb http://archive.ubuntu.com/ubuntu bionic main' | sudo tee /etc/apt/sources.list.d/bionic.list
echo 'deb http://archive.ubuntu.com/ubuntu bionic-updates main' | sudo tee -a /etc/apt/sources.list.d/bionic.list

sudo wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg

sudo apt update
# We could specify mongo versions; maybe useful for debugging. But if we get the config right unifi will pull the appropriate dependencies.
# sudo apt install -y mongodb-org=3.4.17 mongodb-org-server=3.4.17 mongodb-org-shell=3.4.17 mongodb-org-mongos=3.4.17 mongodb-org-tools=3.4.17
sudo apt -y install unifi
