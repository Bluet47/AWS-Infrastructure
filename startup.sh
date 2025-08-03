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
  -p 8000:8000 \  # Splunk Web
  -p 8080:8080 \  # Guacamole
  -p 443:443 \    # HTTPS if needed
  -p 9997:9997 \  # Splunk Forwarder
  -p 22:22 \      # SSH (optional, if container supports)
  -p 8089:8089 \  # Splunk Management Port
  splunk/attack_range

echo "[INFO] Startup complete."
