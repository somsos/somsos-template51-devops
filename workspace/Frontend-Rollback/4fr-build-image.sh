#!/bin/bash
set -e
#set -x

source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
if [ "$ENV" = "JENKINS"  ]; then
    echo "In pipeline"
elif [ "$ENV" = "CONTAINER-SHELL"  ]; then
    echo "In container"
    source "../.env"
    WORKSPACE="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
    BUILD_NUMBER=11

elif [ "$ENV" = "HOST"  ]; then
    echo "In DOCKER HOST"
    source "../../.env"
    WORKSPACE="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
    FRONT_REPO="ssh://git@gitea.mariomv-local.org:222/mario1/t51Front.git"
    BUILD_NUMBER=11
fi

source "../0_scripts/get_repo_dir.sh"
BUILD_DIR=$(get_repo_dir)
echo "[INFO] REPO_DIR: $BUILD_DIR"

cd $BUILD_DIR && echo "[INFO] moved to $BUILD_DIR"

docker compose build front

docker images --format 'table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}' | grep -i $FRONT_NAME

