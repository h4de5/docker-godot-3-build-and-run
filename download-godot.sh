#!/bin/bash

if [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
  echo "To download the latest godot export templates:"
  echo "  docker exec -d h4de5/docker-godot-3-build-and-run:latest /root/workspace/build-scripts/${0} [editor|templates|all]"
  echo "After the download is complete, save the current state:"
  echo "  docker commit <container-id> $DOCKER_TAG_NAME"
  exit 0
fi

if [ "$1" == "templates" ] || [ "$1" == "all" ]; then

    # creates version specific export template folder
    mkdir -p "${DOCKER_GODOT_EXPORT_TEMPLATES}${DOCKER_GODOT_VERSION}.stable/"

    cd "${DOCKER_GODOT_EXPORT_TEMPLATES}${DOCKER_GODOT_VERSION}.stable/"

    # download export templates
    wget --quiet https://downloads.tuxfamily.org/godotengine/${DOCKER_GODOT_VERSION}/Godot_v${DOCKER_GODOT_VERSION}-stable_export_templates.tpz
    mv Godot_v${DOCKER_GODOT_VERSION}-stable_export_templates.tpz Godot_v${DOCKER_GODOT_VERSION}-stable_export_templates.zip
    unzip Godot_v${DOCKER_GODOT_VERSION}-stable_export_templates.zip
    mv templates/* .

    # cleanup
    rmdir templates
    rm -f Godot_v${DOCKER_GODOT_VERSION}-stable_export_templates.zip

    # link to home directory
    mkdir -p ~/.godot
    ln -s ~/workspace/godot/templates ~/.godot/templates

    # create cache and config directories
    # see https://github.com/godotengine/godot/issues/16779
    mkdir -p ~/.local/share
    mkdir -p ~/.config
    mkdir -p ~/.cache

fi

if [ "$1" == "editor" ] || [ "$1" == "all" ]; then
  mkdir -p "$DOCKER_GODOT_EDITOR"
  cd "$DOCKER_GODOT_EDITOR"

  wget --quiet https://downloads.tuxfamily.org/godotengine/${DOCKER_GODOT_VERSION}/Godot_v${DOCKER_GODOT_VERSION}-stable_win64.exe.zip
  unzip Godot_v${DOCKER_GODOT_VERSION}-stable_win64.exe.zip
  rm -f Godot_v${DOCKER_GODOT_VERSION}-stable_win64.exe.zip

  wget --quiet https://downloads.tuxfamily.org/godotengine/${DOCKER_GODOT_VERSION}/Godot_v${DOCKER_GODOT_VERSION}-stable_x11.64.zip
  unzip Godot_v${DOCKER_GODOT_VERSION}-stable_x11.exe.zip
  rm -f Godot_v${DOCKER_GODOT_VERSION}-stable_x11.exe.zip

  wget --quiet https://downloads.tuxfamily.org/godotengine/${DOCKER_GODOT_VERSION}/Godot_v${DOCKER_GODOT_VERSION}-stable_linux_server.64.zip
  unzip Godot_v${DOCKER_GODOT_VERSION}-stable_linux_server.exe.zip
  rm -f Godot_v${DOCKER_GODOT_VERSION}-stable_linux_server.exe.zip

  # let server point to download binary
  rm -f $DOCKER_GODOT_EDITOR/linux_server
  ln -s $DOCKER_GODOT_EDITOR/Godot_v3.0.4-stable_linux_server.64 linux_server

fi

echo "** Download and unzip complete!"

echo "Export templates in: $DOCKER_GODOT_EXPORT_TEMPLATES"
echo "Editor in: $DOCKER_GODOT_EDITOR"