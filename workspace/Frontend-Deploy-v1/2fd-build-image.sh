#!/bin/bash
set -e
# set -x # for debugging

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
echo -e "\033[38;5;27;48;5;231m[INFO] IMAGE_TAG to build: $IMAGE_TAG $3 \033[0m"


source "../0_scripts/build_image.sh"
build_image "$DEVOPS_REPO_DIR" "$IMAGE_TAG" "front"

