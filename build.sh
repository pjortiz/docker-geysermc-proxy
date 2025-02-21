#!/bin/bash

source .venv/Scripts/activate
# Run pre-build.sh
./.github/workflows/scripts/pre-build.sh || exit 1

# Build the Docker image

tags_opts=$(jq -r '[.tags[] | "-t \(.)"] | join(" ")' build-info.json)

echo "tags_opts=${tags_opts}"

JAVA_VERSION=17
IMAGE_VERSION=$(jq -r '.version' build-info.json)
GEYSER_VERSION=$(jq -r '.geyser.version' build-info.json)
GEYSER_BUILD=$(jq -r '.geyser.build' build-info.json)
GEYSER_DOWNLOAD_URL=$(jq -r '.geyser.artifact.url' build-info.json)
GEYSER_JAR_SHA256=$(jq -r '.geyser.artifact.sha256' build-info.json)

echo "Building Docker image:"
echo "JAVA_VERSION=$JAVA_VERSION"
echo "IMAGE_VERSION=$IMAGE_VERSION"
echo "GEYSER_VERSION=$GEYSER_VERSION"
echo "GEYSER_BUILD=$GEYSER_BUILD"
echo "GEYSER_DOWNLOAD_URL=$GEYSER_DOWNLOAD_URL"
echo "GEYSER_JAR_SHA256=$GEYSER_JAR_SHA256"


# # docker build . --no-cache --progress=plain \
docker build . \
    --build-arg JAVA_VERSION=$JAVA_VERSION \
    --build-arg GEYSER_VERSION=$GEYSER_VERSION \
    --build-arg GEYSER_BUILD=$GEYSER_BUILD \
    --build-arg GEYSER_DOWNLOAD_URL=$GEYSER_DOWNLOAD_URL \
    --build-arg GEYSER_JAR_SHA256=$GEYSER_JAR_SHA256 \
     ${tags_opts[@]}