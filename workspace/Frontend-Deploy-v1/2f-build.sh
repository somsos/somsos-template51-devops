#!/bin/bash
set -e
#set -x # show executed lines

################## FRONTEND: Build ##################
# JOB_NAME       # It's created in pipeline runtime by Jenkins

# ######## introduction
if [ -n "$JENKINS_URL" ]; then
    ENV_TYPE="JENKINS"
    source /var/jenkins_home/workspace/.env
    
elif [ -f /.dockerenv ]; then
    echo "In container"
    source "../.env"
    WORKSPACE="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
    BUILD_NUMBER=11

elif [ "$(ps -p 1 -o comm=)" = "systemd" ] || [ "$(ps -p 1 -o comm=)" = "init" ]; then
    ENV_TYPE="HOST"
    WORKSPACE="/home/m51/mine/t51/devops/setup/jenkins/workspace"
    DEVOPS_REPO="ssh://git@gitea.mariomv-local.org:222/mario1/t51DevOps.git"
    BUILD_NUMBER="0.1-test"
fi

echo -e "\e[42m[INFO] Running in: $ENV_TYPE\e[0m"


WORKDIR_BUILD="$WORKSPACE/$BUILD_NUMBER"


if [ -z "$WORKSPACE" ]; then
  echo "[ERROR] Variable WORKSPACE not found, The path to the devops workdir is required."
  exit 1
fi

if [ -z "$BUILD_NUMBER" ]; then
  echo "[ERROR] Variable BUILD_NUMBER not found, The incremental number of builds is requiered."
  exit 1
fi

if [ -z "$BACK_NAME" ]; then
  echo "Variable BACK_NAME not found, Image name to build is required" 
  exit 1
fi

if [ -z "$WORKDIR_BUILD" ]; then
  echo "Variable WORKDIR_BUILD not found, Path to directory where is the docker-compose.yml is requiered"
  exit 1
fi
echo "[INFO] Variables exist."


cd $WORKDIR_BUILD && echo "moved to $WORKDIR_BUILD"

set -x

docker image rm t51front:0.0.1 2> /dev/null | true

docker compose build front

docker images --format 'table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}' | grep -i $FRONT_NAME

set +x
