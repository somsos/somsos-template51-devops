#!/bin/bash
set -e
#set -x # show executed lines

source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
source "../0_scripts/check_necessary_variables.sh"
check_necessary_variables "$ENV"



if [ -z "$DEVOPS_WORKDIR" ]; then
  echo "[ERROR] Variable DEVOPS_WORKDIR not found, The path to the devops workdir is required."
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

PATH_BACKUPS="/var/jenkins_home/workspace/Database-Backup"

if [ -z "$PATH_BACKUPS" ]; then
  echo "[ERROR] Variable PATH_BACKUPS not found, The path where the backups are saved is required."
  exit 1
fi

if [ -z "$BACKUP_NAME" ]; then
  echo "[ERROR] Variable BACKUP_NAME not found, The file name of the backup to restore is required."
  exit 1
fi





echo "CONNECTION_VARS=--username=$DB_USER --password=DB_PASS --url=jdbc:postgresql://$DB_SERVER:5432/$DB_SCHEMA"



PGPASSWORD=${DB_PASS} psql -h ${DB_SERVER} -U ${DB_USER} -d ${DB_SCHEMA} < $PATH_BACKUPS/${BACKUP_NAME}
