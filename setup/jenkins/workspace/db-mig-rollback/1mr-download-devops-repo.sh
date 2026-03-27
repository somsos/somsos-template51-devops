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


WORKDIR_DOC="$DEVOPS_WORKDIR/db-mig-rollback"



# ######## Validate dependencies
if [ -z "$DEVOPS_WORKDIR" ]; then
  echo "[ERROR] Variable DEVOPS_WORKDIR not found, The path to the devops workdir is required."
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


if [ -z "$DbMIG_REPO" ]; then
  echo "[ERROR] Variable DbMIG_REPO not found, The URL to the database migrations project is required."
  exit 1
fi




WORKDIR_BUILD="$WORKDIR_DOC/$BUILD_NUMBER"
rm -fr $WORKDIR_BUILD
git clone --quiet --depth=1 --single-branch --branch main "$DEVOPS_REPO" "$WORKDIR_BUILD" \
  && echo -e "\e[42m[INFO] Devops repo cloned.\e[0m"
git -C $WORKDIR_BUILD log --oneline -n1



# ######## Remove unnecessary things (CAUTION: Keep in sync with back & db_mig/1-download.sh
rm -rf $WORKDIR_BUILD/.git/
rm -rf $WORKDIR_BUILD/docs/
rm -rf $WORKDIR_BUILD/z_*
rm -rf $WORKDIR_BUILD/README.md
rm -rf $WORKDIR_BUILD/.gitignore

rm -rf $WORKDIR_BUILD/setup/gitea
rm -rf $WORKDIR_BUILD/setup/jenkins
rm -rf $WORKDIR_BUILD/setup/secrets
rm -rf $WORKDIR_BUILD/setup/shared


# rm -rf $WORKDIR_BUILD/app/db/      # We keep this one
rm -rf $WORKDIR_BUILD/app/back/
rm -rf $WORKDIR_BUILD/app/front/
rm -rf $WORKDIR_BUILD/app/utils/

echo -e "\e[42m[Success] downloaded and cleaned.\e[0m"




# Clone the db-mig repo
REPO_DIR="$WORKDIR_BUILD/app/db/source"
mkdir -p $REPO_DIR
rm -rf $REPO_DIR/*   # between quotes because the last part is confused by groovy as a comment
git clone --quiet --depth=1 --single-branch --branch main "$DbMIG_REPO" "$REPO_DIR" \
  && echo "[INFO] db-mig repository cloned."
git -C $REPO_DIR log --oneline -n1
rm -rf $REPO_DIR/.git/
rm -rf $REPO_DIR/docs/
rm -rf $REPO_DIR/README*
sleep 3




echo "[SUCCESS] Cloning and preparations done."

