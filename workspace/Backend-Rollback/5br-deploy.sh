#!/bin/bash
set -e
#set -x

source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
if [ "$ENV" = "JENKINS"  ]; then
    echo "In pipeline"
elif [ "$ENV" = "CONTAINER-SHELL"  ]; then
    echo "In container"
elif [ "$ENV" = "HOST"  ]; then
    echo "In DOCKER HOST"
    source "../../.env"
    WORKSPACE="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
    BACK_REPO="ssh://git@gitea.mariomv-local.org:222/mario1/t51Back.git"
    DEVOPS_REPO="ssh://git@gitea.mariomv-local.org:222/mario1/t51DevOps.git"
    BUILD_NUMBER=10
fi


if [ -z "$WORKSPACE" ]; then
  echo "[ERROR] Variable WORKSPACE not found, The path to the devops workdir is required."
  exit 1
fi

if [ -z "$BUILD_NUMBER" ]; then
  echo "[ERROR] Variable BUILD_NUMBER not found, The incremental number of builds is requiered."
  exit 1
fi

BUILD_DIR="$WORKSPACE/$BUILD_NUMBER"


cd $BUILD_DIR
docker compose stop back


# Start deploy

TIMEOUT_SEC="300"

if [ -z "$TIMEOUT_SEC" ]; then
  echo "Variable TIMEOUT_SEC not found, Timeout in seconds to deploy service is required."
  exit 1
fi

if [ -z "$BACK_NAME" ]; then
  echo "Variable BACK_NAME not found."
  exit 1
fi

docker compose up -d --wait-timeout $TIMEOUT_SEC back


# Check deploy health
# CAUTION: duplicated code with backend deploy
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
      echo "[INFO] Deploy success"
      exit 0
      ;;

  esac
done

echo "[SUCCESS] Deploy pipeline End."

