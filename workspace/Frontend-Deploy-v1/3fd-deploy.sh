#!/bin/bash
set -e
# set -x

source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
source "../0_scripts/check_necessary_variables.sh"
check_necessary_variables "$ENV"


source "../0_scripts/get_repo_dir.sh"
DEVOPS_REPO_DIR=$(get_repo_dir)
FRONT_REPO_DIR=$(get_app_dir $DEVOPS_REPO_DIR "front") 
echo "[INFO] DEVOPS_REPO_DIR: $DEVOPS_REPO_DIR"
echo "[INFO] FRONT_REPO_DIR  : $FRONT_REPO_DIR"


source "../0_scripts/get_tag_name.sh"
IMAGE_TAG=$(get_tag_name $FRONT_REPO_DIR $BUILD_NUMBER "front")
echo "[INFO] IMAGE_TAG      : $IMAGE_TAG"


TIMEOUT_SEC="300"
source "../0_scripts/deploy.sh"
deploy $DEVOPS_REPO_DIR $TIMEOUT_SEC $IMAGE_TAG "front"


source "../0_scripts/check_start.sh"
check_start "front" "$TIMEOUT_SEC"

