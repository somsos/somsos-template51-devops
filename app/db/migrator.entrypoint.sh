#!/bin/bash
set -e
set -x # show executed lines

echo "param-1: $1"
if [[ "$1" != "deploy" && "$1" != "rollback" && "$1" != "history" ]]; then
    echo "set first parameter to either -deploy- or -rollback-"
    exit 1
fi



### GET VERSION
    # Check if VERSION is a valid integer
    if  [ ! -f "./VERSION" ]; then
        echo "[ERROR] File VERSION not found and it's required."
        exit 1
    fi

    DB_VERSION=$(head -n 1 "./VERSION" | tr -d '[:space:]')
    echo "1-DB_VERSION: $DB_VERSION"
    
    if ! [[ $DB_VERSION =~ ^[0-9]+$ ]]; then
        echo "[ERROR] Invalid format: version is not a number"
        exit 1
    fi

    # Compute previous version
    DB_PREVIOUS_VERSION=$( echo "$DB_VERSION - 1" | bc )
    echo "DB_PREVIOUS_VERSION: $DB_PREVIOUS_VERSION"
    echo "DB_VERSION: $DB_VERSION"



if [ "$1" = "deploy" ]; then
    echo "deploy starting"
    sleep 5;
    liquibase update

    echo "Tagging database with: $DB_VERSION";
    liquibase tag $DB_VERSION

    liquibase history

    exit 0;
fi


if [ "$1" = "rollback" ]; then
    echo "rollback starting";
    sleep 5;

    echo "################START-BEFORE########################"
    liquibase history
    echo "################END---BEFORE########################"

    liquibase rollback $DB_PREVIOUS_VERSION 
    
    echo "Tagging database with: $DB_PREVIOUS_VERSION";
    liquibase tag $DB_PREVIOUS_VERSION

    liquibase history

    exit 0;
fi


if [ "$1" = "history" ]; then
    liquibase history
    exit 0;
fi

echo "end liquibase-docker-entrypoint.sh";

