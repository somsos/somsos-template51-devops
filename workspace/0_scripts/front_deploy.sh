#!/bin/bash
set -e
#set -x


function front_deploy {
    if [ -z "$1" ]; then
        echo "[ERROR] The directory where the main docker-compose is required."
        exit 1
    fi

    if [ -z "$2" ]; then
        echo "[ERROR] Timeout in seconds required."
        exit 1
    fi

    docker compose -f $1/docker-compose.yml stop front
    docker compose -f $1/docker-compose.yml up -d --wait-timeout $2 front
}