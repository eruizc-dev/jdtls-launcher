#!/bin/bash

### GATHER SYSTEM INFORMATION ###
SYSTEM=`uname -s`
if [ "$SYSTEM" == 'Darwin' ]; then
    if  [ "$EUID" -eq 0 ]; then
        echo 'ERROR: sudo is not necessary for a MACOS installation' >> /dev/stderr
        exit 1
    fi
    echo 'INFO: Performing system level installation'
elif [ "$SYSTEM" == 'Linux' ]; then
    if  [ "$EUID" -eq 0 ]; then
        echo 'INFO: Performing system level installation'
    else
        echo 'INFO: Performing user level installation'
    fi
else
    echo "ERROR: $SYSTEM not supported" >> /dev/stderr
    exit 1
fi

INSTALL_LOCATION=${1:-'/usr/local/lib'}'/jdtls-launcher'
LINK_LOCATION='/usr/local/bin/jdtls'

INSTALL_ROOT=${INSTALL_LOCATION%/*}
TARBALL_LOCATION='/tmp/jdtls-launcher.tar.gz'
DOWNLOAD_URL=`curl -s 'https://api.github.com/repos/eruizc-dev/jdtls-launcher/releases/latest' | grep 'tarball_url' | egrep -o 'https://[^"]+'`

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
if [ "$INSTALL_LOCATION" == '/usr/local/lib/jdtls-launcher' ]; then
    echo "INFO: Creating symlink ${LINK_LOCATION}"
    rm "$LINK_LOCATION" 2> /dev/null
    ln -s "$INSTALL_LOCATION/jdtls-launcher.sh" "$LINK_LOCATION"
fi

### INSTALL JDTLS ###
jdtls --install

