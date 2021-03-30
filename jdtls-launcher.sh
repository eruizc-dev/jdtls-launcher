#!/bin/bash

# ===== CHECK JAVA_HOME EXISTS ====
if ! [[ $JAVA_HOME ]]; then
    echo "JAVA_HOME not defined" >> /dev/stderr
    exit 1
fi

# ===== FIND JDTLS_ROOT =====
JDTLS_ROOT="$JAVA_HOME/../jdtls"

if ! [ -d $JDTLS_ROOT ]; then
    mkdir -p $JDTLS_ROOT
    cd $JDTLS_ROOT
    echo 'WARNING: JDTLS is not installed' >> /dev/stderr
    LATEST=`curl http://download.eclipse.org/jdtls/snapshots/latest.txt`
    echo "INFO: About to install $LATEST"
    curl http://download.eclipse.org/jdtls/snapshots/$LATEST > $LATEST
    tar -xf $LATEST
    rm $LATEST
fi

# ===== FIND EQUINOX LAUNCHER =====
EQUINOX_LAUNCHER="$JDTLS_ROOT/plugins/org.eclipse.equinox.launcher_*.jar"

if ! [[ $EQUINOX_LAUNCHER ]]; then
    echo 'ERROR: JDTLS installation failure'
    exit 1
else
    echo 'INFO: `JDTLS installation succesfull'
fi

# ===== FIND LOMBOK =====
LOMBOK_PATH=$JDTLS_ROOT/plugins

LOMBOK=`find $LOMBOK_PATH -type f -name 'lombok*.jar'`
if ! [[ $LOMBOK ]]; then
    echo 'WARNING: Lombok is not installed.'
    echo "INFO: Installing Lombok to $LOMBOK_PATH"
    curl https://projectlombok.org/downloads/lombok.jar > $LOMBOK_PATH/lombok.jar

    # ===== RECHECK =====
    LOMBOK=`find $LOMBOK_PATH -type f -name 'lombok*.jar'`
    if ! [[ $LOMBOK ]]; then
        echo 'ERROR: Lombok installation failure' > /dev/stderr
        exit 1
    else
        echo 'INFO: Lombok installation succesfull'
    fi
fi


# ===== FIND CONFIG FILE =====

SYSTEM=`uname -s`
case $SYSTEM in
    "Linux")
        CONFIG="$JDTLS_ROOT/config_linux"
        ;;
    "Darwin")
        CONFIG="$JDTLS_ROOT/config_mac"
        ;;
    *)
        echo "Unknown or unsupported system $SYSTEM" >> /dev/stderr
        exit
        ;;
esac

# ===== RUN =====

$JAVA_HOME/bin/java \
    -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -Dlog.protocol=true \
    -Dlog.level=ALL \
    -Xms1g \
    -Xmx2G \
    -javaagent:$LOMBOK \
    -jar $EQUINOX_LAUNCHER \
    -configuration $CONFIG \
    -data "$HOME/workspace" \
    --add-modules=ALL-SYSTEM \
    --add-opens java.base/java.util=ALL-UNNAMED \
    --add-opens java.base/java.lang=ALL-UNNAMED
