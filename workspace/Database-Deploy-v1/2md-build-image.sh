#!/bin/bash
set -e
#set -x # show executed lines, 3m-migrate-deploy.sh


# ######## introduction
source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
source "../0_scripts/check_necessary_variables.sh"
check_necessary_variables "$ENV"


# ######## Validate dependencies
if [ -z "$WORKSPACE" ]; then
  echo "[ERROR] Variable WORKSPACE not found, The path to the devops workdir is required."
  exit 1
fi

if [ -z "$BUILD_NUMBER" ]; then
  echo "[ERROR] Variable BUILD_NUMBER not found, The incremental number of builds is required."
  exit 1
fi

WORKDIR_REPO="$WORKSPACE/$BUILD_NUMBER"

cd $WORKDIR_REPO

docker compose build db_utils
