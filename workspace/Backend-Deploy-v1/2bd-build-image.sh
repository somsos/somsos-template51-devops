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
    BUILD_NUMBER=10
fi


source "../0_scripts/get_repo_dir.sh"
DEVOPS_REPO_DIR=$(get_repo_dir)
BACK_REPO_DIR=$(get_app_dir $DEVOPS_REPO_DIR "back") 
echo "[INFO] DEVOPS_REPO_DIR: $DEVOPS_REPO_DIR"
echo "[INFO] BACK_REPO_DIR  : $BACK_REPO_DIR"


source "../0_scripts/get_tag_name.sh"
IMAGE_TAG=$(get_tag_name $BACK_REPO_DIR $BUILD_NUMBER "back")
echo "[INFO] IMAGE_TAG      : $IMAGE_TAG"


source "../0_scripts/back_build_image.sh"
back_build_image $DEVOPS_REPO_DIR $IMAGE_TAG

