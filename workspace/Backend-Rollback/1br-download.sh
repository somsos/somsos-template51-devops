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
    BACK_REPO="ssh://git@gitea.mariomv-local.org:222/mario1/t51Back.git"
    DEVOPS_REPO="ssh://git@gitea.mariomv-local.org:222/mario1/t51DevOps.git"
fi

source "../0_scripts/get_repo_dir.sh"
REPO_DIR=$(get_repo_dir)
echo "[INFO] REPO_DIR: $REPO_DIR"


source "../0_scripts/download_devops_repo.sh"
download_devops_repo $DEVOPS_REPO $REPO_DIR "back"


BACK_REPO_DIR="$REPO_DIR/app/back/source"
source "../0_scripts/download_back_repo.sh"
download_back_repo $BACK_REPO $BACK_REPO_DIR "git"

