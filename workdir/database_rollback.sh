#!/bin/bash

MY_BRANCH="main"   # CAUTION: Keep sync with .env file
MY_REPO="ssh://git@gitea.mariomv.duckdns.org:222/mario1/template51_devops.git"
MY_DIR="t51_$(echo $BUILD_NUMBER)_db_rollback"

git clone  --depth=1 --single-branch --branch $MY_BRANCH $MY_REPO $MY_DIR

cd $MY_DIR

set -a
source .env
set +a

clone_repo $LIQUIBASE_REPO $MIGRATIONS_SOURCE_CODE

cd $MIGRATIONS_SOURCE_CODE


liquibase rollback $DB_PREVIOUS_VERSION \
  --username=$POSTGRES_USER \
  --password=$DB_PASSWORD \
  --changelog-file=changelog.xml \
  --url=jdbc:postgresql://$DB_IP:$DB_PORT/$POSTGRES_DB;


#$1 repository ssh URI
#$2 target directory
function clone_repo {
  local CLONE_COMMAND="git clone  --depth=1 --single-branch --branch $BRANCH"

  echo -e "\nCloning $2"
  echo "$CLONE_COMMAND $1 $2" >> $LOG_FILE
  $CLONE_COMMAND $1 $2 &>> $LOG_FILE
  echo -e "\n\n" >> $LOG_FILE
}
