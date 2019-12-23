#!/bin/bash
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E52529D4
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-4.0.list'
apt update
apt install -y mongodb-org
systemctl enable mongod.service
systemctl start mongod.service
systemctl status mongod

