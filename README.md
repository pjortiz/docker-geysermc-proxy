# Docker GeyserMC Proxy (Unofficial)
[![Build](https://github.com/pjortiz/docker-geysermc-proxy/actions/workflows/build.yml/badge.svg)](https://github.com/pjortiz/docker-geysermc-proxy/actions/workflows/build.yml) 
![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Fpjortiz%2Fdocker-geysermc-proxy%2Frefs%2Fheads%2Fmain%2Fbuild-info.json&query=version&label=Image%20Version)
![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Fpjortiz%2Fdocker-geysermc-proxy%2Frefs%2Fheads%2Fmain%2Fbuild-info.json&query=geyser.version&label=API%20Version)
![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Fpjortiz%2Fdocker-geysermc-proxy%2Frefs%2Fheads%2Fmain%2Fbuild-info.json&query=geyser.build&label=Build)
![Docker Pulls](https://img.shields.io/docker/pulls/portiz93/geysermc-proxy)



## Description

This image contains the GeyserMC Standalone Proxy, which allows you to connect to Java Edition Minecarft servers from Bedrock Edition clients. Please refer to the [GeyserMC](https://geysermc.org/) website for more information.

## Usage

### Command Line

```bash
docker run -d \
  --name geyser-proxy \
  --restart unless-stopped \
  -e REMOTE_ADDRESS=mc \
  -e REMOTE_AUTH_TYPE=floodgate \
  -v geyser-data:/Geyser/data \
  -v /path/to/floodgate/key.pem:/Geyser/floodgate/key.pem \
  portiz93/geysermc-proxy:latest
```

### Docker Compose

```yaml
volumes:
  geyser-data:

geyser-proxy:
  image: portiz93/geysermc-proxy:latest
#   Add your Minecraft server service to wait for it to be healthy
#   depends_on:
#     mc: 
#     condition: service_healthy
  environment:
    # The name of the Minecraft server service or the IP address of the server
    REMOTE_ADDRESS: mc 
    # The port of the Minecraft server. Default is 25565
    # REMOTE_PORT: 25565
    # The type of authentication to use. Default is online
    REMOTE_AUTH_TYPE: floodgate
  restart: unless-stopped
  volumes:
    - geyser-data:/Geyser/data
    # Replace local path with the path to your Floodgate key.pem file
    - /path/to/floodgate/key.pem:/Geyser/floodgate/key.pem
```

## Floodgate

If you intend to use Floodgate, you will need to mount the Floodgate key.pem file directly to `/Geyser/floodgate/key.pem` in the container.

## Environment Variables
Take a look [here](https://geysermc.org/wiki/geyser/setup/) for how to set up Geyser.

Variable | Config file Equivalent | Default
--- | --- | ---
BEDROCK_ADDRESS | bedrock.address | 0.0.0.0JAVA_ADDRESS | java.address | 127.0.0.1JAVA_PORT | java.port | 25565JAVA_AUTH_TYPE | java.auth-type | onlineJAVA_FORWARD_HOSTNAME | java.forward-hostname | trueMOTD_PRIMARY_MOTD | motd.primary-motd | GeyserMOTD_SECONDARY_MOTD | motd.secondary-motd | Another Geyser server.MOTD_PASSTHROUGH_MOTD | motd.passthrough-motd | trueMOTD_MAX_PLAYERS | motd.max-players | 100MOTD_PASSTHROUGH_PLAYER_COUNTS | motd.passthrough-player-counts | trueMOTD_PING_PASSTHROUGH_INTERVAL | motd.ping-passthrough-interval | 3GAMEPLAY_SERVER_NAME | gameplay.server-name | GeyserGAMEPLAY_SHOW_COOLDOWN | gameplay.show-cooldown | titleGAMEPLAY_COMMAND_SUGGESTIONS | gameplay.command-suggestions | trueGAMEPLAY_SHOW_COORDINATES | gameplay.show-coordinates | trueGAMEPLAY_DISABLE_BEDROCK_SCAFFOLDING | gameplay.disable-bedrock-scaffolding | falseGAMEPLAY_NETHER_ROOF_WORKAROUND | gameplay.nether-roof-workaround | falseGAMEPLAY_EMOTES_ENABLED | gameplay.emotes-enabled | trueGAMEPLAY_UNUSABLE_SPACE_BLOCK | gameplay.unusable-space-block | minecraft:barrierGAMEPLAY_ENABLE_CUSTOM_CONTENT | gameplay.enable-custom-content | trueGAMEPLAY_FORCE_RESOURCE_PACKS | gameplay.force-resource-packs | trueGAMEPLAY_ENABLE_INTEGRATED_PACK | gameplay.enable-integrated-pack | trueGAMEPLAY_FORWARD_PLAYER_PING | gameplay.forward-player-ping | falseGAMEPLAY_XBOX_ACHIEVEMENTS_ENABLED | gameplay.xbox-achievements-enabled | falseGAMEPLAY_MAX_VISIBLE_CUSTOM_SKULLS | gameplay.max-visible-custom-skulls | 128GAMEPLAY_CUSTOM_SKULL_RENDER_DISTANCE | gameplay.custom-skull-render-distance | 32DEFAULT_LOCALE | default-locale | systemLOG_PLAYER_IP_ADDRESSES | log-player-ip-addresses | trueSAVED_USER_LOGINS | saved-user-logins | PENDING_AUTHENTICATION_TIMEOUT | pending-authentication-timeout | 120NOTIFY_ON_NEW_BEDROCK_UPDATE | notify-on-new-bedrock-update | trueADVANCED_CACHE_IMAGES | advanced.cache-images | 0ADVANCED_SCOREBOARD_PACKET_THRESHOLD | advanced.scoreboard-packet-threshold | 20ADVANCED_ADD_TEAM_SUGGESTIONS | advanced.add-team-suggestions | trueADVANCED_RESOURCE_PACK_URLS | advanced.resource-pack-urls | ADVANCED_JAVA_USE_HAPROXY_PROTOCOL | advanced.java.use-haproxy-protocol | falseADVANCED_BEDROCK_BROADCAST_PORT | advanced.bedrock.broadcast-port | 0ADVANCED_BEDROCK_COMPRESSION_LEVEL | advanced.bedrock.compression-level | 6ADVANCED_BEDROCK_USE_HAPROXY_PROTOCOL | advanced.bedrock.use-haproxy-protocol | falseADVANCED_BEDROCK_HAPROXY_PROTOCOL_WHITELISTED_IPS | advanced.bedrock.haproxy-protocol-whitelisted-ips | ADVANCED_BEDROCK_MTU | advanced.bedrock.mtu | 1400ADVANCED_BEDROCK_VALIDATE_BEDROCK_LOGIN | advanced.bedrock.validate-bedrock-login | trueENABLE_METRICS | enable-metrics | falseMETRICS_UUID | metrics-uuid | ab1a91dc-d540-4378-8e23-1e3d7ddc31d1DEBUG_MODE | debug-mode | false

## License

All software and files not created or managed by GeyserMC are licensed under the MIT license.

See GeyserMC's [license](https://github.com/GeyserMC/Geyser/blob/master/LICENSE).

## Disclaimer

This project is not affiliated with GeyserMC or any of its developers. This is an unofficial image.
