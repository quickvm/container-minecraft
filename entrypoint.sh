#!/bin/bash

set -e

case "$@" in

  run)
    echo "Downloading plugins..."
    /opt/minecraft/download_jars.sh plugins

    echo "Running Paper Minecraft..."
    exec java -jar -Xms${PAPERMC_RAM} -Xmx${PAPERMC_RAM} ${JAVAFLAGS} /opt/minecraft/papermc-${PAPERMC_VERSION}.jar $PAPERMC_FLAGS nogui
    ;;

  *)
    echo "Running command:"
    echo "$@"
    exec "$@"
    ;;

esac
