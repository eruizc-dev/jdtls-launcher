#!/bin/bash

INSTALL_LOCATION='/usr/local/lib/jdtls-launcher'
LINK_LOCATION='/usr/local/bin/jdtls'
JDTLS_ROOT="$INSTALL_LOCATION/jdtls"
LOMBOK="$JDTLS_ROOT/plugins/lombok.jar"

function install_launcher {
    if [[ -d "$INSTALL_LOCATION" ]]; then
        echo "ERROR: Installation found at $INSTALL_LOCATION" >> /dev/stderr
    fi

    mkdir -p "$INSTALL_LOCATION"
    chmod 755 "$INSTALL_LOCATION"
    cp jdtls-launcher.sh "$INSTALL_LOCATION"
    chmod +x "$INSTALL_LOCATION/jdtls-launcher.sh"
    ln -s "$INSTALL_LOCATION/jdtls-launcher.sh" "$LINK_LOCATION"
}

function install_jdtls {
    EQUINOX_LAUNCHER=`find "$JDTLS_ROOT/plugins" -type f -name 'org.eclipse.equinox.launcher_*' 2> /dev/null`
    if [[ -f "EQUINOX_LAUNCHER" ]]; then
        echo "ERROR: JDTLS installation found at $JDTLS_ROOT" >> /dev/stderr
        exit 1
    fi

    LATEST=`curl -s http://download.eclipse.org/jdtls/snapshots/latest.txt`
    echo "INFO: About to install $LATEST to $JDTLS_ROOT"

    rm -rf "$JDTLS_ROOT"
    mkdir -p "$JDTLS_ROOT" || exit 1
    cd "$JDTLS_ROOT"

    curl "http://download.eclipse.org/jdtls/snapshots/$LATEST" > "$LATEST"
    tar -xf "$LATEST"
    rm "$LATEST"
    chmod -R 777 "$JDTLS_ROOT"

    # Installation check
    EQUINOX_LAUNCHER=`find "$JDTLS_ROOT/plugins" -type f -name 'org.eclipse.equinox.launcher_*' 2> /dev/null`
    if ! [[ -f "$EQUINOX_LAUNCHER" ]]; then
        echo 'ERROR: JDTLS installation failure' > /dev/stderr
        exit 1
    else
        echo 'INFO: JDTLS installation succesfull'
    fi
}

function install_lombok {
    if [[ -f "$LOMBOK" ]]; then
        echo "ERROR: Lombok installation found at $LOMBOK"> /dev/stderr
        exit 1
    fi

    echo "INFO: Installing Lombok to $LOMBOK"
    curl "https://projectlombok.org/downloads/lombok.jar" > "$LOMBOK"

    if ! [[ -f "$LOMBOK" ]]; then
        echo 'ERROR: Lombok installation failure' > /dev/stderr
        exit 1
    else
        echo 'INFO: Lombok installation succesfull'
    fi
}

function install {
    install_launcher
    install_jdtls
    install_lombok
}

function uninstall {
    rm -rf "$INSTALL_LOCATION"
    rm -f '/usr/local/bin/jdtls'
}

if  [ "$EUID" -ne 0 ]; then
    echo 'ERROR: Command must be run as root to complete installation' >> /dev/stderr
    exit 1
fi

if [[ -d "$INSTALL_LOCATION" ]]; then
    read -p 'WARNING: Installation found, reinstall? y/[N]: ' CHOICE
    case "$CHOICE" in
        y|Y )
            uninstall
            install
            ;;
        * ) 
            echo 'INFO: Installation aborted by user'
            exit 0
    esac 
else
    install
fi

echo 'INFO: Process finished'
