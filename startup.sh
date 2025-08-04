#!/bin/bash

# Redirect all output to a log file for debugging
exec > /var/log/attack_range_setup.log 2>&1
set -e

echo "[INFO] Updating packages..."
apt-get update

echo "[INFO] Installing Docker..."
apt-get install -y docker.io

echo "[INFO] Enabling and starting Docker service..."
systemctl enable docker
systemctl start docker

echo "[INFO] Pulling the Attack Range Docker image..."
docker pull splunk/attack_range

echo "[INFO] Running Attack Range container..."
docker run -d \
  --name attack_range \
  -p 8000:8000 \
  -p 8080:8080 \
  -p 443:443 \
  -p 9997:9997 \
  -p 22:22 \
  -p 8089:8089 \
  splunk/attack_range

echo "[INFO] Startup complete."

