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

source "../0_scripts/download_devops_repo.sh"
download_devops_repo $DEVOPS_REPO $DEVOPS_REPO_DIR "docker-commands"
echo -e "\033[38;5;27;48;5;231m[Success] downloaded and cleaned.\033[0m"

