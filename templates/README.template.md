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
${GEYSER_ENV_VARS_TABLE}

## License

All software and files not created or managed by GeyserMC are licensed under the MIT license.

See GeyserMC's [license](https://github.com/GeyserMC/Geyser/blob/master/LICENSE).

## Disclaimer

This project is not affiliated with GeyserMC or any of its developers. This is an unofficial image.
