#!/bin/bash

sudo yum install -y python3-pip
sudo pip3 install pymongo requests
sudo mkdir -p /usr/local/share/ca-certificates/
sudo wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem -O /usr/local/share/ca-certificates/rds.pem
sudo chmod 0644 /usr/local/share/ca-certificates/rds.pem