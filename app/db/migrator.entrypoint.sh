#!/bin/bash
set -e
set -x # show executed lines

# ENTRIES
#    $1: Action to do
#    $2: Tag for the version

echo "ACTION: $1"
echo "TAG:: $2"
if [[ "$1" != "deploy" && "$1" != "rollback" && "$1" != "history" ]]; then
    echo "[ERROR]* set first parameter to either -deploy- or -rollback-"
    exit 1
fi

if [[ ! -n "$2" && "$2" =~ ^-?[0-9]+$ ]]; then
    echo "[ERROR] Second parameter (the tag of the version) must be a number"
fi

DB_VERSION="$2"
DB_NEW_VERSION=$( echo "$DB_VERSION + 1" | bc )
echo "DB_NEW_VERSION: $DB_NEW_VERSION"
echo "DB_VERSION: $DB_VERSION"



if [ "$1" = "deploy" ]; then
    echo "deploy starting"
    sleep 5;
    liquibase update

    liquibase tag $DB_NEW_VERSION

    liquibase history

    exit 0;
fi


if [ "$1" = "rollback" ]; then
    echo "rollback starting";
    sleep 5;

    echo "################START-BEFORE########################"
    liquibase history
    echo "################END---BEFORE########################"

    liquibase rollback $DB_VERSION 
    
    liquibase tag $DB_VERSION

    liquibase history

    exit 0;
fi


if [ "$1" = "history" ]; then
    liquibase history
    exit 0;
fi

echo "end liquibase-docker-entrypoint.sh";

