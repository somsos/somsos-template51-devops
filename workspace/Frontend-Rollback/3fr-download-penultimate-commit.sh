#!/bin/bash
set -e
#set -x

source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
if [ "$ENV" = "JENKINS"  ]; then
    echo "In pipeline"
elif [ "$ENV" = "CONTAINER-SHELL"  ]; then
    echo "In container"
elif [ "$ENV" = "HOST"  ]; then
    echo "In DOCKER HOST"
    source "../../.env"
    WORKSPACE="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
    FRONT_REPO="ssh://git@gitea.mariomv-local.org:222/mario1/t51Front.git"
    BUILD_NUMBER=11
fi

source "../0_scripts/get_repo_dir.sh"
REPO_DIR=$(get_repo_dir)
echo "[INFO] REPO_DIR: $REPO_DIR"



FRONT_REPO_DIR="$REPO_DIR/app/front/source"
source "../0_scripts/download_front_repo.sh"
download_front_repo $FRONT_REPO_DIR

