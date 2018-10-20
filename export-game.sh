#!/bin/bash

if [ "$#" == 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
  echo "To export your godot game, go to your source directory and run: "
  echo "  docker run --rm -it -v \`pwd\`:/root/workspace/game/ h4de5/docker-godot-3-build-and-run:latest /root/workspace/build-scripts/${0} <gamename>"
  # echo "  docker exec -d $DOCKER_TAG_NAME $DOCKER_BUILD_SCRIPT/${0} <gamename>"
  echo "exported files will be in directory /root/workspace/exports/"
  exit 0
fi

# create project directory
mkdir -p ~/.config/godot/projects

cd "$DOCKER_GODOT_GAME_SOURCE"
echo "* Exporting for windows to: $DOCKER_GODOT_EXPORT_GAME/win/"
mkdir -p "$DOCKER_GODOT_EXPORT_GAME/win/"
$DOCKER_GODOT_SERVER_BINARY --export "Windows Desktop" -path "$DOCKER_GODOT_EXPORT_GAME/win/${1}.exe"

echo "* Exporting for HTML5 to: $DOCKER_GODOT_EXPORT_GAME/web/"
mkdir -p "$DOCKER_GODOT_EXPORT_GAME/web/"
# bug in optimize export
$DOCKER_GODOT_SERVER_BINARY --export-debug "HTML5" -path "$DOCKER_GODOT_EXPORT_GAME/web/index.html"

echo "* Exporting for linux to: $DOCKER_GODOT_EXPORT_GAME/linux/"
mkdir -p "$DOCKER_GODOT_EXPORT_GAME/linux/"
$DOCKER_GODOT_SERVER_BINARY --export "Linux/X11" -path "$DOCKER_GODOT_EXPORT_GAME/linux/${1}"

# echo "* Moving exported binaries to source directory:"
# mkdir -p "$SOURCE_PATH/bin"
# mv $DOCKER_GODOT_EXPORT_GAME/* "${DOCKER_GODOT_GAME_SOURCE}bin/"

echo "** Exporting game complete!"
echo "Game binaries in: ${DOCKER_GODOT_EXPORT_GAME}"