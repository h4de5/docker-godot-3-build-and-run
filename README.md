# docker-godot-3-build-and-run

**This is work in progress!**

**UPDATE: 2018-02-27 - I just found out, that it is not possible to export a game using the headless server plattform due to the lack of a GPU or any GPU access on such a server. That's why i decided to postpone any further developement of this docker image until this is made available. This docker image can still be used to build and run the headless server - as well as, with small modifications of the build-godot.sh file, build the godot editor from the latest source for windows and linux.**

Also this is my first steps in docker - feel free to submit changes :) 

Use this docker image script to create a working build environment for **Godot v3**

At the moment it is possible to:
- compile godot v3 from source
-- for platforms: headless linux server, X11, windows, javascript
- export your godot game for those plattforms **NOPE**
- run your game from headless godot server within the docker container

What is not possible right now:
- export to Android
- immediately understand how it works by reading this help file

What will never be possible:
- compile to OSX
- export to any other Apple thing
- actually understand how it works by repeatingly reading this help file


## Docker basis

Docker image is based on ubuntu:bionic. It installs all packets used for [building and exporting godot binaries](http://docs.godotengine.org/en/3.0/development/compiling/compiling_for_x11.html). 

## Godot basis

The Image will clone the [godot source](https://github.com/godotengine/godot) and will initially download the [export templates](https://godotengine.org/download/windows).

## Install and Usage

There are several shell scripts available. 

Run from outside:
- `build-docker.sh	[--build-arg serverport=8910]` .. starting point for creating the docker image.
- `run-docker.sh [portnumber]` .. run your created docker image and create a container.

Runs during build process:
- `download-godot-templates.sh` .. downloads latest godot export templates
- `install-emscripten.sh` .. installs and setup emscrip in the docker image

Run on active container (docker run ..):
- `build-godot-editor.sh [all|server|linux|windows]` .. builds the godot editor binary - _is also called during docker build process (takes a looong time)_.
- `build-godot-templates.sh [all|javascript|linux|windows]` .. builds the godot export templates
- `export-game.sh <game-name>` .. exports binaries for your mounted godot game directory
- `run-game.sh <path-to-server-scene.tscn>` .. runs a scene on the headless server within your game directory

## Docker Lifecycle und Cheatsheet (cause I still need this)

*Dockerfile* > build > *Image* > run > *Container*

- `docker ps` .. lists running containers
- `docker build --tag <image>` .. builds an image from dockerfile
- `docker run -d <image>` .. runs container in background
- `docker run -it <image> bash` .. runs interactive container
- `docker run -rm <image> bash` .. removes container on stop
- `docker run -name <container> <image>` .. starts a named container
- `docker stop <container>` .. stops a named container
- `docker start <container>` .. restarts a named container
- `docker exec -it <container> bash` .. connect to a container

## Examples
Run command to temporary build container and run your godot game within a headless server:

> docker run --rm -it -p 8910 -v `pwd`:/root/workspace/game/ h4de5/docker-godot-3-build-and-run:latest /root/workspace/build-scripts/build-run-game.sh <path-to-server-scene.tscn>

Run command to temporary build container and export your game to windows/linux/javascript - binaries will be placed in /bin/ directory:

> docker run --rm -it -v `pwd`:/root/workspace/game/ h4de5/docker-godot-3-build-and-run:latest /root/workspace/build-scripts/export-game.sh <name-your-game>

If you want to have a permanent container file:

> docker run -it -v `pwd`:/root/workspace/game/ h4de5/docker-godot-3-build-and-run:latest bash

Reconnect to an permanent container file

> docker exec -it docker-godot-3-build-and-run-perm bash

For more information please see help (-h) for each script. 

