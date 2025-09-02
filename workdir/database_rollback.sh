#!/bin/bash

MY_BRANCH="main"   # CAUTION: Keep sync with .env file
MY_REPO="ssh://git@gitea.mariomv.duckdns.org:222/mario1/template51_devops.git"
MY_DIR="t51_$(echo $BUILD_NUMBER)_db_rollback"

git clone  --depth=1 --single-branch --branch $MY_BRANCH $MY_REPO $MY_DIR

cd $MY_DIR

set -a
source .env
set +a

clone_repo $LIQUIBASE_REPO $MIGRATIONS_SOURCE

run_container $LIQUIBASE_SERVICE deploy

docker compose run --rm liquibase_migration rollback $DB_PREVIOUS_VERSION




# $1: service name
# $2: command parameter
function run_container {
  echo -e "\nSetting up $1"
  echo -e "\n\n docker compose run --rm $1 $2" >> $LOG_FILE

  docker compose run --rm $1 $2
}


#$1 repository ssh URI
#$2 target directory
function clone_repo {
  local CLONE_COMMAND="git clone  --depth=1 --single-branch --branch $BRANCH"

  echo -e "\nCloning $2"
  echo "$CLONE_COMMAND $1 $2" >> $LOG_FILE
  $CLONE_COMMAND $1 $2 &>> $LOG_FILE
  echo -e "\n\n" >> $LOG_FILE
  print_logs $? "Cloning $2"
}