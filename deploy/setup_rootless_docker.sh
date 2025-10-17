#!/bin/bash
set -e
echo "🚀 Setting up rootless Docker..."

# Install dependencies
apt update -y
apt install -y uidmap dbus-user-session fuse-overlayfs slirp4netns curl

# Install rootless Docker
curl -fsSL https://get.docker.com/rootless | sh

# Add to path and configure environment
echo 'export PATH=/usr/bin:$PATH' >> ~/.bashrc
echo 'export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock' >> ~/.bashrc
source ~/.bashrc

# Start Docker service
systemctl --user start docker
systemctl --user enable docker

# Test Docker
docker version
docker info

echo "✅ Rootless Docker setup complete. Use 'docker' commands as normal."