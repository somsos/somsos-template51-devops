#!/bin/bash
set -e
#set -x


# The flag "--force-recreate" it's important, because if the container 
# started in an previous time, it's going to keep the same state, it happened
# me that by a failed connection because was down the DB server, it keep
# failing even when the DB was already available, and just with this flag
# I solved it. Note: also can be solved running an "docker rm" command

function deploy {
    if [ -z "$1" ]; then
        echo "[ERROR] The directory where the main docker-compose is required."
        exit 1
    fi

    if [ -z "$2" ]; then
        echo "[ERROR] Timeout in seconds required."
        exit 1
    fi

    if [ -z "$3" ]; then
        echo "[ERROR] back image tag to deploy required."
        exit 1
    fi

    if [[ "$4" != "back" && "$4" != "front" ]]; then
        echo "[ERROR] Required service name to deploy in argument 4 of function deploy"
        exit 1
    fi

    # --build
    echo -e "\e[42m[INFO] Image to deploy: $3 \e[0m"
    set -x
    docker compose -f $1/docker-compose.yml stop $4
    # we reference the image by its build tag just to be sure to get the correct one
    BACK_IMAGE=$3 docker compose -f $1/docker-compose.yml up  --force-recreate -d --wait-timeout $2 $4
    set +x
}
