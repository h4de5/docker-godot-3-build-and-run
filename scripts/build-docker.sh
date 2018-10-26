#!/bin/bash

if [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
  echo "Builds a docker built image file according to settings in dockerfile"
  echo "	$0 [--build-arg serverport=8910]"
  exit 0
fi

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPTPATH=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
PROJECTPATH=$(dirname "$SCRIPTPATH")

docker build -t h4de5/docker-godot-3-build-and-run:latest $PROJECTPATH $@
