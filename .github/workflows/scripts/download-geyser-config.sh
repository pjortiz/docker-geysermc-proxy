#!/bin/bash

# Download the latest GeyserMC config.yml
mkdir -p .temp
head=$(jq -r '.geyser.head_sha' build-info.json)
curl -f -s https://raw.githubusercontent.com/GeyserMC/Geyser/$head/core/src/main/resources/config.yml > .temp/geyser_config.yml
sed -ri 's/# broadcast-port:/broadcast-port:/g' .temp/geyser_config.yml
sed -ri 's/#proxy-protocol-whitelisted-ips:/proxy-protocol-whitelisted-ips:/g' .temp/geyser_config.yml
