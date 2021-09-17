#!/bin/bash

function realpath {
    ls -la "$1" | grep jdtls | awk '{ print $11 }'
}

SYSTEM=`uname -s`

SCRIPT_VERSION='v1.1.3'
SCRIPT_ROOT=`dirname $(realpath "$0")`

JDTLS_ROOT="$SCRIPT_ROOT/jdtls"
JDTLS_WORKSPACE="$HOME/.cache/jdtls-workspace"
JDTLS_CORE=`find "$JDTLS_ROOT/plugins" -type f -name 'org.eclipse.jdt.ls.core_*' 2> /dev/null`
JDTLS_EQUINOX_LAUNCHER=`find "$JDTLS_ROOT/plugins" -type f -name 'org.eclipse.equinox.launcher_*' 2> /dev/null`
JDTLS_BACKUP_ROOT="$SCRIPT_ROOT/jdtls-old"

LOMBOK="$JDTLS_ROOT/plugins/lombok.jar"

### UTILS ###
function get_jar_version {
    echo $(basename "$1" | awk '{ gsub(/^[^-_]*[-_]?|\.jar$/, ""); print }' | awk '{ gsub(/^$/, "custom"); print }')
}

### ACTIONS ###
function print_version {
    echo "jdtls-launcher $SCRIPT_VERSION"
    echo "equinox-launcher $(get_jar_version "$JDTLS_EQUINOX_LAUNCHER")"
    echo "jdtls-core $(get_jar_version "$JDTLS_CORE")"
    echo "lombok $(get_jar_version "$LOMBOK")"
    java --version
}

function print_help {
    echo 'jdtls-launcher: install and launch jdtls with a single command'
    echo 'available options:'
    echo '  -v | --version      prints version of all components'
    echo '  -h | --help         prints this menu'
    echo '  -i | --install      install jdtls if not installed'
    echo '  --uninstall         uninstall jdtls if installed'
    echo '  --update            uninstall and install jdtls creating a backup and restoring in case of failure'
    echo '  --backup            creates a backup of the current jdtls installation'
    echo '  --restore           restores the jdtls backup'
}

function install_lombok {
    echo 'Installing lombok...'
    if [ ! -w "$SCRIPT_ROOT" ]; then
        echo "Permission denied, don't you need sudo?" >> /dev/stderr
        return 1
    fi
    if [ -f "$LOMBOK" ]; then
        echo "Lombok installation found at $LOMBOK, aborting installation" >> /dev/stderr
        return 0
    fi

    curl "https://projectlombok.org/downloads/lombok.jar" > "$LOMBOK"

    if [ ! -f "$LOMBOK" ]; then
        echo ' Lombok installation failure' > /dev/stderr
        return 1
    fi
    echo 'Lombok installation succesfull'
    return 0
}

function jdtls_install {
    echo 'Installing jdtls...'
    if [ ! -w "$SCRIPT_ROOT" ]; then
        echo "Permission denied, don't you need sudo?" >> /dev/stderr
        return 1
    fi
    if [ -d "$JDTLS_ROOT" ]; then
        echo "Jdtls installation found at $JDTLS_ROOT, aborting installation" >> /dev/stderr
        return 1
    fi

    LATEST=`curl -Ls 'http://download.eclipse.org/jdtls/snapshots/latest.txt'`
    echo "${LATEST%.tar.gz} is going to be installed"

    mkdir -p "$JDTLS_ROOT"
    cd "$JDTLS_ROOT"

    curl -L "http://download.eclipse.org/jdtls/snapshots/$LATEST" > "$LATEST"
    tar -xf "$LATEST"
    rm "$LATEST"
    chmod -R 755 "$JDTLS_ROOT"
    chmod -R 777 "$JDTLS_ROOT"/config_*

    EQUINOX_LAUNCHER=`find "$JDTLS_ROOT/plugins" -type f -name 'org.eclipse.equinox.launcher_*' 2> /dev/null`
    if ! [[ -f "$EQUINOX_LAUNCHER" ]]; then
        echo 'JDTLS installation failure' >> /dev/stderr
        return 1
    fi

    install_lombok

    echo 'JDTLS installation succesfull'
    return 0
}

