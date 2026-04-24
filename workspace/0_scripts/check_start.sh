#!/bin/bash
set -e
#set -x

function check_start {

    if [[ "$1" != "back" && "$1" != "front" ]]; then
        set -x &&  echo "[ERROR] Service name required in check_start function" && set +x
        exit 1
    fi

    if [ -z "$2" ]; then
        echo "[ERROR] TIMEOUT_SEC var required in check_start function argument 2."
        exit 1
    fi

    
    MESSAGE_BACK_FAILED_1="Application run failed"
    

    MESSAGE_BACK_STARTED="Started AdapterApplication in"
    MESSAGE_FRONT_STARTED="Configuration complete; ready for start up"


    START_TIME="$(date -u +%s)"
    while read line; do
        echo "$line"

        CURRENT_TIME="$(date -u +%s)"
        ELAPSED_SECONDS=$((CURRENT_TIME - START_TIME))

        if [ "$ELAPSED_SECONDS" -gt "$2" ]; then
            echo "timeout of ${2}sec reached."
            exit 1
        fi

        if [ "$1" = "back" ]; then
            case "$line" in
                *"$MESSAGE_BACK_STARTED"* )
                echo "Backend deploy success"
                exit 0 
                ;;
            esac

            case "$line" in
                *"$MESSAGE_BACK_FAILED_1"* )
                echo "[ERROR] deploy failed."
                exit 1
                ;;
            esac
        fi


        if [ "$1" = "front" ]; then
            case "$line" in
                *"$MESSAGE_FRONT_STARTED"* )
                echo "Frontend deploy success"
                exit 0 
                ;;
            esac
        fi

    done < <(docker logs -f $1)



}

