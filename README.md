# docker-geysermc-proxy (Unofficial)

## Description

This image contains the GeyserMC Standalone Proxy, which allows you to connect to Java Edition Minecarft servers from Bedrock Edition clients. Please refer to the [GeyserMC](https://geysermc.org/) website for more information.

## Usage

### Command Line

```bash
TODO
```

### Docker Compose

```yaml
TODO
```

## Environment Variables
Take a look [here](https://geysermc.org/wiki/geyser/setup/) for how to set up Geyser.
Variable | Config file Equivalent | Default
--- | --- | ---
BEDROCK_MOTD1 | bedrock.motd1 | GeyserBEDROCK_MOTD2 | bedrock.motd2 | Another Geyser server.BEDROCK_SERVER_NAME | bedrock.server-name | GeyserBEDROCK_COMPRESSION_LEVEL | bedrock.compression-level | 6BEDROCK_BROADCAST_PORT | bedrock.broadcast-port | 19132BEDROCK_ENABLE_PROXY_PROTOCOL | bedrock.enable-proxy-protocol | falseBEDROCK_PROXY_PROTOCOL_WHITELISTED_IPS | bedrock.proxy-protocol-whitelisted-ips |REMOTE_ADDRESS | remote.address | autoREMOTE_PORT | remote.port | 25565REMOTE_AUTH_TYPE | remote.auth-type | onlineREMOTE_USE_PROXY_PROTOCOL | remote.use-proxy-protocol | falseREMOTE_FORWARD_HOSTNAME | remote.forward-hostname | trueSAVED_USER_LOGINS | saved-user-logins |PENDING_AUTHENTICATION_TIMEOUT | pending-authentication-timeout | 120COMMAND_SUGGESTIONS | command-suggestions | truePASSTHROUGH_MOTD | passthrough-motd | truePASSTHROUGH_PLAYER_COUNTS | passthrough-player-counts | trueLEGACY_PING_PASSTHROUGH | legacy-ping-passthrough | falsePING_PASSTHROUGH_INTERVAL | ping-passthrough-interval | 3FORWARD_PLAYER_PING | forward-player-ping | falseMAX_PLAYERS | max-players | 100DEBUG_MODE | debug-mode | falseSHOW_COOLDOWN | show-cooldown | titleSHOW_COORDINATES | show-coordinates | trueDISABLE_BEDROCK_SCAFFOLDING | disable-bedrock-scaffolding | falseEMOTE_OFFHAND_WORKAROUND | emote-offhand-workaround | disabledCACHE_IMAGES | cache-images | 0ALLOW_CUSTOM_SKULLS | allow-custom-skulls | trueMAX_VISIBLE_CUSTOM_SKULLS | max-visible-custom-skulls | 128CUSTOM_SKULL_RENDER_DISTANCE | custom-skull-render-distance | 32ADD_NON_BEDROCK_ITEMS | add-non-bedrock-items | trueABOVE_BEDROCK_NETHER_BUILDING | above-bedrock-nether-building | falseFORCE_RESOURCE_PACKS | force-resource-packs | trueXBOX_ACHIEVEMENTS_ENABLED | xbox-achievements-enabled | falseLOG_PLAYER_IP_ADDRESSES | log-player-ip-addresses | trueNOTIFY_ON_NEW_BEDROCK_UPDATE | notify-on-new-bedrock-update | trueUNUSABLE_SPACE_BLOCK | unusable-space-block | minecraft:barrierMETRICS_ENABLED | metrics.enabled | falseMETRICS_UUID | metrics.uuid | generateduuidSCOREBOARD_PACKET_THRESHOLD | scoreboard-packet-threshold | 20ENABLE_PROXY_CONNECTIONS | enable-proxy-connections | falseMTU | mtu | 1400USE_DIRECT_CONNECTION | use-direct-connection | trueDISABLE_COMPRESSION | disable-compression | true

## License 

All software and files not created or managed by GeyserMC are licensed under the MIT license.

See GeyserMC's [license](https://github.com/GeyserMC/Geyser/blob/master/LICENSE).

## Disclaimer

This project is not affiliated with GeyserMC or any of its developers. This is an unofficial image.
