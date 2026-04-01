#!/bin/bash
set -e
set -x # show executed lines


# ######## introduction
if [ -n "$JENKINS_URL" ]; then
    ENV_TYPE="JENKINS"
    source /var/jenkins_home/workspace/.env

elif [ -f /.dockerenv ]; then
    ENV_TYPE="CONTAINER-SHELL"
    source /var/jenkins_home/workspace/.env

elif [ "$(ps -p 1 -o comm=)" = "systemd" ] || [ "$(ps -p 1 -o comm=)" = "init" ]; then
    ENV_TYPE="HOST"
    WORKSPACE="/home/m51/mine/t51/devops/setup/jenkins/workspace"
    DEVOPS_REPO="ssh://git@gitea.mariomv-local.org:222/mario1/t51DevOps.git"
    BUILD_NUMBER="0.1-test"
fi

echo -e "\e[42m[INFO] Running in: $ENV_TYPE\e[0m"


WORKDIR_DOC="$WORKSPACE/$BUILD_NUMBER"



# ######## Validate dependencies
if [ -z "$WORKSPACE" ]; then
  echo "[ERROR] Variable WORKSPACE not found, The path to the devops workdir is required."
  exit 1
fi

if [ -z "$BUILD_NUMBER" ]; then
  echo "[ERROR] Variable BUILD_NUMBER not found, The incremental number of builds is required."
  exit 1
fi

if [ -z "$WORKDIR_DOC" ]; then
  echo "[ERROR] Variable WORKDIR_DOC not found, The path pipeline build workspace is required"
  exit 1
fi

if [ -z "$DEVOPS_REPO" ]; then
  echo "[ERROR] Variable DEVOPS_REPO not found, The URL to the devops project is required."
  exit 1
fi

if [ -z "$DB_MIG_REPO" ]; then
  echo "[ERROR] Variable DB_MIG_REPO not found, The URL to the database migrations project is required."
  exit 1
fi




WORKDIR_BUILD="$WORKSPACE/$BUILD_NUMBER"

rm -fr $WORKDIR_BUILD
git clone --quiet --depth=1 --single-branch --branch main "$DEVOPS_REPO" "$WORKDIR_BUILD" \
  && echo -e "\e[42m[INFO] Devops repo cloned.\e[0m"
git -C $WORKDIR_BUILD log --oneline -n1



# ######## Remove unnecessary things
# root directory
rm -rf $WORKDIR_BUILD/.git/
rm -rf $WORKDIR_BUILD/docs/
rm -rf $WORKDIR_BUILD/z_*
rm -rf $WORKDIR_BUILD/README.md
rm -rf $WORKDIR_BUILD/.gitignore

# setup directory
rm -rf $WORKDIR_BUILD/setup/gitea
rm -rf $WORKDIR_BUILD/setup/jenkins
rm -rf $WORKDIR_BUILD/setup/secrets
rm -rf $WORKDIR_BUILD/setup/shared

# app directory
# rm -rf $WORKDIR_BUILD/app/db/      # We keep this one
rm -rf $WORKDIR_BUILD/app/back/
rm -rf $WORKDIR_BUILD/app/front/
rm -rf $WORKDIR_BUILD/app/utils/

echo -e "\e[42m[Success] downloaded and cleaned.\e[0m"




# Clone the db-mig repo
REPO_DIR="$WORKDIR_BUILD/app/db/source"
mkdir -p $REPO_DIR
rm -rf $REPO_DIR/*   # between quotes because the last part is confused by groovy as a comment
git clone --quiet --depth=1 --single-branch --branch main "$DB_MIG_REPO" "$REPO_DIR" \
  && echo "[INFO] db-mig repository cloned."
git -C $REPO_DIR log --oneline -n1
rm -rf $REPO_DIR/.git/
rm -rf $REPO_DIR/docs/
rm -rf $REPO_DIR/README*
sleep 3




echo "[SUCCESS] Cloning and preparations done."

