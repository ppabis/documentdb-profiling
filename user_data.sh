#!/bin/bash

sudo yum install -y python3-pip
sudo pip3 install pymongo requests
sudo mkdir -p /usr/local/share/ca-certificates/
sudo wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem -O /usr/local/share/ca-certificates/rds.pem
sudo chmod 0644 /usr/local/share/ca-certificates/rds.pem

sudo mkdir -p /usr/local/bin
sudo aws ssm get-parameter --name /docdb/insert_plenty --query "Parameter.Value" --output text > /usr/local/bin/insert_plenty
sudo aws ssm get-parameter --name /docdb/query_much --query "Parameter.Value" --output text > /usr/local/bin/query_much
sudo chmod +x /usr/local/bin/insert_plenty
sudo chmod +x /usr/local/bin/query_much 