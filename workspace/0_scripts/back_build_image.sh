#!/bin/bash
set -e
#set -x

function back_build_image {
    if [ -z "$1" ]; then
        echo "[ERROR] The directory where the main docker-compose is required."
        exit 1
    fi

    if [ -z "$2" ]; then
        echo "[ERROR] Image tag required in back_build_image function."
        exit 1
    fi

    #BACK_IMAGE=$TAG docker compose -f $1/docker-compose.yml config back

    TAG="back:$2"
    set -x
    BACK_IMAGE=$TAG docker compose -f $1/docker-compose.yml build back
    docker tag $TAG back:latest
    set +x

}

