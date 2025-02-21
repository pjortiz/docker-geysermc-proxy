ARG JAVA_VERSION=17
FROM openjdk:${JAVA_VERSION}-slim AS build

ARG IMAGE_VERSION=local
ARG GEYSER_VERSION=latest
ARG GEYSER_BUILD=latest
ARG GEYSER_DOWNLOAD_URL=https://download.geysermc.org/v2/projects/geyser/versions/${GEYSER_VERSION}/builds/${GEYSER_BUILD}/downloads/standalone
ARG GEYSER_JAR_SHA256

LABEL org.opencontainers.image.authors="Peter Ortiz (https://github.com/pjortiz)"

# Java Start Options
ENV INIT_MEMORY "1024M"
ENV MAX_MEMORY "1024M"

# Set Version Variables
ENV IMAGE_VERSION=${IMAGE_VERSION}
ENV GEYSER_VERSION=${GEYSER_VERSION}
ENV GEYSER_BUILD=${GEYSER_BUILD}

# Geyser Settings
ENV BEDROCK_MOTD1="Geyser"
ENV BEDROCK_MOTD2="Another Geyser server."
ENV BEDROCK_SERVER_NAME="Geyser"
ENV BEDROCK_COMPRESSION_LEVEL="6"
ENV BEDROCK_BROADCAST_PORT="19132"
ENV BEDROCK_ENABLE_PROXY_PROTOCOL="false"
ENV BEDROCK_PROXY_PROTOCOL_WHITELISTED_IPS=""
ENV REMOTE_ADDRESS="auto"
ENV REMOTE_PORT="25565"
ENV REMOTE_AUTH_TYPE="online"
ENV REMOTE_USE_PROXY_PROTOCOL="false"
ENV REMOTE_FORWARD_HOSTNAME="true"
ENV SAVED_USER_LOGINS=""
ENV PENDING_AUTHENTICATION_TIMEOUT="120"
ENV COMMAND_SUGGESTIONS="true"
ENV PASSTHROUGH_MOTD="true"
ENV PASSTHROUGH_PLAYER_COUNTS="true"
ENV LEGACY_PING_PASSTHROUGH="false"
ENV PING_PASSTHROUGH_INTERVAL="3"
ENV FORWARD_PLAYER_PING="false"
ENV MAX_PLAYERS="100"
ENV DEBUG_MODE="false"
ENV SHOW_COOLDOWN="title"
ENV SHOW_COORDINATES="true"
ENV DISABLE_BEDROCK_SCAFFOLDING="false"
ENV EMOTE_OFFHAND_WORKAROUND="disabled"
ENV CACHE_IMAGES="0"
ENV ALLOW_CUSTOM_SKULLS="true"
ENV MAX_VISIBLE_CUSTOM_SKULLS="128"
ENV CUSTOM_SKULL_RENDER_DISTANCE="32"
ENV ADD_NON_BEDROCK_ITEMS="true"
ENV ABOVE_BEDROCK_NETHER_BUILDING="false"
ENV FORCE_RESOURCE_PACKS="true"
ENV XBOX_ACHIEVEMENTS_ENABLED="false"
ENV LOG_PLAYER_IP_ADDRESSES="true"
ENV NOTIFY_ON_NEW_BEDROCK_UPDATE="true"
ENV UNUSABLE_SPACE_BLOCK="minecraft:barrier"
ENV METRICS_ENABLED="false"
ENV METRICS_UUID="generateduuid"
ENV SCOREBOARD_PACKET_THRESHOLD="20"
ENV ENABLE_PROXY_CONNECTIONS="false"
ENV MTU="1400"
ENV USE_DIRECT_CONNECTION="true"
ENV DISABLE_COMPRESSION="true"


# Install unzip
RUN apt-get update && \
    apt-get install -y gettext && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

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
# The Floodgate key.pem directory
VOLUME /Geyser/floodgate 

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
