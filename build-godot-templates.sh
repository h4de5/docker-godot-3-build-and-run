#!/bin/bash

if [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
  echo "To compile the godot export templates from current master: "
  echo "  docker exec -d h4de5/docker-godot-3-build-and-run:latest /root/workspace/build-scripts/${0}" [windows|linux|javascript|all]
  echo "use with parameter 'all' to compile export templates for X11, windows and javascript"
  exit 0
fi

# see: http://docs.godotengine.org/en/3.0/development/compiling/batch_building_templates.html

# different javascript export way
# RUN LLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly

cd $DOCKER_GODOT_SOURCE

# remove any local changes
# git stash

# get latest changes
git pull

# rm -rf templates/*
mkdir -p $DOCKER_GODOT_EXPORT_TEMPLATES

# find out number of cores in this machine
CORE_COUNT="$(nproc)"

# Cross-compiling from some versions of Ubuntu may lead to this bug, due to a default configuration lacking support for POSIX threading.
# https://github.com/godotengine/godot/issues/9258
# echo 1 | update-alternatives --config x86_64-w64-mingw32-gcc
# echo 1 | update-alternatives --config x86_64-w64-mingw32-g++
update-alternatives --set x86_64-w64-mingw32-gcc /usr/bin/x86_64-w64-mingw32-gcc-posix
update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix

# for a list of how the export templates are named see:
#	http://docs.godotengine.org/en/stable/development/compiling/introduction_to_the_buildsystem.html#export-templates

if [ "$1" == "linux" ] || [ "$1" == "all" ]; then
	
	echo "* Building godot for Linux X11"
	scons -j $CORE_COUNT p=x11 target=release tools=no bits=64
	upx bin/godot.x11.opt.64
	mv bin/godot.x11.opt.64 $DOCKER_GODOT_EXPORT_TEMPLATES/linux_x11_64_release
	
	scons -j $CORE_COUNT p=x11 target=release_debug tools=no bits=64
	upx bin/godot.x11.opt.debug.64
	mv bin/godot.x11.opt.debug.64 $DOCKER_GODOT_EXPORT_TEMPLATES/linux_x11_64_debug
  
fi
if [ "$1" == "windows" ] || [ "$1" == "all" ]; then

	echo "* Building godot for Windows"
	scons -j $CORE_COUNT p=windows target=release tools=no bits=64
	x86_64-w64-mingw32-strip bin/godot.windows.opt.64.exe
	mv bin/godot.windows.opt.64.exe $DOCKER_GODOT_EXPORT_TEMPLATES/windows_64_release.exe

	scons -j $CORE_COUNT p=windows target=release_debug tools=no bits=64
	x86_64-w64-mingw32-strip bin/godot.windows.opt.debug.64.exe
	mv bin/godot.windows.opt.debug.64.exe $DOCKER_GODOT_EXPORT_TEMPLATES/windows_64_debug.exe
  
fi
if [ "$1" == "javascript" ] || [ "$1" == "all" ]; then

	echo "* Building godot for Javascript"
	scons -j $CORE_COUNT p=javascript target=release
	mv bin/godot.javascript.opt.zip $DOCKER_GODOT_EXPORT_TEMPLATES/webassembly_release.zip

	scons -j $CORE_COUNT p=javascript target=release_debug
	mv bin/godot.javascript.opt.debug.zip $DOCKER_GODOT_EXPORT_TEMPLATES/webassembly_debug.zip

fi

echo "** Building complete!"
echo "Export templates in: $DOCKER_GODOT_EXPORT_TEMPLATES"
