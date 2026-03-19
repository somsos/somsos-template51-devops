#!/bin/bash
set -e

################## Clonning and preparatives ##################
#WORKDIR_BACK   # in pipeline, this var is declared in docker-compose-devops,yml
#BUILD_NUMBER   # in pipeline, this var is declared by jenkins in runtime
#DEVOPS_REPO    # in pipeline, this var is declared in .env file
#BACK_REPO      # in pipeline, this var is declared in .env file

# Remove these variables when copy and peste to job.yaml
WORKDIR_BACK="/home/m51/mine/t51/devops/setup/jenkins/workspace/back"         # in pipeline, this var is declared in docker-compose-devops,yml
BUILD_NUMBER="0.2"                                                            # in pipeline, this var is declared by jenkins in runtime
DEVOPS_REPO="ssh://git@gitea.mariomv-local.org:222/mario1/t51DevOps.git"      # in pipeline, this var is declared in .env file
BACK_REPO="ssh://git@gitea.mariomv-local.org:222/mario1/t51Back.git"          # in pipeline, this var is declared in .env file

if [ -z "$WORKDIR_BACK" ]; then
  echo "[ERROR] Variable \$WORKDIR_BACK not found, The path to the devops workdir is required."
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



WORKDIR_BUILD="$WORKDIR_BACK/$BUILD_NUMBER"
rm -fr $WORKDIR_BUILD
git clone --quiet --depth=1 --single-branch --branch main "$DEVOPS_REPO" "$WORKDIR_BUILD" \
  && echo "[INFO] Devops repo cloned"


# Removing inecesary folders and files in app
rm -rf $WORKDIR_BUILD/.git/
rm -rf $WORKDIR_BUILD/setup/
rm -rf $WORKDIR_BUILD/docs/
rm -rf $WORKDIR_BUILD/README.md
rm -rf $WORKDIR_BUILD/.gitignore

rm -rf $WORKDIR_BUILD/app/db/
rm -rf $WORKDIR_BUILD/app/front/
rm -rf $WORKDIR_BUILD/app/utils/
echo "[INFO] Removed inecesary files in devops project for Back deploy."


# Remove line because is not requiered for the maven build and is going to fail if docker copose look for it.
LINE_TO_REMOVE=""
DOCKER_COMPOSE_FILE="$WORKDIR_BUILD/docker-compose.yml"
DOCKER_COMPOSE_FILE_temp="$WORKDIR_BUILD/docker-compose.temp.yml" # Don't know why but I need the temp file
touch $DOCKER_COMPOSE_FILE_temp
cat $DOCKER_COMPOSE_FILE | grep -v setup/docker-compose >> $DOCKER_COMPOSE_FILE_temp \
  && echo "[INFO] dependency in docker-compose.yml removed."
rm $DOCKER_COMPOSE_FILE
mv $DOCKER_COMPOSE_FILE_temp $DOCKER_COMPOSE_FILE


# Clone the back repo
WORKDIR_BACK_REPO="$WORKDIR_BUILD/app/back/source"
mkdir -p $WORKDIR_BACK_REPO
rm -rf "$WORKDIR_BACK_REPO/*"   # between quotes because the last part is confused by groovy as a comment
git clone --quiet --depth=1 --single-branch --branch main "$BACK_REPO" "$WORKDIR_BACK_REPO" \
  && echo "[INFO] Back repo cloned."

rm -rf $WORKDIR_BACK_REPO/.git/



echo "[SUCCESS] Cloning and preparings done."
