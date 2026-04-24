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


source "../0_scripts/download_devops_repo.sh"
download_devops_repo $DEVOPS_REPO $DEVOPS_REPO_DIR "back"


source "../0_scripts/download_back_repo.sh"
download_back_repo $BACK_REPO $BACK_REPO_DIR "git"

