#!/bin/bash
set -e
#set -x

source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
source "../0_scripts/check_necessary_variables.sh"
check_necessary_variables "$ENV"


source "../0_scripts/get_repo_dir.sh"
DEVOPS_REPO_DIR=$(get_repo_dir)
FRONT_REPO_DIR=$(get_app_dir $DEVOPS_REPO_DIR "front") 
echo "[INFO] DEVOPS_REPO_DIR: $DEVOPS_REPO_DIR"
echo "[INFO] FRONT_REPO_DIR  : $FRONT_REPO_DIR"


source "../0_scripts/download_devops_repo.sh"
download_devops_repo $DEVOPS_REPO $DEVOPS_REPO_DIR "front"


source "../0_scripts/download_front_repo.sh"
download_front_repo $FRONT_REPO $FRONT_REPO_DIR "git"

