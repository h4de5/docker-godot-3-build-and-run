#!/bin/bash

if [ "$#" == 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
  echo "Creates a container from the built image file - or runs docker image."
  echo "	$0 <forwarded-port>"
  exit 0
fi

docker run -ti -v `pwd`:/root/workspace/game/ -p $1:$1 -h godot-build-server --name docker-godot-3-build-and-run h4de5/docker-godot-3-build-and-run:latest /bin/bash
