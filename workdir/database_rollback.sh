#!/bin/bash

MY_BRANCH="main"   # CAUTION: Keep sync with .env file
MY_REPO="ssh://git@gitea.mariomv.duckdns.org:222/mario1/template51_devops.git"
MY_DIR="t51_$(echo $BUILD_NUMBER)_db_rollback"

git clone  --depth=1 --single-branch --branch $MY_BRANCH $MY_REPO $MY_DIR

cd $MY_DIR

set -a
source .env
set +a

docker compose run --rm liquibase_migration rollback $DB_PREVIOUS_VERSION

