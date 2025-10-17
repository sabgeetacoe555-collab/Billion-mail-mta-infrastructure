#!/bin/bash
mkdir -p config/opendkim
docker run --rm -ti \
  -v "$(pwd)/config/:/tmp/docker-mailserver/" \
  docker-mailserver/docker-mailserver:latest \
  generate-dkim
echo "✅ DKIM keys generated in config/opendkim."
echo "→ Add the public TXT record mail._domainkey.myissuesinc.com from the generated public key file."
