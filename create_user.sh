#!/bin/bash
# Usage: ./create_user.sh user@domain.com Password

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 user@domain.com Password"
  exit 1
fi

EMAIL="$1"
PASS="$2"

if ! docker ps | grep -q billionmail-mta; then
  echo "Error: container not running. Start it with: docker compose up -d"
  exit 1
fi

echo "Creating mailbox: $EMAIL ..."
docker run --rm -ti \
  -v "$(pwd)/config/:/tmp/docker-mailserver/" \
  -v maildata:/var/mail \
  docker-mailserver/docker-mailserver:latest \
  setup email add "$EMAIL" "$PASS"

echo "Mailbox added successfully."
