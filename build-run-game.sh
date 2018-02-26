#!/bin/bash

if [ "$#" == 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
  echo "To run your godot game as a headless server, go to your source directory and run:"
  echo "  docker run --rm -it -p <port:port> -v \`pwd\`:/root/workspace/game/ h4de5/docker-godot-3-build-and-run:latest /root/workspace/build-scripts/${0} <path-to-server.tscn>"
  exit 0
fi

cd $DOCKER_GODOT_GAME_SOURCE
$DOCKER_GODOT_SERVER_BINARY $1