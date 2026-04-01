#!/bin/bash
set -e
#set -x # show executed lines

################## FRONTEND: Download ##################
# JOB_NAME       # It's created in pipeline runtime by Jenkins

# ######## introduction
if [ -n "$JENKINS_URL" ]; then
    ENV_TYPE="JENKINS"
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


WORKDIR_FRONT="$DEVOPS_WORKDIR/Frontend-Deploy-v1"


# ######## Validate dependencies
if [ -z "$DEVOPS_WORKDIR" ]; then
  echo "[ERROR] Variable DEVOPS_WORKDIR not found, The path to the devops workdir is required."
  exit 1
fi

if [ -z "$BUILD_NUMBER" ]; then
  echo "[ERROR] Variable BUILD_NUMBER not found, The incremental number of builds is requiered."
  exit 1
fi

if [ -z "$DEVOPS_REPO" ]; then
  echo "[ERROR] Variable DEVOPS_REPO not found, The URL to the devops project is required."
  exit 1
fi


# ######## Clone DevOps reposotory
WORKDIR_BUILD="$WORKDIR_FRONT/$BUILD_NUMBER"
rm -fr $WORKDIR_BUILD
git clone --quiet --depth=1 --single-branch --branch main "$DEVOPS_REPO" "$WORKDIR_BUILD" \
  && echo -e "\e[42m[INFO] Devops repo cloned.\e[0m"
git -C $WORKDIR_BUILD log --oneline -n1
sleep 3


# ######## Remove incesesary things (CAUTION: Keep in sync with back & db_mig/1-download.sh
rm -rf $WORKDIR_BUILD/.git/
rm -rf $WORKDIR_BUILD/setup/
rm -rf $WORKDIR_BUILD/docs/
rm -rf $WORKDIR_BUILD/README.md
rm -rf $WORKDIR_BUILD/.gitignore

rm -rf $WORKDIR_BUILD/app/db/
rm -rf $WORKDIR_BUILD/app/back/
rm -rf $WORKDIR_BUILD/app/utils/

echo -e "\e[42m[INFO] Removed inecesary files in devops project for Back deploy.\e[0m"


# Remove line because is not requiered for the maven build and is going to fail if docker copose look for it.
# CAUTION: keep in sync with back and db_mig
DOCKER_COMPOSE_FILE="$WORKDIR_BUILD/docker-compose.yml"
DOCKER_COMPOSE_FILE_temp="$WORKDIR_BUILD/docker-compose.temp.yml" # Don't know why but I need the temp file
touch $DOCKER_COMPOSE_FILE_temp
cat $DOCKER_COMPOSE_FILE | grep -v setup/docker-compose >> $DOCKER_COMPOSE_FILE_temp \
  && echo -e "\e[42m[INFO] dependency in docker-compose.yml removed.\e[0m"
rm $DOCKER_COMPOSE_FILE
mv $DOCKER_COMPOSE_FILE_temp $DOCKER_COMPOSE_FILE


# ######## Clone FrontEnd reposotory
DIR_REPO="$WORKDIR_BUILD/app/front/source"
rm -rfv $DIR_REPO/*
git clone --quiet --depth=1 --single-branch --branch main "$FRONT_REPO" "$DIR_REPO" \
  && echo -e "\e[42m[INFO] FrontEnd repository cloned.\e[0m"
git -C $DIR_REPO log --oneline -n1
sleep 3
rm -rf $DIR_REPO/.git/


echo -e "\e[42m[SUCCESS] Cloning and preparings done.\e[0m"
