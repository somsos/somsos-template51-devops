#!/bin/bash
set -e
#set -x # show executed lines, 3m-migrate-deploy.sh


# ######## introduction
source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
source "../0_scripts/check_necessary_variables.sh"
check_necessary_variables "$ENV"


source "../0_scripts/get_repo_dir.sh"
DEVOPS_REPO_DIR=$(get_repo_dir)
echo "[INFO] DEVOPS_REPO_DIR: $DEVOPS_REPO_DIR"


docker compose -f $DEVOPS_REPO_DIR/docker-compose.yml --progress plain build db_utils
