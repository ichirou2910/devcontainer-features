#!/bin/bash

set -e

echo "Activating feature 'nnn'"

VERSION="${VERSION:-4.9}"
echo "The version to be installed is: $VERSION"

install_dependencies() {
	apt-get update -y
	apt-get install -y pkg-config libncursesw5-dev libreadline-dev

	apt-get -y clean
	rm -rf /var/lib/apt/lists/*
}

# ******************
# ** Main section **
# ******************

if [ "$(id -u)" -ne 0 ]; then
	echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
	exit 1
fi

ORIGINAL_VERSION=$VERSION
ADJUSTED_VERSION=v$VERSION

# Bring in ID, ID_LIKE, VERSION_ID, VERSION_CODENAME
. /etc/os-release
# Get an adjusted ID independent of distro variants
if [ "${ID}" = "debian" ] || [ "${ID_LIKE}" = "debian" ]; then
	ADJUSTED_ID="debian"
	# other distros to be implemented
	# elif [[ "${ID}" = "rhel" || "${ID}" = "fedora" || "${ID}" = "mariner" || "${ID_LIKE}" = *"rhel"* || "${ID_LIKE}" = *"fedora"* || "${ID_LIKE}" = *"mariner"* ]]; then
	# todo
	# elif [ "${ID}" = "alpine" ]; then
	# todo
else
	echo "Linux distro ${ID} not supported."
	exit 1
fi

# Install packages for appropriate OS
case "${ADJUSTED_ID}" in
"debian")
	install_dependencies
	;;
esac

echo "Downloading source for version $ADJUSTED_VERSION"

curl -sL "https://github.com/jarun/nnn/archive/refs/tags/$ADJUSTED_VERSION.tar.gz" | tar -xzC /tmp 2>&1

echo "Building"

cd "/tmp/nnn-$ORIGINAL_VERSION"

make $BUILD_ARGS && make strip install

echo "Cleaning up"

rm -rf "/tmp/nnn-$ORIGINAL_VERSION"
