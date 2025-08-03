#!/bin/bash
apt-get update
apt-get install -y docker.io
systemctl enable docker
systemctl start docker
docker pull splunk/attack_range
docker run -it --name attack_range splunk/attack_range
