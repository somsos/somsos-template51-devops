#!/bin/bash
set -e
#set -x

source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
source "../0_scripts/check_necessary_variables.sh"
check_necessary_variables "$ENV"


source "../0_scripts/get_repo_dir.sh"
DEVOPS_REPO_DIR=$(get_repo_dir)
BACK_REPO_DIR=$(get_app_dir $DEVOPS_REPO_DIR "back") 
echo "[INFO] DEVOPS_REPO_DIR: $DEVOPS_REPO_DIR"
echo "[INFO] BACK_REPO_DIR  : $BACK_REPO_DIR"


source "../0_scripts/get_tag_name.sh"
IMAGE_TAG=$(get_tag_name $BACK_REPO_DIR $BUILD_NUMBER "back")
echo "[INFO] IMAGE_TAG      : $IMAGE_TAG"


source "../0_scripts/temp_env_file_functions.sh"
copy_env_file "$DEVOPS_REPO_DIR/.env" "keep_passwords"

source "../0_scripts/build_image.sh"
build_image $DEVOPS_REPO_DIR $IMAGE_TAG "back"

echo "[SUCCESS] Backend image built successfully."

