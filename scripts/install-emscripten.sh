#!/bin/bash

if [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
  echo "This will be executed during docker install."
  echo "Install emscripten in order to export to javascript: "
  echo "  docker exec -d $DOCKER_TAG_NAME $DOCKER_BUILD_SCRIPT/${0}"
  echo "After the download is complete, save the current state:"
  echo "  docker commit <container-id> $DOCKER_TAG_NAME"
  exit 0
fi

cd ${DOCKER_WORKING_DIR}

echo "* Download emscripten"
wget -O ${DOCKER_WORKING_DIR}emsdk-portable.tar.gz https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz
tar -xzf emsdk-portable.tar.gz -C $DOCKER_GODOT_EMSCRIPTEN
mv ${DOCKER_GODOT_EMSCRIPTEN}/emsdk-portable/* ${DOCKER_GODOT_EMSCRIPTEN}
# cleanup
rm -f ${DOCKER_WORKING_DIR}emsdk-portable.tar.gz
rmdir ${DOCKER_GODOT_EMSCRIPTEN}/emsdk-portable

echo "* Setup emscripten"

# Fetch the latest registry of available tools.
${DOCKER_GODOT_EMSCRIPTEN}/emsdk update

# Download and install the latest SDK tools.
${DOCKER_GODOT_EMSCRIPTEN}/emsdk install latest

# Make the "latest" SDK "active" for the current user. (writes ~/.emscripten file)
${DOCKER_GODOT_EMSCRIPTEN}/emsdk activate latest

# Activate PATH and other environment variables in the current terminal
source ${DOCKER_GODOT_EMSCRIPTEN}/emsdk_env.sh

echo "** Setup emscripten complete!"