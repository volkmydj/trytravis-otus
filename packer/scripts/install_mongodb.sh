#!/bin/bash
set -e

#Install MongoDB
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E52529D4
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-4.0.list
apt-get update
apt-get install -y mongodb-org
sudo systemctl enable mongod.service


