#!/bin/bash
set -e
echo "🚀 Bootstrapping RunPod instance..."

# Check if we're in a containerized environment without Docker privileges
if grep -q docker /proc/1/cgroup && ! docker info &>/dev/null; then
  echo "⚠️ Docker not available or lacks privileges in this environment."
  echo "Please see RUNPOD_DOCKER_GUIDE.md for deployment instructions."
  echo "You may need to select a RunPod template with Docker support."
  exit 1
fi

# Install Docker if missing
if ! command -v docker >/dev/null 2>&1; then
  echo "Installing Docker..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
fi

# Enable and start Docker service
if command -v systemctl >/dev/null 2>&1; then
  echo "Ensuring Docker service is running..."
  systemctl enable --now docker || true
fi

# Wait for Docker to be available
echo "Waiting for Docker to become available..."
timeout=60
while ! docker info &>/dev/null && [ $timeout -gt 0 ]; do
  echo "Waiting for Docker... ($timeout seconds left)"
  sleep 5
  timeout=$((timeout-5))
done

if ! docker info &>/dev/null; then
  echo "❌ Docker is still not available after waiting. Please check Docker installation."
  echo "You might need to try the rootless Docker setup with: bash ./deploy/setup_rootless_docker.sh"
  exit 1
fi

# Compose plugin check
if ! docker compose version &>/dev/null; then
  echo "Installing Docker Compose plugin..."
  apt-get update -y
  apt-get install -y docker-compose-plugin || true
  
  # Fallback to standalone compose if plugin fails
  if ! docker compose version &>/dev/null; then
    echo "Installing standalone docker-compose..."
    apt-get install -y python3-pip
    pip3 install docker-compose
  fi
fi

mkdir -p ~/myissues-mta
cd ~/myissues-mta

echo "Starting Billion Mail stack..."
docker compose up -d --build || docker-compose up -d --build

echo "Checking container status..."
sleep 10
docker ps || docker-compose ps

echo "✅ Deployment finished."
