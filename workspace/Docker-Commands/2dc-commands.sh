#!/bin/bash
set -e
#set -x

source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
source "../0_scripts/check_necessary_variables.sh"
check_necessary_variables "$ENV"

source "../0_scripts/get_repo_dir.sh"
DEVOPS_REPO_DIR=$(get_repo_dir)
echo "[INFO] DEVOPS_REPO_DIR: $DEVOPS_REPO_DIR"

if [ -z "$1" ]; then
    echo "[ERROR] File argument 1 required: main action. e.g. 'status', 'db', 'back', 'front', etc"
    exit 1
fi

if [ -z "$2" ]; then
    echo "[ERROR] File argument 2 required: secudary action. e.g. 'none', 'up', 'down', 'restart', etc"
    exit 1
fi




if [ "$1" = "status"  ]; then
    docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Size}}'
    exit 0
fi

if [ "$2" = "up" ] || [ "$2" = "down" ] || [ "$2" = "restart" ]; then
  if [ "$2" = "none"  ]; then
    echo "[ERROR] Bad parameter 'none' use other one please"
    exit 1
  fi
fi


if [ "$2" = "up"  ]; then
    docker compose -f $DEVOPS_REPO_DIR/docker-compose.yml up -d --wait $1
    CHECK_STATUS=true
fi

if [ "$2" = "down"  ]; then
    docker compose -f $DEVOPS_REPO_DIR/docker-compose.yml down $1
    CHECK_STATUS=true
fi

if [ "$2" = "restart" ]; then
    docker compose -f $DEVOPS_REPO_DIR/docker-compose.yml restart $1
    CHECK_STATUS=true
fi

if [ "$CHECK_STATUS" = "true" ]; then
  docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Size}}'
fi
