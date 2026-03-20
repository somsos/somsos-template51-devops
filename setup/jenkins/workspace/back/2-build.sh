#!/bin/bash
set -e
set -x

################## Build Image ##################
# JOB_NAME         # It's created in pipeline runtime by Jenkins
# BACK_NAME        # It's in the .env file and passed by env vars in docker-compose.yml
# WORKDIR_BACK     # It's in in the docker-compose.yml in environment vars
# BUILD_NUMBER     # It's created in pipeline runtime by jenkins

if [ -z "$JOB_NAME" ]; then
  echo "[INFO] Variable JOB_NAME does not exist, running the script out of jenkins, setting test variables"
  BACK_NAME="t51back"       
  WORKDIR_BACK="/home/m51/mine/t51/devops/setup/jenkins/workspace/back"
  BUILD_NUMBER="0.2"
else
  echo "[INFO] Running inside Jenkins, because var JOB_NAME exists."
fi



WORKDIR_BUILD="$WORKDIR_BACK/$BUILD_NUMBER"


if [ -z "$WORKDIR_BACK" ]; then
  echo "[ERROR] Variable WORKDIR_BACK not found, The path to the devops workdir is required."
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

docker compose build back

docker images --format 'table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}' | grep -i $BACK_NAME

