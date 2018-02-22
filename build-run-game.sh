#!/bin/bash

if [ "$#" == 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
  echo "To run your godot game as a headless server, go to your source directory and run:"
  echo "  docker run --rm -it -v `pwd`:$DOCKER_GODOT_GAME_SOURCE $DOCKER_TAG_NAME $DOCKER_BUILD_SCRIPT/${0} <path-to-server.tscn>"
  exit 0
fi

$DOCKER_GODOT_SERVER_BINARY $1