function jdtls_uninstall {
    echo 'Uninstalling jdtls...'
    if [ ! -w "$SCRIPT_ROOT" ]; then
        echo "Permission denied, don't you need sudo?" >> /dev/stderr
        return 1
    fi
    rm -rf "$JDTLS_ROOT"
    echo 'JDTLS uninstalled'
    return 0
}

function jdtls_reinstall {
    if [ ! -w "$SCRIPT_ROOT" ]; then
        echo "Permission denied, don't you need sudo?" >> /dev/stderr
        return 1
    fi
    jdtls_create_backup && (jdtls_uninstall && jdtls_install || jdtls_restore_backup)
}

function jdtls_create_backup {
    echo 'Creating jdtls backup...'
    if [ ! -w "$SCRIPT_ROOT" ]; then
        echo "Permission denied, don't you need sudo?" >> /dev/stderr
        return 1
    fi
    if [ ! -d "$JDTLS_ROOT" ]; then
        echo 'Cannot create backup, jdtls installation does not exist' >> /dev/stderr
        return 1
    fi
    rm -rf "$JDTLS_BACKUP_ROOT"
    cp -r "$JDTLS_ROOT" "$JDTLS_BACKUP_ROOT"
    echo 'Backup created'
    return 0
}

function jdtls_restore_backup {
    echo 'Restoring jdtls backup...'
    if [ ! -w "$SCRIPT_ROOT" ]; then
        echo "Permission denied, don't you need sudo?" >> /dev/stderr
        return 1
    fi
    if [ ! -d "$JDTLS_BACKUP_ROOT" ]; then
        echo 'Cannot restore backup, backup does not exist' >> /dev/stderr
        return 1
    fi
    rm -rf "$JDTLS_ROOT"
    mv "$JDTLS_BACKUP_ROOT" "$JDTLS_ROOT"
    echo 'Backup restored'
    return 0
}

function run {
    if [ ! -d "$JDTLS_ROOT" ]; then
        echo 'Jdtls installation not found' >> /dev/stderr
        return 1
    fi

    case "$SYSTEM" in
        [Ll]inux) # Linux and WSL
            CONFIG="$JDTLS_ROOT/config_linux"
            ;;
        [Dd]arwin) # MacOS
            CONFIG="$JDTLS_ROOT/config_mac"
            ;;
        *)
            echo "ERROR: Unknown or unsupported system $SYSTEM" >> /dev/stderr
            echo "Consider opening a new issue: https://github.com/eruizc-dev/jdtls-launcher/issues/new?title=Unsupported%20system%20$SYSTEM" >> /dev/stderr
            return 1
            ;;
    esac

    java \
        -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=1044 \
        -Declipse.application=org.eclipse.jdt.ls.core.id1 \
        -Dosgi.bundles.defaultStartLevel=4 \
        -Declipse.product=org.eclipse.jdt.ls.core.product \
        -Dlog.level=ALL \
        -noverify \
        -Xmx1G \
        -javaagent:"$LOMBOK" \
        -jar "$JDTLS_EQUINOX_LAUNCHER" \
        -configuration "$CONFIG" \
        -data "$JDTLS_WORKSPACE" \
        --add-modules=ALL-SYSTEM \
        --add-opens java.base/java.util=ALL-UNNAMED \
        --add-opens java.base/java.lang=ALL-UNNAMED
}

### PARAM PARSING ###
case "$1" in
    -v|--version)
        print_version
        exit 0
        ;;
    -h|--help)
        print_help
        exit 0
        ;;
    --backup)
        jdtls_create_backup
        exit
        ;;
    --restore)
        jdtls_restore_backup
        exit
        ;;
    -i|--install)
        jdtls_install
        exit
        ;;
    --uninstall)
        jdtls_uninstall
        exit
        ;;
    --update)
        jdtls_reinstall
        exit
        ;;
    "")
        run
        exit
        ;;
    *)
        echo "unknown option $1"
        print_help
        exit 1
        ;;
esac
