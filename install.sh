#!/bin/bash

### GATHER INSTALL INFORMATION ###
if  [ "$EUID" -ne 0 ]; then
    echo 'INFO: Performing user level installation'
    INSTALL_LOCATION=${1:-"$HOME/.local/lib/jdtls-launcher"}
    LINK_LOCATION="$HOME/.local/bin/jdtls"
else
    echo 'INFO: Performing system level installation'
    INSTALL_LOCATION=${1:-'/usr/local/lib/jdtls-launcher'}
    LINK_LOCATION='/usr/local/bin/jdtls'
fi
INSTALL_ROOT=${INSTALL_LOCATION%/*}
TARBALL_LOCATION='/tmp/jdtls-launcher.tar.gz'
DOWNLOAD_URL=`curl -s https://api.github.com/repos/eruizc-dev/jdtls-launcher/releases/latest | grep 'tarball_url' | egrep -o 'https://[^"]+'`

### CHECK PERMISSIONS ###
if [ ! -d "$INSTALL_ROOT" ]; then
    echo "ERROR: $INSTALL_ROOT not a directory" >> /dev/stderr
    exit 1
fi

if [ ! -w "$INSTALL_ROOT" ]; then
    echo "ERROR: not enough permissions to install to $INSTALL_ROOT" >> /dev/stderr
    exit 1
fi

### CHECK EXISTING INSTALLATION ###
if [ -d "$INSTALL_LOCATION" ]; then
    echo "ERROR: $INSTALL_LOCATION already exists, delete it manually and try again " >> /dev/stderr
    exit 1
fi

### DOWNLOAD JDTLS-LAUNCHER ###
echo 'INFO: Downloading JDTLS-LAUNCHER'
curl -fLo "$TARBALL_LOCATION" "$DOWNLOAD_URL" 

echo 'INFO: Extracting JDTLS-LAUNCHER'
tar -xf "$TARBALL_LOCATION" --directory "$INSTALL_ROOT"
mv "$INSTALL_ROOT"/eruizc-dev-jdtls-launcher* "$INSTALL_LOCATION"
chmod -R 755 "$INSTALL_LOCATION"

### CREATE LINK ###
echo "INFO: Creating symlink ${LINK_LOCATION}"
rm "$LINK_LOCATION" 2> /dev/null
ln -s "$INSTALL_LOCATION/jdtls-launcher.sh" "$LINK_LOCATION"

### INSTALL JDTLS ###
jdtls --install

