#!/bin/bash

# This script is used to generate the GEYSER_ENV_VARS_TABLE dynamically and replace ${GEYSER_ENV_VARS_TABLE} in

# Generate GEYSER_ENV_VARS_TABLE dynamically
# GEYSER_ENV_VARS_TABLE=""
# while read -r var; do
#     GEYSER_ENV_VARS_TABLE+="$var"$''
# done < <(jq -r 'to_entries | map("\(.key) | \(.value | to_entries[0].key) | \(.value | to_entries[0].value)") | .[]' ./.temp/env_map.json)

# jq -r 'to_entries | map("\(.key) | \(.value | to_entries[0].key) | \(.value | to_entries[0].value)") | join("\n")' ./.temp/env_map.json > ./.temp/readme_envs.txt
GEYSER_ENV_VARS_TABLE=$(jq -r 'to_entries | map("\(.key) | \(.value | to_entries[0].key) | \(.value | to_entries[0].value)") | join("\r")' ./.temp/env_map.json)

# Export the variable so envsubst can use it
export GEYSER_ENV_VARS_TABLE

# Use envsubst to replace ${GEYSER_ENV_VARS} in the template
# echo "${GEYSER_ENV_VARS_TABLE}"
envsubst '$GEYSER_ENV_VARS_TABLE' < templates/README.template.md > README.md
