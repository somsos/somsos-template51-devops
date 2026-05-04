#!/bin/bash
set -e
#set -x # show executed lines, 3m-migrate-deploy.sh


# ######## introduction
source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
source "../0_scripts/check_necessary_variables.sh"
check_necessary_variables "$ENV"


# ######## Validate dependencies
if [[ "$1" != "deploy" && "$1" != "rollback" ]]; then
    echo "[ERROR] File Argument 1 not found, "deploy" or "rollback" argument required."
    exit 1
fi

source "../0_scripts/get_repo_dir.sh"
DEVOPS_REPO_DIR=$(get_repo_dir)
echo "[INFO] DEVOPS_REPO_DIR: $DEVOPS_REPO_DIR"

set -x
docker compose -f $DEVOPS_REPO_DIR/docker-compose.yml run --rm --name temp_db_utils db_utils $1
set +x
