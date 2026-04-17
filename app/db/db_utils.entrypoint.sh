#!/bin/bash
set -e
set -x # show executed lines

# ENTRIES
#    $1: Action to do
#    $2: Tag for the version

echo "ACTION: $1"
if [[ "$1" != "deploy" && "$1" != "rollback" && "$1" != "history" && "$1" != "backup" && "$1" != "restore" ]]; then
    echo "[ERROR]* set first parameter to either -deploy-, -rollback-, -backup- or -restore-"
    exit 1
fi


function get_current_version {
    VERSION=$(psql -t -A -c \
    "SELECT tag FROM databasechangelog \
        WHERE tag IS NOT NULL \
        ORDER BY orderexecuted DESC \
        LIMIT 1" 2> /dev/null \
        || echo "0"
    );
    if [ -z "$VERSION" ]; then
        VERSION="0";
    fi

    echo "$VERSION"
}



echo "################START-BEFORE########################"
liquibase history
echo "################END---BEFORE########################"

if [ "$1" = "deploy" ]; then
    echo "deploy starting"
    sleep 5;
    liquibase update
    liquibase history
fi


if [ "$1" = "rollback" ]; then
    echo "Rollback starting";
    sleep 5;
    VERSION=$(get_current_version)
    liquibase rollback $VERSION
    liquibase history
fi



if [ "$1" = "backup" ]; then
    echo "[INFO] START Back up"
    
    NOW=$(date +'%Y-%m-%d_%H-%M-%S')
    pg_dump -F p > /t51/app/db/backups/backup_$NOW.sql

    echo "[INFO] END Back up"
    exit 0;
fi

if [ "$1" = "restore" ]; then
    echo "[INFO] START Back up"
    
    if [ -z "$2" ]; then
        echo "[ERROR] Backup file name not found"
        exit 1
    fi

    NOW=$(date +'%Y-%m-%d_%H-%M-%S')
    psql < /t51/app/db/backups/$2

    echo "[INFO] END Back up"
    exit 0;
fi


if [ "$1" = "history" ]; then
    liquibase history
    exit 0;
fi

echo "end liquibase-docker-entrypoint.sh";

