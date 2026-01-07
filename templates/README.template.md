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
  -e JAVA_ADDRESS=mc \
  -e JAVA_AUTH_TYPE=floodgate \
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
    JAVA_ADDRESS: mc 
    # The port of the Minecraft server. Default is 25565
    # JAVA_PORT: 25565
    # The type of authentication to use. Default is online
    JAVA_AUTH_TYPE: floodgate
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

| Variable | Default | Description |
| --- | --- | --- |
${GEYSER_ENV_VARS_TABLE}

## License

All software and files not created or managed by GeyserMC are licensed under the MIT license.

See GeyserMC's [license](https://github.com/GeyserMC/Geyser/blob/master/LICENSE).

## Disclaimer

This project is not affiliated with GeyserMC or any of its developers. This is an unofficial image.
