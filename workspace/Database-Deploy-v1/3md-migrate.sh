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

WORKDIR_REPO="$WORKSPACE/$BUILD_NUMBER"

cd $WORKDIR_REPO

set -x
docker compose run --rm --name temp_db_utils db_utils $1
set +x
