#!/bin/bash
set -e
#set -x


set +x

if [ -z "$BACK_NAME" ]; then
    echo "[ERROR] BACK_NAME var required."
    exit 1
fi

if [ -z "$TIMEOUT_SEC" ]; then
    echo "[ERROR] TIMEOUT_SEC var required."
    exit 1
fi


MESSAGE_APP_STARTED="Started AdapterApplication in"
MESSAGE_APP_FAILED_1="Application run failed"
START_TIME="$(date -u +%s)"
docker logs -f $BACK_NAME | while read line; do
    echo "$line"

    CURRENT_TIME="$(date -u +%s)"
    ELAPSED_SECONDS=$((CURRENT_TIME - START_TIME))

    if [ $ELAPSED_SECONDS -gt $TIMEOUT_SEC ]; then
        echo "timeout of ${TIMEOUT_SEC}sec reached."
        exit 1
    fi
    
    case "$line" in
        *"$MESSAGE_APP_FAILED_1"* )
        echo "[ERROR] deploy failed."
        exit 1
        ;;
    esac

    case "$line" in
        *"$MESSAGE_APP_STARTED"* )
        echo "[SUCCESS] deploy success"
        exit 0 
        ;;
    esac
done

