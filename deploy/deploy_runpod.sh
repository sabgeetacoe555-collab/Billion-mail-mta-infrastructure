#!/bin/bash
set -e
echo "🚀 Bootstrapping RunPod instance..."

# Install Docker if missing
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
fi

# Compose plugin check
if ! docker compose version >/dev/null 2>&1; then
  apt-get install -y docker-compose-plugin
fi

mkdir -p ~/myissues-mta
cd ~/myissues-mta

echo "Starting Billion Mail stack..."
docker compose up -d --build

sleep 10
docker ps
echo "✅ Deployment finished."
