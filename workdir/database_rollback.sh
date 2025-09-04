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

cp .env $DB_MIGRATIONS_DIR

cd $DB_MIGRATIONS_DIR


DB_PREVIOUS_VERSION=$(awk -F'=' '/^dbPreviousVersion=/ {print $2}' liquibase.properties)

if [[ -n "$DB_PREVIOUS_VERSION" ]]; then
    echo "Database previous version: $DB_PREVIOUS_VERSION"
else
    echo "Property 'dbPreviousVersion' exists but has no value"
fi


echo "liquibase rollback $DB_PREVIOUS_VERSION ..."
liquibase rollback $DB_PREVIOUS_VERSION \
  --username=$POSTGRES_USER \
  --password=$DB_PASSWORD \
  --changelog-file=changelog.xml \
  --url=jdbc:postgresql://$DB_IP:$DB_PORT/$POSTGRES_DB;


echo "liquibase tag $DB_PREVIOUS_VERSION ...";
liquibase tag $DB_PREVIOUS_VERSION \
  --username=$POSTGRES_USER \
  --password=$DB_PASSWORD \
  --url=jdbc:postgresql://$DB_IP:$DB_PORT/$POSTGRES_DB;
