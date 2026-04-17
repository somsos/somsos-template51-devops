#!/bin/bash
set -e
set -x


################## Deploy ##################
#$JOB_NAME      # It's created in pipeline runtime by Jenkins
#BACK_NAME      # It's in the .env file and passed by env vars in docker-compose.yml
#WORKDIR_BACK   # It's in in the docker-compose.yml in environment vars
#BUILD_NUMBER   # It's created in pipeline runtime by Jenkins

if [ -z "$JOB_NAME" ]; then
  echo "[INFO] Variable JOB_NAME does not exist, running the script out of jenkins, setting test variables"
  WORKDIR_BACK="/home/m51/mine/t51/devops/setup/jenkins/workspace/Backend-Deploy-v1"
  BUILD_NUMBER="0.2"
  BACK_NAME="t51back"
else
  echo "[INFO] Running inside Jenkins, because var JOB_NAME exists."
fi

TIMEOUT_SEC="300"
BUILD_DIR="$WORKSPACE/$BUILD_NUMBER"


if [ -z "$WORKSPACE" ]; then
  echo "[ERROR] Variable WORKSPACE not found, The path to the devops workdir is required."
  exit 1
fi

if [ -z "$BUILD_NUMBER" ]; then
  echo "[ERROR] Variable BUILD_NUMBER not found, The incremental number of builds is requiered."
  exit 1
fi



source "../0_scripts/back_deploy.sh"
back_deploy $BUILD_DIR $TIMEOUT_SEC


source "../0_scripts/back_check_start_and_health.sh"

