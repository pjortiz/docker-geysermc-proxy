#!/bin/bash

mkdir -p .temp

# Generate the build info for the latest GeyserMC build
./.github/workflows/scripts/get-geyser-latest-build-info.sh || exit 1

# Download the latest GeyserMC config.yml
./.github/workflows/scripts/download-geyser-config.sh || exit 1

# Generate the GeyserMC config template
pip install -r .github/workflows/scripts/requirements.txt || exit 1
python .github/workflows/scripts/geyser-config-templater.py || exit 1

# Generate the GeyserMC Dockerfile
./.github/workflows/scripts/generate-dockerfile.sh || exit 1

# Generate README.md
./.github/workflows/scripts/generate-readme.sh || exit 1