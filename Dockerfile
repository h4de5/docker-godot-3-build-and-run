# FROM ubuntu:bionic
FROM debian:stable-slim AS build-image

LABEL maintainer="h4de5@users.noreply.github.com" \
  version="3.0.6" \
  description="Docker image for a basic build environment"

# fetch updates and packetlist
# install build environment and additionals
# skip upgrade and autoremove for now
RUN apt-get --yes update && \
  # apt-get --yes upgrade && \
  # apt-get --yes autoremove && \
  apt-get --yes install \
    build-essential scons pkg-config libx11-dev libxcursor-dev libxinerama-dev \
	  libgl1-mesa-dev libglu-dev libasound2-dev libpulse-dev libfreetype6-dev libssl-dev libudev-dev \
	  libxi-dev libxrandr-dev mingw-w64 \
	  git unzip upx vim wget ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# run shell
ENTRYPOINT ["/bin/bash"]

#######################################
FROM build-image as godot-image

LABEL maintainer="h4de5@users.noreply.github.com" \
  version="3.0.6" \
  description="Docker image that sets up emscripten and the docker github repository on top of the build-image."

# setting up build environment
ENV DOCKER_WORKING_DIR="/root/workspace/" \
  DOCKER_BUILD_SCRIPT="/root/workspace/build-scripts/" \
  DOCKER_GODOT_SOURCE="/root/workspace/godot/" \
  DOCKER_GODOT_EMSCRIPTEN="/root/workspace/emscripten/" \
  EMSCRIPTEN_ROOT="/root/workspace/emscripten/"

# create some directories for later use
RUN mkdir -p "$DOCKER_WORKING_DIR" \
    "$DOCKER_BUILD_SCRIPT" \
    "$DOCKER_GODOT_EMSCRIPTEN"

WORKDIR $DOCKER_WORKING_DIR

# copy our build scripts into the directory
COPY scripts/*.sh $DOCKER_BUILD_SCRIPT

# make scripts executable
# get godot source
# download stable export templates
# install emscripten
RUN chmod +x ${DOCKER_BUILD_SCRIPT}*.sh && \
  git clone -b master --single-branch https://github.com/godotengine/godot.git $DOCKER_GODOT_SOURCE && \
  ${DOCKER_BUILD_SCRIPT}install-emscripten.sh

# run shell
ENTRYPOINT ["/bin/bash"]

#######################################
FROM godot-image as godot-game-image

LABEL maintainer="h4de5@users.noreply.github.com" \
  version="3.0.6" \
  description="Docker image to build a godot v3.0.6 from source, export your game as binary and run your game on a linux server."

# which will be exposed
EXPOSE 8910

ARG godot_version="${DOCKER_GODOT_VERSION}"
ARG godot_suffix="${DOCKER_GODOT_VERSION_SUFFIX}"

# game sources should be linked here
VOLUME /root/workspace/game/

# editor builds will be placed here
VOLUME /root/workspace/editor/

# game exports will be placed here
VOLUME /root/workspace/exports/

# godot export templates will be placed here
VOLUME /root/workspace/templates/

# setting up build environment
ENV DOCKER_GODOT_VERSION=$godot_version \
  DOCKER_GODOT_VERSION_SUFFIX=$godot_suffix \
  DOCKER_GODOT_EXPORT_TEMPLATES="/root/workspace/templates/" \
  DOCKER_GODOT_EDITOR="/root/workspace/editor/" \
  DOCKER_GODOT_GAME_SOURCE="/root/workspace/game/" \
  DOCKER_GODOT_EXPORT_GAME="/root/workspace/exports/" \
  DOCKER_GODOT_SERVER_BINARY="/root/workspace/editor/linux_server" \
  DOCKER_GODOT_HEADLESS_BINARY="/root/workspace/editor/linux_headless" \
  DOCKER_TAG_NAME="docker-godot-3-build-and-run:latest" \
  GODOT_HOME="${HOME}/.godot/" \
  XDG_CACHE_HOME="${HOME}/.cache/" \
  XDG_DATA_HOME="${HOME}/.local/share/" \
  XDG_CONFIG_HOME="${HOME}/.config/" \
  GAME_PORT=8910

# ENV DOCKER_WORKING_DIR="/root/workspace/" \
#   DOCKER_BUILD_SCRIPT="/root/workspace/build-scripts/" \
#   DOCKER_GODOT_SOURCE="/root/workspace/godot/" \
#   DOCKER_GODOT_VERSION=$godot_version \
#   DOCKER_GODOT_VERSION_SUFFIX=$godot_suffix \
#   DOCKER_GODOT_EXPORT_TEMPLATES="/root/workspace/templates/" \
#   DOCKER_GODOT_EDITOR="/root/workspace/editor/" \
#   DOCKER_GODOT_GAME_SOURCE="/root/workspace/game/" \
#   DOCKER_GODOT_EXPORT_GAME="/root/workspace/exports/" \
#   DOCKER_GODOT_EMSCRIPTEN="/root/workspace/emscripten/" \
#   DOCKER_GODOT_SERVER_BINARY="/root/workspace/editor/linux_headless" \
#   DOCKER_TAG_NAME="docker-godot-3-build-and-run:latest" \
#   EMSCRIPTEN_ROOT="/root/workspace/emscripten/" \
#   GODOT_HOME="~/.godot/" \
#   XDG_CACHE_HOME="~/.cache/" \
#   XDG_DATA_HOME="~/.local/share/" \
#   XDG_CONFIG_HOME="~/.config/" \
#   GAME_PORT=8910

# create some directories for later use
RUN mkdir -p "$DOCKER_GODOT_EDITOR" \
    "$DOCKER_GODOT_GAME_SOURCE" \
    "$DOCKER_GODOT_EXPORT_GAME" \
    "$GODOT_HOME" \
    "$XDG_CACHE_HOME" \
    "$XDG_DATA_HOME" \
    "$XDG_CONFIG_HOME"

# RUN mkdir -p "$DOCKER_WORKING_DIR" \
#     "$DOCKER_BUILD_SCRIPT" \
#     "$DOCKER_GODOT_EDITOR" \
#     "$DOCKER_GODOT_GAME_SOURCE" \
#     "$DOCKER_GODOT_EXPORT_GAME" \
#     "$DOCKER_GODOT_EMSCRIPTEN" \
#     "$GODOT_HOME" \
#     "$XDG_CACHE_HOME" \
#     "$XDG_DATA_HOME" \
#     "$XDG_CONFIG_HOME"

WORKDIR $DOCKER_WORKING_DIR

# copy our build scripts into the directory
COPY scripts/*.sh $DOCKER_BUILD_SCRIPT

# make scripts executable
# get godot source
# download stable export templates
# install emscripten
RUN chmod +x ${DOCKER_BUILD_SCRIPT}*.sh && \
  ${DOCKER_BUILD_SCRIPT}download-godot.sh all

# run shell
ENTRYPOINT ["/bin/bash"]

# run godot build
# CMD ["/root/workspace/build-scripts/build-godot.sh"]
