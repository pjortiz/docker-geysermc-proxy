#!/bin/bash

# Download and run the latest GeyserMC jar to generate config.yml
set -e

mkdir -p .temp

# Extract jar download URL and SHA256 from build-info.json
jar_url=$(jq -r '.geyser.artifact.url' build-info.json)
jar_sha256=$(jq -r '.geyser.artifact.sha256' build-info.json)
jar_name=$(jq -r '.geyser.artifact.name' build-info.json)

# Download the jar
echo "Downloading Geyser jar from: $jar_url"
curl -f -L -o ".temp/$jar_name" "$jar_url"

# Verify SHA256 checksum
echo "Verifying SHA256 checksum..."
echo "$jar_sha256  .temp/$jar_name" | sha256sum -c -

# Create a temporary directory for Geyser to run
mkdir -p .temp/geyser-run
cd .temp/geyser-run

# Run the jar with --nogui and capture output, stopping when "Done" appears
echo "Running Geyser jar to generate config.yml..."
java -jar "../$jar_name" --nogui 2>&1 | while IFS= read -r line; do
    echo "$line"
    if [[ "$line" == *"Done"* ]]; then
        pkill -f "java -jar"
        break
    fi
done

# Give it a moment to ensure the config file is written
sleep 2

# Move the generated config.yml to the expected location
if [ -f "config.yml" ]; then
    mv config.yml ../geyser_config.yml
    echo "Successfully generated config.yml"
else
    echo "Error: config.yml was not generated"
    exit 1
fi

cd ../..
