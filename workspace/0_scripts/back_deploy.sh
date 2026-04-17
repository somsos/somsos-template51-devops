#!/bin/bash
set -e
#set -x


function back_deploy {
    if [ -z "$1" ]; then
        echo "[ERROR] The directory where the main docker-compose is required."
        exit 1
    fi

    if [ -z "$2" ]; then
        echo "[ERROR] Timeout in seconds required."
        exit 1
    fi

    docker compose -f $1/docker-compose.yml stop back
    docker compose -f $1/docker-compose.yml up -d --build --force-recreate --wait-timeout $2 back
}