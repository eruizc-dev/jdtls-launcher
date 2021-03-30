#!/bin/bash

# ===== CHECK JAVA_HOME EXISTS ====
if ! [[ -d "$JAVA_HOME" ]]; then
    echo "ERROR: JAVA_HOME is not defined" >> /dev/stderr
    exit 1
fi

# ===== FIND JDTLS =====
JDTLS_ROOT="$JAVA_HOME/../jdtls"
EQUINOX_LAUNCHER=`find $JDTLS_ROOT/plugins -nowarn -type f -name 'org.eclipse.equinox.launcher_*' 2> /dev/null`

if ! [[ -f "$EQUINOX_LAUNCHER" ]]; then
    echo 'WARNING: JDTLS is not installed' >> /dev/stderr

    LATEST=`curl -s http://download.eclipse.org/jdtls/snapshots/latest.txt`
    echo "INFO: About to install $LATEST to $JDTLS_ROOT"

    mkdir -p "$JDTLS_ROOT" || exit 1
    cd "$JDTLS_ROOT"

    curl "http://download.eclipse.org/jdtls/snapshots/$LATEST" > "$LATEST"
    tar -xf "$LATEST"
    rm "$LATEST"
    chmod 777 "$JDTLS_ROOT"
    chmod -R 777 "$JDTLS_ROOT/config_*"

    EQUINOX_LAUNCHER=`find $JDTLS_ROOT/plugins -nowarn -type f -name 'org.eclipse.equinox.launcher_*' 2> /dev/null`
    if ! [[ -f "$EQUINOX_LAUNCHER" ]]; then
        echo 'ERROR: JDTLS installation failure' > /dev/stderr
        exit 1
    else
        echo 'INFO: JDTLS installation succesfull'
    fi
fi

# ===== FIND LOMBOK =====
LOMBOK="$JDTLS_ROOT/plugins/lombok.jar"
if ! [[ -f "$LOMBOK" ]]; then
    echo 'WARNING: Lombok is not installed' > /dev/stderr

    echo "INFO: Installing Lombok to $LOMBOK"
    curl "https://projectlombok.org/downloads/lombok.jar" > "$LOMBOK"

    if ! [[ -f "$LOMBOK" ]]; then
        echo 'ERROR: Lombok installation failure' > /dev/stderr
        exit 1
    else
        echo 'INFO: Lombok installation succesfull'
    fi
fi


# ===== FIND CONFIG FILE =====

SYSTEM=`uname -s`
case "$SYSTEM" in
    "Linux") # Linux and WSL
        CONFIG="$JDTLS_ROOT/config_linux"
        ;;
    "Darwin") # MacOS
        CONFIG="$JDTLS_ROOT/config_mac"
        ;;
    *)
        echo "ERROR: Unknown or unsupported system $SYSTEM" >> /dev/stderr
        echo "Consider opening a new issue: https://github.com/eruizc-dev/jdtls-launcher/issues/new?title=Unsupported%20system%20$SYSTEM" >> /dev/stderr
        exit 1
        ;;
esac

# ===== FIND JAVA EXEC  =====
if [[ -f "$JAVA_HOME/bin/java" ]]; then
    JAVA_EXEC="$JAVA_HOME/bin/java"
elif [[ -f "$JAVA_HOME/bin/java.exe" ]]; then
    JAVA_EXEC="$JAVA_HOME/bin/java.exe"
else
    echo 'ERROR: could not find java binary' > /dev/stderr
fi

"$JAVA_EXEC" \
    -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -Dlog.protocol=true \
    -Dlog.level=ALL \
    -Xms1g \
    -Xmx2G \
    -javaagent:"$LOMBOK" \
    -jar "$EQUINOX_LAUNCHER" \
    -configuration "$CONFIG" \
    -data "$HOME/workspace" \
    --add-modules=ALL-SYSTEM \
    --add-opens java.base/java.util=ALL-UNNAMED \
    --add-opens java.base/java.lang=ALL-UNNAMED

