#!/bin/bash
set -e
#set -x # show executed lines


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

## Connection Vars
if [ -z "$DB_SCHEMA" ]; then
  echo "[ERROR] Variable DB_SCHEMA not found, The name of the database schema is required."
  exit 1
fi

if [ -z "$DB_USER" ]; then
  echo "[ERROR] Variable DB_USER not found, The connection username to the database is required ."
  exit 1
fi

if [ -z "$DB_IP" ]; then
  echo "[ERROR] Variable DB_IP not found, The IP to the database is required."
  exit 1
fi

if [ -z "$DB_PORT" ]; then
  echo "[ERROR] Variable DB_PORT not found, The connection port to the database is required."
  exit 1
fi

if [ -z "$DB_PASS" ]; then
  echo "[ERROR] Variable DB_PASS not found, The database password is required."
  exit 1
fi


echo "CONNECTION_VARS=--username=$DB_USER --password=DB_PASS --url=jdbc:postgresql://$DB_SERVER:5432/$DB_SCHEMA"


mkdir -p $WORKSPACE

NOW_DATE="$(date +'%Y-%m-%d_%H-%M-%S')"
BACKUP_FILE="$WORKDIR_REPO/backup_$(echo $BUILD_NUMBER)_$(echo $NOW_DATE).sql"
PGPASSWORD=$DB_PASS pg_dump -h ${DB_SERVER} -U ${DB_USER} -d ${DB_SCHEMA} -F p > $(echo $BACKUP_FILE) 

