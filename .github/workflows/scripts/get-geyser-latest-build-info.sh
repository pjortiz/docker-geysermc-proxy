#!/bin/bash

# This script is used to get the build info of the latest build, creates the tags array, 
# and the Standalone artifact for GeyserMC/Geyser using the GeyserMC API.

set -e

OUTPUT_FILE="build-info.json"

VERSION=${VERSION:-local}
REGISTRY_IMAGE=${REGISTRY_IMAGE:-geysermc-proxy}

# Get the latest version info from GeyserMC API, and create the build info
build_info=$(curl -f -sL https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest | jq -r --arg repo_version "$VERSION" --arg registry_image "$REGISTRY_IMAGE" '
    { 
        name: "Build \($repo_version) with GeyserMC build \(.build)", 
        version: "\($repo_version)",
        tags: [
            "\($registry_image):\($repo_version)-\(.build)",
            "\($registry_image):\($repo_version)",
            "\($registry_image):\(.build)",
            "\($registry_image):latest"
        ],
        geyser: {
            version: (.version),
            build: (.build),
            head_sha: (.changes[-1].commit),
            time,
            artifact: {
                name: (.downloads.standalone.name),
                url: "https://download.geysermc.org/v2/projects/geyser/versions/\(.version)/builds/\(.build)/downloads/standalone",
                sha256: (.downloads.standalone.sha256)
            }
        },
    }
')

# Print the final result
echo "$build_info"
echo "$build_info" > "$OUTPUT_FILE"
 


