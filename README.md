# docker-godot-3-build-and-run

**This is work in progress!**
Also this is my first steps in docker - feel free to submit changes :) 

Use this docker image script to create a working build environment for **Godot v3**

At the moment it is possible to:
- compile godot v3 from source
-- for platforms: headless linux server, X11, windows, javascript
- export your godot game for those plattforms
- run your game from headless godot server within the docker container

What is not possible right now:
- export to Android
- immediately understand how it works by repeatingly reading this help file

What will never be possible:
- compile to OSX
- export to any other Apple thing
- immediately understand how it works by repeatingly reading this help file


## Docker basis

Docker image is based on ubuntu:latest. It installs all packets used for [building and exporting godot binaries](http://docs.godotengine.org/en/3.0/development/compiling/compiling_for_x11.html). 

## Godot basis

The Image will clone the [godot source](https://github.com/godotengine/godot) and will initially download the [export templates](https://godotengine.org/download/windows).

## Install and Usage

There are several shell scripts available. 

- build-docker.sh	[--build-arg serverport=8910] .. starting point for creating the docker image.
- build-run-docker.sh [portnumber] .. run your created docker image and create a container.
- build-download-stable.sh .. downloads latest godot export templates - _is called during build process_.
- build-emscripten.sh .. installs and setup emscrip in the docker image - _is called during build process_.
- build-godot.sh [all] .. builds the godot headless server binary - _is called during build process (takes a looong time)_.
- build-game.sh <game-name> .. builds binaries for your mounted godot game directory - _can be executed on running docker container_.
- build-run-game.sh <path-to-server.tscn> .. builds binaries for your mounted godot game directory - _can be executed on running docker container_.

For more information please see help (-h) for each script. 

