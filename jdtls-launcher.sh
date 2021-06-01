#!/bin/bash

### SCRIPT INFO ###
SCRIPT_VERSION='v1.1.0-alpha'

JDTLS_ROOT="/usr/local/lib/jdtls-launcher/jdtls"
EQUINOX_LAUNCHER=`find "$JDTLS_ROOT/plugins" -type f -name 'org.eclipse.equinox.launcher_*'`
JDTLS_CORE=`find "$JDTLS_ROOT/plugins" -type f -name 'org.eclipse.jdt.ls.core_*'`
LOMBOK="$JDTLS_ROOT/plugins/lombok.jar"
WORKSPACE="$HOME/workspace"

### UTILS ###
function get_version {
    echo $(basename "$1" | awk '{ gsub(/^[^-_]*[-_]?|\.jar$/, ""); print }' | awk '{ gsub(/^$/, "custom"); print }')
}

### ACTIONS ###
function print_version {
    echo "jdtls-launcher $SCRIPT_VERSION"
    echo "equinox-launcher $(get_version "$EQUINOX_LAUNCHER")"
    echo "jdtls-core $(get_version "$JDTLS_CORE")"
    echo "lombok $(get_version "$LOMBOK")"
    java --version
}

function print_help {
    echo 'jdtls-launcher: install and launch jdtls with a single command'
    echo 'available options:'
    echo '  -v | --version      prints version of all components'
    echo '  -h | --help         prints this menu'
}

case "$1" in
    -v|--version)
        print_version
        exit 0
        ;;
    -h|--help)
        print_help
        exit 0
        ;;
    *)
        echo "unknown option $1"
        print_help
        exit 0
        ;;
esac

SYSTEM=`uname -s`
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
        exit 1
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
    -jar "$EQUINOX_LAUNCHER" \
    -configuration "$CONFIG" \
    -data "$WORKSPACE" \
    --add-modules=ALL-SYSTEM \
    --add-opens java.base/java.util=ALL-UNNAMED \
    --add-opens java.base/java.lang=ALL-UNNAMED
