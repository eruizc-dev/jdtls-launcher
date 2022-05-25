#!/bin/bash

### CONFIGURABLE VARIABLES ###
INSTALL_ROOT=${1:-"$HOME/.local/opt"}
LINK_ROOT="$HOME/.local/bin"
TARBALL_LOCATION='/tmp/jdtls-launcher.tar.gz'
DOWNLOAD_URL='https://github.com/eruizc-dev/jdtls-launcher/archive/refs/heads/master.tar.gz'

### DERIVATED VARIABLES ###
INSTALL_LOCATION="$INSTALL_ROOT/jdtls-launcher"
LINK_LOCATION="$LINK_ROOT/jdtls"

### PREQUISITES ###
mkdir -p $INSTALL_ROOT
mkdir -p $LINK_ROOT

### CHECKS ###
if [ ! -d "$INSTALL_ROOT" ]; then
    echo "ERROR: could not create directory $INSTALL_ROOT" >> /dev/stderr
    exit 1
fi

if [ ! -w "$INSTALL_ROOT" ]; then
    echo "ERROR: not enough permissions to install to $INSTALL_ROOT" >> /dev/stderr
    exit 1
fi

if [ -d "$INSTALL_LOCATION" ]; then
    echo "ERROR: $INSTALL_LOCATION already exists, delete it manually and try again " >> /dev/stderr
    exit 1
fi

### DOWNLOAD JDTLS-LAUNCHER ###
echo 'INFO: Downloading JDTLS-LAUNCHER'
curl -L "$DOWNLOAD_URL" -f --output "$TARBALL_LOCATION" --progress-bar

echo 'INFO: Extracting JDTLS-LAUNCHER'
tar -xf "$TARBALL_LOCATION" --directory "$INSTALL_ROOT"
mv "$INSTALL_ROOT/jdtls-launcher-master" "$INSTALL_LOCATION"
chmod -R 755 "$INSTALL_LOCATION"

### CREATE LINK ###
echo "INFO: Creating symlink at ${LINK_LOCATION}"
rm "$LINK_LOCATION" 2> /dev/null
ln -s "$INSTALL_LOCATION/jdtls-launcher.sh" "$LINK_LOCATION"

### INSTALL JDTLS ###
$LINK_LOCATION --install

### NOTIFY SUCCESS ###
echo 'INFO: Installation successful'
echo "INFO: Ensure $LINK_ROOT is in path"
