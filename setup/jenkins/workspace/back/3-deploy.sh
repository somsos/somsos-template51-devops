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
  WORKDIR_BACK="/home/m51/mine/t51/devops/setup/jenkins/workspace/back"
  BUILD_NUMBER="0.2"
  BACK_NAME="t51back"
else
  echo "[INFO] Running inside Jenkins, because var JOB_NAME exists."
fi

TIMEOUT_SEC="300"
WORKDIR_BUILD="$WORKDIR_BACK/$BUILD_NUMBER"


if [ -z "$WORKDIR_BACK" ]; then
  echo "[ERROR] Variable WORKDIR_BACK not found, The path to the devops workdir is required."
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


docker compose stop back


docker compose up -d --no-recreate --wait-timeout $TIMEOUT_SEC back

set +x


MESSAGE_APP_STARTED="Started AdapterApplication in"
START_TIME="$(date -u +%s)"
docker logs -f $BACK_NAME | while read line; do
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
      # IMPORTANT: 'break' here only exits the loop, 
      # but in a pipe, the loop runs in a subshell.
      exit 0 
      ;;
  esac
done

echo "[SUCCESS] Backend deployed."
