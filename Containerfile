FROM quay.io/quickvm/fedora:36
MAINTAINER "QuickVM BuildBot <buildbot@quickvm.com>"

USER root
RUN dnf upgrade --setopt install_weak_deps=false -y && dnf clean all -y && rm -rf /var/cache/yum/*

RUN dnf upgrade --setopt install_weak_deps=false -y && \
    dnf install jq mcrcon java-latest-openjdk -y && \
    dnf -y clean all && rm -rf /var/cache/yum && \
    mkdir -p /opt/minecraft

ARG PAPERMC_VERSION=1.19.2
ENV PAPERMC_VERSION=${PAPERMC_VERSION}
ENV PAPERMC_RAM=3G
ENV JAVAFLAGS="-Dlog4j2.formatMsgNoLookups=true -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=mcflags.emc.gs -Dcom.mojang.eula.agree=true"
ENV PAPERMC_FLAGS="--nojline"

WORKDIR /opt/minecraft
COPY ./download_jars.sh /opt/minecraft
RUN chmod +x /opt/minecraft/download_jars.sh
RUN /opt/minecraft/download_jars.sh papermc

RUN useradd minecraft
COPY /entrypoint.sh /opt/minecraft
RUN chmod +x /opt/minecraft/entrypoint.sh
RUN chown minecraft:minecraft /opt/minecraft/ -R

EXPOSE 25565/tcp
EXPOSE 25565/udp
EXPOSE 19132/udp

WORKDIR /data
USER minecraft

ENTRYPOINT ["/opt/minecraft/entrypoint.sh"]
CMD ["run"]
