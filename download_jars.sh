#!/bin/bash

set -e

download_papermc() {
  # Download PaperMC
  PAPERMC_LATEST_BUILD=$(curl -s "https://papermc.io/api/v2/projects/paper/versions/${PAPERMC_VERSION}" | jq '.builds[-1]')

  PAPERMC_LATEST_DOWNLOAD=$(curl -s "https://papermc.io/api/v2/projects/paper/versions/${PAPERMC_VERSION}/builds/${PAPERMC_LATEST_BUILD}" | jq '.downloads.application.name' -r)

  PAPERMC_DOWNLOAD_URL="https://papermc.io/api/v2/projects/paper/versions/${PAPERMC_VERSION}/builds/${PAPERMC_LATEST_BUILD}/downloads/${PAPERMC_LATEST_DOWNLOAD}"
  curl -s -o papermc-${PAPERMC_VERSION}.jar ${PAPERMC_DOWNLOAD_URL}
}

download_plugins () {
  mkdir -p /data/plugins
  cd /data/plugins

  # Download Geyser-Spigot
  curl -s -O https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/target/Geyser-Spigot.jar

  # Download Floodgate-Spigot
  curl -s -O https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/build/libs/floodgate-spigot.jar
}

case "$@" in

  papermc)
    echo "Downloading Paper Minecraft..."
    download_papermc
    ;;

  plugins)
    echo "Downloading Plugins..."
    download_plugins
    ;;

  *)
    echo "Downloading Paper Minecraft..."
    download_papermc
    echo "Downloading Plugins..."
    download_plugins
    ;;

esac
