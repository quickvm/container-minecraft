#!/bin/bash

set -e

PAPERMC_VERSION=1.19.2
PAPERMC_PORT=25565
GEYSER_PORT=19132

# sudo firewall-cmd --add-port=25565/tcp --add-port=25565/udp --add-port=19132/udp --permanent

podman build --build-arg=PAPERMC_VERSION=${PAPERMC_VERSION} -f Containerfile -t localhost/papermc:${PAPERMC_VERSION} .

echo "Starting Paper Minecraft"
podman create --replace \
  --userns=keep-id \
  -p ${PAPERMC_PORT}:${PAPERMC_PORT} \
  -p ${PAPERMC_PORT}:${PAPERMC_PORT}/udp \
  -p ${GEYSER_PORT}:${GEYSER_PORT}/udp \
  --name minecraft \
  -e ${PAPERMC_VERSION} \
  -v ${PWD}/data:/data:Z \
  localhost/papermc:${PAPERMC_VERSION}
podman start minecraft

  # --restart=unless-stopped \
