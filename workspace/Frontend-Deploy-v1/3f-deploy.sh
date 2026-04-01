#!/bin/bash
set -e
set -x # show executed lines
################## FRONTEND: Deploy ##################
# JOB_NAME       # It's created in pipeline runtime by Jenkins

if [ -n "$JENKINS_URL" ]; then
    ENV_TYPE="JENKINS"
    
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




TIMEOUT_SEC="300"

WORKDIR_BUILD="$WORKSPACE/$BUILD_NUMBER"


if [ -z "$WORKSPACE" ]; then
  echo "[ERROR] Variable WORKSPACE not found, The path to the devops workdir is required."
  exit 1
fi

if [ -z "$BUILD_NUMBER" ]; then
  echo "[ERROR] Variable BUILD_NUMBER not found, The incremental number of builds is requiered."
  exit 1
fi

if [ -z "$TIMEOUT_SEC" ]; then
  echo "Variable TIMEOUT_SEC not found, Timeout in seconds to deploy service is required."
  exit 1
fi

if [ -z "$WORKDIR_BUILD" ]; then
  echo "Variable WORKDIR_BUILD not found, Path to directory where is the docker-compose.yml is requiered"
  exit 1
fi


cd $WORKDIR_BUILD


docker compose stop front


docker compose up -d --no-recreate --wait-timeout $TIMEOUT_SEC front

set +x


MESSAGE_APP_STARTED="Configuration complete; ready for start up"
START_TIME="$(date -u +%s)"
docker logs -f $FRONT_NAME | while read line; do
  echo "$line"

  CURRENT_TIME="$(date -u +%s)"
  ELAPSED_SECONDS=$((CURRENT_TIME - START_TIME))

  if [ $ELAPSED_SECONDS -gt $TIMEOUT_SEC ]; then
    echo "timeout of ${TIMEOUT_SEC}sec reached."
    exit 1
  fi

  case "$line" in
    *"$MESSAGE_APP_STARTED"* )
      echo "deploy success"
      exit 0 
      ;;
  esac
done

echo "[SUCCESS] FrontEnd deployed."
