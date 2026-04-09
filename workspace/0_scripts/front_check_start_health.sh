#!/bin/bash
set -e
#set -x


set +x

if [ -z "$FRONT_NAME" ]; then
    echo "[ERROR] FRONT_NAME var required."
    exit 1
fi

if [ -z "$TIMEOUT_SEC" ]; then
    echo "[ERROR] TIMEOUT_SEC var required."
    exit 1
fi


MESSAGE_APP_STARTED="Configuration complete; ready for start up"
START_TIME="$(date -u +%s)"
docker logs -f $FRONT_NAME | while read line; do
    echo "$line"

    CURRENT_TIME="$(date -u +%s)"
    ELAPSED_SECONDS=$((CURRENT_TIME - START_TIME))

    if [ $ELAPSED_SECONDS -gt $TIMEOUT_SEC ]; then
        echo "timeout of ${TIMEOUT_SEC}sec reached."
        exit 1
    fi

    case "$line" in
        *"$MESSAGE_APP_STARTED"* )
        echo "deploy success"
        exit 0 
        ;;
    esac
done

