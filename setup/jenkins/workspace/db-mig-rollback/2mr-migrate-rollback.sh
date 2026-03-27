#!/bin/bash
set -e
#set -x # show executed lines


# ######## introduction
if [ -n "$JENKINS_URL" ]; then
    ENV_TYPE="JENKINS"
    source /var/jenkins_home/workspace/.env

elif [ -f /.dockerenv ]; then
    ENV_TYPE="CONTAINER-SHELL"
    source /var/jenkins_home/workspace/.env

elif [ "$(ps -p 1 -o comm=)" = "systemd" ] || [ "$(ps -p 1 -o comm=)" = "init" ]; then
    ENV_TYPE="HOST"
    DEVOPS_WORKDIR="/home/m51/mine/t51/devops/setup/jenkins/workspace"
    DEVOPS_REPO="ssh://git@gitea.mariomv-local.org:222/mario1/t51DevOps.git"
    BUILD_NUMBER="0.1-test"
fi

echo -e "\e[42m[INFO] Running in: $ENV_TYPE\e[0m"


WORKDIR_REPO="$DEVOPS_WORKDIR/db-mig-rollback/$BUILD_NUMBER"




# ######## Validate dependencies
if [ -z "$DEVOPS_WORKDIR" ]; then
  echo "[ERROR] Variable DEVOPS_WORKDIR not found, The path to the devops workdir is required."
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


cd $WORKDIR_REPO/app/db/source


# GET VERSION
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

    if [ -z "$DB_VERSION" ]; then
      echo "[ERROR] Variable DB_VERSION not found, Database version required."
      exit 1
    fi

    if [ -z "$DB_PREVIOUS_VERSION" ]; then
      echo "[ERROR] Variable DB_PREVIOUS_VERSION not found, Database previous version required."
      exit 1
    fi


echo "DB_VERSION: $DB_VERSION"
echo "DB_PREVIOUS_VERSION: $DB_PREVIOUS_VERSION"
echo "CONNECTION_VARS=--username=$DB_USER --password=DB_PASS --url=jdbc:postgresql://$DB_SERVER:5432/$DB_SCHEMA"
CONNECTION_VARS="--username=$DB_USER --password=$DB_PASS --url=jdbc:postgresql://$DB_SERVER:5432/$DB_SCHEMA"



echo "[INFO] liquibase rollback starting";
sleep 5;

echo "################START-BEFORE########################"
liquibase history $CONNECTION_VARS
echo "################END---BEFORE########################"


liquibase rollback $DB_PREVIOUS_VERSION $CONNECTION_VARS --changelog-file=changelog.xml
    
echo "Tagging database with: $DB_PREVIOUS_VERSION";
liquibase tag $DB_PREVIOUS_VERSION $CONNECTION_VARS


liquibase history $CONNECTION_VARS


echo "[INFO] liquibase update finished."
