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

## Floodgate

If you intend to use Floodgate, you will need to mount the Floodgate key.pem file directly to `/Geyser/floodgate/key.pem` in the container.

## Environment Variables
Take a look [here](https://geysermc.org/wiki/geyser/setup/) for how to set up Geyser.

Variable | Config file Equivalent | Default
--- | --- | ---
BEDROCK_MOTD1 | bedrock.motd1 | GeyserBEDROCK_MOTD2 | bedrock.motd2 | Another Geyser server.BEDROCK_SERVER_NAME | bedrock.server-name | GeyserBEDROCK_COMPRESSION_LEVEL | bedrock.compression-level | 6BEDROCK_BROADCAST_PORT | bedrock.broadcast-port | 19132BEDROCK_ENABLE_PROXY_PROTOCOL | bedrock.enable-proxy-protocol | falseBEDROCK_PROXY_PROTOCOL_WHITELISTED_IPS | bedrock.proxy-protocol-whitelisted-ips | REMOTE_ADDRESS | remote.address | autoREMOTE_PORT | remote.port | 25565REMOTE_AUTH_TYPE | remote.auth-type | onlineREMOTE_USE_PROXY_PROTOCOL | remote.use-proxy-protocol | falseREMOTE_FORWARD_HOSTNAME | remote.forward-hostname | trueSAVED_USER_LOGINS | saved-user-logins | PENDING_AUTHENTICATION_TIMEOUT | pending-authentication-timeout | 120COMMAND_SUGGESTIONS | command-suggestions | truePASSTHROUGH_MOTD | passthrough-motd | truePASSTHROUGH_PLAYER_COUNTS | passthrough-player-counts | trueLEGACY_PING_PASSTHROUGH | legacy-ping-passthrough | falsePING_PASSTHROUGH_INTERVAL | ping-passthrough-interval | 3FORWARD_PLAYER_PING | forward-player-ping | falseMAX_PLAYERS | max-players | 100DEBUG_MODE | debug-mode | falseSHOW_COOLDOWN | show-cooldown | titleSHOW_COORDINATES | show-coordinates | trueDISABLE_BEDROCK_SCAFFOLDING | disable-bedrock-scaffolding | falseEMOTE_OFFHAND_WORKAROUND | emote-offhand-workaround | disabledCACHE_IMAGES | cache-images | 0ALLOW_CUSTOM_SKULLS | allow-custom-skulls | trueMAX_VISIBLE_CUSTOM_SKULLS | max-visible-custom-skulls | 128CUSTOM_SKULL_RENDER_DISTANCE | custom-skull-render-distance | 32ADD_NON_BEDROCK_ITEMS | add-non-bedrock-items | trueABOVE_BEDROCK_NETHER_BUILDING | above-bedrock-nether-building | falseFORCE_RESOURCE_PACKS | force-resource-packs | trueXBOX_ACHIEVEMENTS_ENABLED | xbox-achievements-enabled | falseLOG_PLAYER_IP_ADDRESSES | log-player-ip-addresses | trueNOTIFY_ON_NEW_BEDROCK_UPDATE | notify-on-new-bedrock-update | trueUNUSABLE_SPACE_BLOCK | unusable-space-block | minecraft:barrierMETRICS_ENABLED | metrics.enabled | falseMETRICS_UUID | metrics.uuid | generateduuidSCOREBOARD_PACKET_THRESHOLD | scoreboard-packet-threshold | 20ENABLE_PROXY_CONNECTIONS | enable-proxy-connections | falseMTU | mtu | 1400USE_DIRECT_CONNECTION | use-direct-connection | trueDISABLE_COMPRESSION | disable-compression | true

## License

All software and files not created or managed by GeyserMC are licensed under the MIT license.

See GeyserMC's [license](https://github.com/GeyserMC/Geyser/blob/master/LICENSE).

## Disclaimer

This project is not affiliated with GeyserMC or any of its developers. This is an unofficial image.
