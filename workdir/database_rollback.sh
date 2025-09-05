#!/bin/bash
set -e

# CAUTION: Keep this file sync with jenkins job to rollback database, this file
# is just to keep it saved.

MY_BRANCH="main"   # CAUTION: Keep sync with .env file
MY_REPO="ssh://git@gitea.mariomv.duckdns.org:222/mario1/template51_devops.git"
MY_DIR="t51_$(echo $BUILD_NUMBER)_db_rollback"

git clone  --depth=1 --single-branch --branch $MY_BRANCH $MY_REPO $MY_DIR

cd $MY_DIR

set -a
source .env
set +a

git clone  --depth=1 --single-branch --branch $MY_BRANCH $DB_MIGRATIONS_REPO $DB_MIGRATIONS_DIR

docker compose build db_migrate

docker compose run --rm --no-deps db_migrate rollback
