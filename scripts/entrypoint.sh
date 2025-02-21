#!/bin/bash

# This is the entrypoint script for the Docker container to start GeyserMC.

# Load the environment variables
source ~/.bashrc

set -e
CONFIG_PATH="/Geyser/data/config.yml"
GEYSER_JAR=""
# check that /Geyser contains Geyser-*.jar file
if [ ! -f /Geyser/Geyser*.jar ]; then
    echo "Geyser jar not found in /Geyser"
    exit 1
else
    GEYSER_JAR=$(ls /Geyser/Geyser*.jar)
fi

# check that the config template exists
if [ ! -f /Geyser/config.yml.template ]; then
    echo "Config template not found in /Geyser"
    exit 1
fi

# use envsubst to replace environment variables in the config template
# need to use eval to allow for multi-line strings and comma delimitated lists to convert to yaml list
eval "cat <<EOF
$(envsubst < /Geyser/config.yml.template)
EOF
" > $CONFIG_PATH 2> /dev/null


echo "   _____                          __  __  _____ ";
echo "  / ____|                        |  \/  |/ ____|";
echo " | |  __  ___ _   _ ___  ___ _ __| \  / | |     ";
echo " | | |_ |/ _ \ | | / __|/ _ \ '__| |\/| | |     ";
echo " | |__| |  __/ |_| \__ \  __/ |  | |  | | |____ ";
echo "  \_____|\___|\__, |___/\___|_|  |_|  |_|\_____|";
echo "               __/ | Image Ver.: $IMAGE_VERSION ";
echo "              |___/  Geyser API: $GEYSER_VERSION";
echo "                          Build: $GEYSER_BUILD  ";

pushd ./data > /dev/null
echo "Starting GeyserMC..."
echo INIT_MEMORY: $INIT_MEMORY
echo MAX_MEMORY: $MAX_MEMORY
echo REMOTE_ADDRESS: $REMOTE_ADDRESS
echo REMOTE_PORT: $REMOTE_PORT
echo REMOTE_AUTH_TYPE: $REMOTE_AUTH_TYPE
java -Xms$INIT_MEMORY -Xmx$MAX_MEMORY -jar $GEYSER_JAR --nogui --config $CONFIG_PATH
popd > /dev/null


