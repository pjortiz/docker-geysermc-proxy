FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

ARG JAVA_VERSION=17
ARG IMAGE_VERSION=local
ARG GEYSER_VERSION=latest
ARG GEYSER_BUILD=latest
ARG GEYSER_DOWNLOAD_URL=https://download.geysermc.org/v2/projects/geyser/versions/${GEYSER_VERSION}/builds/${GEYSER_BUILD}/downloads/standalone
ARG GEYSER_JAR_SHA256

LABEL org.opencontainers.image.authors="Peter Ortiz (https://github.com/pjortiz)"

# Java Start Options
ENV INIT_MEMORY="1024M"
ENV MAX_MEMORY="1024M"

# Set Version Variables
ENV IMAGE_VERSION=${IMAGE_VERSION}
ENV GEYSER_VERSION=${GEYSER_VERSION}
ENV GEYSER_BUILD=${GEYSER_BUILD}

# Geyser Settings
ENV BEDROCK_ADDRESS="0.0.0.0"
ENV BEDROCK_PORT="19132"
ENV JAVA_ADDRESS="127.0.0.1"
ENV JAVA_PORT="25565"
ENV JAVA_AUTH_TYPE="online"
ENV JAVA_FORWARD_HOSTNAME="true"
ENV MOTD_PRIMARY_MOTD="Geyser"
ENV MOTD_SECONDARY_MOTD="Another Geyser server."
ENV MOTD_PASSTHROUGH_MOTD="true"
ENV MOTD_MAX_PLAYERS="100"
ENV MOTD_PASSTHROUGH_PLAYER_COUNTS="true"
ENV MOTD_PING_PASSTHROUGH_INTERVAL="3"
ENV GAMEPLAY_SERVER_NAME="Geyser"
ENV GAMEPLAY_SHOW_COOLDOWN="title"
ENV GAMEPLAY_COMMAND_SUGGESTIONS="true"
ENV GAMEPLAY_SHOW_COORDINATES="true"
ENV GAMEPLAY_DISABLE_BEDROCK_SCAFFOLDING="false"
ENV GAMEPLAY_NETHER_ROOF_WORKAROUND="false"
ENV GAMEPLAY_EMOTES_ENABLED="true"
ENV GAMEPLAY_UNUSABLE_SPACE_BLOCK="minecraft:barrier"
ENV GAMEPLAY_ENABLE_CUSTOM_CONTENT="true"
ENV GAMEPLAY_FORCE_RESOURCE_PACKS="true"
ENV GAMEPLAY_ENABLE_INTEGRATED_PACK="true"
ENV GAMEPLAY_FORWARD_PLAYER_PING="false"
ENV GAMEPLAY_XBOX_ACHIEVEMENTS_ENABLED="false"
ENV GAMEPLAY_MAX_VISIBLE_CUSTOM_SKULLS="128"
ENV GAMEPLAY_CUSTOM_SKULL_RENDER_DISTANCE="32"
ENV DEFAULT_LOCALE="system"
ENV LOG_PLAYER_IP_ADDRESSES="true"
ENV SAVED_USER_LOGINS=""
ENV PENDING_AUTHENTICATION_TIMEOUT="120"
ENV NOTIFY_ON_NEW_BEDROCK_UPDATE="true"
ENV ADVANCED_CACHE_IMAGES="0"
ENV ADVANCED_SCOREBOARD_PACKET_THRESHOLD="20"
ENV ADVANCED_ADD_TEAM_SUGGESTIONS="true"
ENV ADVANCED_RESOURCE_PACK_URLS=""
ENV ADVANCED_JAVA_USE_HAPROXY_PROTOCOL="false"
ENV ADVANCED_BEDROCK_BROADCAST_PORT="0"
ENV ADVANCED_BEDROCK_COMPRESSION_LEVEL="6"
ENV ADVANCED_BEDROCK_USE_HAPROXY_PROTOCOL="false"
ENV ADVANCED_BEDROCK_HAPROXY_PROTOCOL_WHITELISTED_IPS=""
ENV ADVANCED_BEDROCK_MTU="1400"
ENV ADVANCED_BEDROCK_VALIDATE_BEDROCK_LOGIN="true"
ENV ENABLE_METRICS="false"
ENV METRICS_UUID="01600b35-b31e-4c62-9397-425d001d337c"
ENV DEBUG_MODE="false"


# Install java 17 and other dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-${JAVA_VERSION}-jre-headless \
        gettext-base && \
    apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set JAVA_HOME (Optional but recommended)
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Verify Java installation
RUN java -version

# Download Geyser Zip file
ADD $GEYSER_DOWNLOAD_URL /tmp/Geyser.jar

RUN ls -lsa /tmp

# Check the SHA256 sum
RUN \[ ! -z "${GEYSER_JAR_SHA256}" \] && (echo "${GEYSER_JAR_SHA256}  /tmp/Geyser.jar" | sha256sum -c | grep OK || exit 1)

# The default port for MC Bedrock
EXPOSE 19132/tcp
EXPOSE 19132/udp

RUN mkdir /Geyser

# Copy the Geyser jar
RUN mv /tmp/Geyser.jar /Geyser/Geyser.jar

# Copy the entrypoint script and the config template
COPY ./scripts/entrypoint.sh /entrypoint.sh
COPY templates/geyser_config.template.yml /Geyser/config.yml.template

# Create the geyser user
RUN useradd -ms /bin/bash geyser
RUN chown -R geyser:geyser /Geyser
USER geyser

# Set readonly variables
RUN echo "readonly IMAGE_VERSION" >> ~/.bashrc
RUN echo "readonly GEYSER_VERSION" >> ~/.bashrc
RUN echo "readonly GEYSER_BUILD" >> ~/.bashrc

WORKDIR /Geyser

RUN mkdir /Geyser/data
RUN mkdir /Geyser/floodgate

RUN ls -lsa /Geyser

# The Geyser config directory
VOLUME /Geyser/data

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
