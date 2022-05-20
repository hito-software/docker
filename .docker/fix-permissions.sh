#!/usr/bin/env sh

echo "Fixing permissions"

params=""

if [ ! -z "$1" ]; then
    if [ "$1" == "-v" ]; then
        params="-v"
    fi

    if [ "$1" == "-c" ]; then
        params="-c"
    fi
fi

echo "Chowning directory '$APP_DIRECTORY'..."
chown $params -R www-data:users "$APP_DIRECTORY"

echo "Chmoding directory '$APP_DIRECTORY'..."
chmod $params -R 775 "$APP_DIRECTORY"

exit 0
