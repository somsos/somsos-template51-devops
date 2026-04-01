#!/bin/bash
set -e
#set -x # show executed lines, 3m-migrate-deploy.sh


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
    WORKSPACE="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )" # PATH of the SCRIPT
fi

echo -e "\e[42m[INFO] Running in: $ENV_TYPE\e[0m"


# ######## Validate dependencies
if [ -z "$WORKSPACE" ]; then
  echo "[ERROR] Variable WORKSPACE not found, The path to the devops workdir is required."
  exit 1
fi

if [ -z "$BUILD_NUMBER" ]; then
  echo "[ERROR] Variable BUILD_NUMBER not found, The incremental number of builds is required."
  exit 1
fi

if [ -z "$1" ]; then
  echo "[ERROR] 1 argument required in file execution required, e.g. source this-file.sh required-param."
  exit 1
fi

cd "$WORKSPACE/$BUILD_NUMBER"

echo "[INFO] liquibase migration starting";

docker compose run --rm --name temp db_migrate $1

echo "[INFO] liquibase update finished."
