#!/bin/bash
set -e

echo "param-1: $1"

echo "DB_NAME: $DB_NAME"
echo "DB_USER: $DB_USER"
#echo "DB_PASSWORD: $DB_PASSWORD"
echo "DB_IP: $DB_IP"
echo "DB_PORT: $DB_PORT"
echo "DB_PREVIOUS_VERSION: $DB_PREVIOUS_VERSION"
echo "DB_VERSION: $DB_VERSION"

CONNECTION_VARS="--username=$DB_USER --password=$DB_PASSWORD --url=jdbc:postgresql://$DB_IP:$DB_PORT/$DB_NAME";


if [[ "$1" != "deploy" && "$1" != "rollback" ]]; then
    echo "set first parameter to either 'deploy' or 'rollback'"
    exit 1
fi


if [ "$1" = "deploy" ]; then
    echo "deploy starting"
    sleep 5;
    liquibase update $CONNECTION_VARS --changelog-file=changelog.xml

    liquibase tag $DB_VERSION $CONNECTION_VARS

    exit 0;
fi


if [ "$1" = "rollback" ]; then
    echo "rollback starting";
    sleep 5;

    liquibase rollback $DB_PREVIOUS_VERSION $CONNECTION_VARS --changelog-file=changelog.xml
        
    liquibase tag $DB_PREVIOUS_VERSION $CONNECTION_VARS

    exit 0;
fi

echo "end liquibase-docker-entrypoint.sh";
