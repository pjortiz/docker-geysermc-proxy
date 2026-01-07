#!/bin/bash

# This script is used to generate the GEYSER_ENV_VARS dynamically and replace ${GEYSER_ENV_VARS} in 
# the Dockerfile.template and create the Dockerfile.

# Generate GEYSER_ENV_VARS dynamically
GEYSER_ENV_VARS=""
while read -r var; do
    GEYSER_ENV_VARS+="$var"$'\n'
done < <(jq -r 'to_entries | map("ENV \(.key)=\"\(.value | to_entries[0].value)\"") | .[]' ./env_map.json)

# Export the variable so envsubst can use it
export GEYSER_ENV_VARS

# Use envsubst to replace ${GEYSER_ENV_VARS} in the template
envsubst '${GEYSER_ENV_VARS}' < templates/Dockerfile.template > Dockerfile


