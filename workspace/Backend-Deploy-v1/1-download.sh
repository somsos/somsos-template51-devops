#!/bin/bash
set -e

################## Download and preparatives ##################
# JOB_NAME       # It's created in pipeline runtime by Jenkins
# WORKDIR_BACK   # in pipeline, this var is declared in docker-compose-devops,yml
# BUILD_NUMBER   # in pipeline, this var is declared by jenkins in runtime
# DEVOPS_REPO    # in pipeline, this var is declared in .env file
# BACK_REPO      # in pipeline, this var is declared in .env file


if [ -z "$JOB_NAME" ]; then
  echo "[INFO] Variable JOB_NAME does not exist, running the script out of jenkins, setting test variables"
  WORKDIR_BACK="/home/m51/mine/t51/devops/setup/jenkins/workspace/Backend-Deploy-v1"
  BUILD_NUMBER="0.2"
  DEVOPS_REPO="ssh://git@gitea.mariomv-local.org:222/mario1/t51DevOps.git"
  BACK_REPO="ssh://git@gitea.mariomv-local.org:222/mario1/t51Back.git"
else
  echo "[INFO] Running inside Jenkins, because var JOB_NAME exists."
fi

BUILD_DIR="$WORKSPACE/$BUILD_NUMBER"
BUILD_DIR_BACK="$BUILD_DIR/app/back/source"

if [ -z "$WORKSPACE" ]; then
  echo "[ERROR] Variable \$WORKSPACE not found, The path to the devops workdir is required."
  exit 1
fi

if [ -z "$BUILD_NUMBER" ]; then
  echo "[ERROR] Variable \$BUILD_NUMBER not found, The incremental number of builds is requiered."
  exit 1
fi

if [ -z "$DEVOPS_REPO" ]; then
  echo "[ERROR] Variable \$DEVOPS_REPO not found, The URL to the devops repository is required."
  exit 1
fi

if [ -z "$BACK_REPO" ]; then
  echo "[ERROR] Variable \$BACK_REPO not found, The URL to the backend repository is required."
  exit 1
fi


rm -fr $BUILD_DIR
git clone --quiet --depth=1 --single-branch --branch main "$DEVOPS_REPO" "$BUILD_DIR" \
  && echo "[INFO] Devops repo cloned"
git -C $BUILD_DIR log --oneline -n1
sleep 3

# Removing inecesary folders and files in app
rm -rf $BUILD_DIR/.git/
rm -rf $BUILD_DIR/setup/
rm -rf $BUILD_DIR/docs/
rm -rf $BUILD_DIR/README.md
rm -rf $BUILD_DIR/.gitignore

rm -rf $BUILD_DIR/app/db/
rm -rf $BUILD_DIR/app/front/
rm -rf $BUILD_DIR/app/utils/
echo "[INFO] Removed inecesary files in devops project for Back deploy."


# Remove line because is not requiered for the maven build and is going to fail if docker copose look for it.
DOCKER_COMPOSE_FILE="$BUILD_DIR/docker-compose.yml"
DOCKER_COMPOSE_FILE_temp="$BUILD_DIR/docker-compose.temp.yml" # Don't know why but I need the temp file
touch $DOCKER_COMPOSE_FILE_temp
cat $DOCKER_COMPOSE_FILE | grep -v setup/docker-compose >> $DOCKER_COMPOSE_FILE_temp \
  && echo "[INFO] dependency in docker-compose.yml removed."
rm $DOCKER_COMPOSE_FILE
mv $DOCKER_COMPOSE_FILE_temp $DOCKER_COMPOSE_FILE


# Clone the back repo
mkdir -p $BUILD_DIR_BACK
rm -rf "$BUILD_DIR_BACK/*"   # between quotes because the last part is confused by groovy as a comment
git clone --quiet --depth=1 --single-branch --branch main "$BACK_REPO" "$BUILD_DIR_BACK" \
  && echo "[INFO] Back repo cloned."
git -C $BUILD_DIR_BACK log --oneline -n1
sleep 3
rm -rf $BUILD_DIR_BACK/.git/



echo "[SUCCESS] Cloning and preparings done."
