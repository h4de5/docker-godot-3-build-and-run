#!/bin/bash

if [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
  echo "To download the latest godot export templates:"
  echo "  docker exec -d docker-godot-3-build-and-run /root/workspace/build-scripts/${0} [editor|templates|all]"
  echo "After the download is complete, save the current state:"
  echo "  docker commit <container-id> $DOCKER_TAG_NAME"
  exit 0
fi

if [ -z "$DOCKER_GODOT_VERSION" ]
then
	DOCKER_GODOT_VERSION=3.0.6
	DOCKER_GODOT_VERSION_SUFFIX=stable
fi

# version which are not stable are located in a subfolder - also they hold a subversion number which is 1 for now ..
if [ "${DOCKER_GODOT_VERSION_SUFFIX}" == "stable" ]; then
  GODOT_SUFFIX_TEMP="stable"
else
  GODOT_SUFFIX_TEMP="${DOCKER_GODOT_VERSION_SUFFIX}"
fi

if [ "$1" == "templates" ] || [ "$1" == "all" ]; then

	echo "Download godot templates v${DOCKER_GODOT_VERSION}.${DOCKER_GODOT_VERSION_SUFFIX} .."
    # creates version specific export template folder
    mkdir -p "${DOCKER_GODOT_EXPORT_TEMPLATES}${DOCKER_GODOT_VERSION}.${DOCKER_GODOT_VERSION_SUFFIX}/"
    cd "${DOCKER_GODOT_EXPORT_TEMPLATES}${DOCKER_GODOT_VERSION}.${DOCKER_GODOT_VERSION_SUFFIX}/"

    # download export templates
    if [ "${DOCKER_GODOT_VERSION_SUFFIX}" == "stable" ]; then
      # https://downloads.tuxfamily.org/godotengine/3.0.6/Godot_v3.0.6-stable_export_templates.tpz
      wget --quiet https://downloads.tuxfamily.org/godotengine/${DOCKER_GODOT_VERSION}/Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_export_templates.tpz
    else
      # https://downloads.tuxfamily.org/godotengine/3.1/alpha1/Godot_v3.1-alpha1_export_templates.tpz
      wget --quiet https://downloads.tuxfamily.org/godotengine/${DOCKER_GODOT_VERSION}/${GODOT_SUFFIX_TEMP}/Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_export_templates.tpz
    fi
    mv Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_export_templates.tpz Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_export_templates.zip
    unzip Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_export_templates.zip
    mv templates/* .

    # cleanup
    rmdir templates
    rm -f Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_export_templates.zip

    # I have no idea where to put the export templates, thats why i put them everywhere..
    # see: https://github.com/godotengine/godot/issues/18257
    # see: https://github.com/godotengine/godot/issues/16949
    # see: https://github.com/godotengine/godot/issues/19683
    # and: https://www.reddit.com/r/godot/comments/8u9dag/can_godot_server_export_games/
    # link to home directory
    mkdir -p ~/.godot
    rm -rf ~/.godot/templates
    ln -s ${DOCKER_GODOT_EXPORT_TEMPLATES} ~/.godot/templates

    # link to .local/share
    mkdir -p ~/.local/share/godot
    rm -rf ~/.local/share/godot/templates
    ln -s ${DOCKER_GODOT_EXPORT_TEMPLATES} ~/.local/share/godot/templates

    # create cache and config directories
    # see https://github.com/godotengine/godot/issues/16779
    mkdir -p ~/.config
    mkdir -p ~/.cache

fi

if [ "$1" == "editor" ] || [ "$1" == "all" ]; then

	echo "Download godot editor v${DOCKER_GODOT_VERSION}.${DOCKER_GODOT_VERSION_SUFFIX} .."

	mkdir -p "${DOCKER_GODOT_EDITOR}"
	cd "${DOCKER_GODOT_EDITOR}"

	if [ "${DOCKER_GODOT_VERSION_SUFFIX}" == "stable" ]; then
		wget --quiet https://downloads.tuxfamily.org/godotengine/${DOCKER_GODOT_VERSION}/Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_win64.exe.zip
	else
		wget --quiet https://downloads.tuxfamily.org/godotengine/${DOCKER_GODOT_VERSION}/${GODOT_SUFFIX_TEMP}/Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_win64.exe.zip
	fi
	unzip Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_win64.exe.zip
	rm -f Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_win64.exe.zip

	if [ "${DOCKER_GODOT_VERSION_SUFFIX}" == "stable" ]; then
		wget --quiet https://downloads.tuxfamily.org/godotengine/${DOCKER_GODOT_VERSION}/Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_x11.64.zip
	else
		wget --quiet https://downloads.tuxfamily.org/godotengine/${DOCKER_GODOT_VERSION}/${GODOT_SUFFIX_TEMP}/Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_x11.64.zip
	fi
	unzip Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_x11.64.zip
	rm -f Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_x11.64.zip

	if [ "${DOCKER_GODOT_VERSION_SUFFIX}" == "stable" ]; then
		wget --quiet https://downloads.tuxfamily.org/godotengine/${DOCKER_GODOT_VERSION}/Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_linux_server.64.zip
	else
		wget --quiet https://downloads.tuxfamily.org/godotengine/${DOCKER_GODOT_VERSION}/${GODOT_SUFFIX_TEMP}/Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_linux_server.64.zip
	fi
	unzip Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_linux_server.64.zip
	rm -f Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_linux_server.64.zip

	if [ "${DOCKER_GODOT_VERSION_SUFFIX}" == "stable" ]; then
		wget --quiet https://downloads.tuxfamily.org/godotengine/${DOCKER_GODOT_VERSION}/Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_linux_headless.64.zip
	else
		wget --quiet https://downloads.tuxfamily.org/godotengine/${DOCKER_GODOT_VERSION}/${GODOT_SUFFIX_TEMP}/Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_linux_headless.64.zip
	fi
	unzip Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_linux_headless.64.zip
	rm -f Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_linux_headless.64.zip

	# let server point to downloaded headless binary
	echo "Setting up linux_server link to ${DOCKER_GODOT_EDITOR}/Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_linux_server.64"
	rm -f linux_server
	ln -s Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_linux_server.64 linux_server

	echo "Setting up linux_headless link to ${DOCKER_GODOT_EDITOR}/Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_linux_headless.64"
	rm -f linux_headless
	ln -s Godot_v${DOCKER_GODOT_VERSION}-${GODOT_SUFFIX_TEMP}_linux_headless.64 linux_headless

fi

echo "** Download and unzip complete!"

echo "Export templates in: ${DOCKER_GODOT_EXPORT_TEMPLATES}"
echo "Editor in: ${DOCKER_GODOT_EDITOR}"
