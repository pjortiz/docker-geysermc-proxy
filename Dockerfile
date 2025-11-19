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
ENV ="null"


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
