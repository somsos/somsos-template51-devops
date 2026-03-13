#!/bin/bash
#set -e

set -a
source .env
set +a



# $1: or TRIGGERING_REPO is the repository name that was pushed and 
# triggered the web-hook, that way know what project to build and deploy.
: "${1:?Variable 1 is not set, is .env file loaded?}"

echo -e "\n\nENVIRONMENT: $BRANCH"
echo "REPO: $1"

# Declaration

# names
LOG_FILE="./logs.log"

OPTION_A="template51_back"

OPTION_B="template51_front"

OPTION_C="template51_db"

















# Executions


start_container_if_not_running $DB_SERVICE_NAME

if [ $1 == $OPTION_A ]; then

  clone_repo $BACK_REPO $BACK_SERVICE_NAME

  build_image $BACK_SERVICE_NAME

  setup_container $BACK_SERVICE_NAME
  


elif [ $1 == $OPTION_B ]; then
  
  clone_repo $FRONT_REPO $FRONT_SERVICE_NAME

  build_image $FRONT_SERVICE_NAME

  setup_container $FRONT_SERVICE_NAME


elif [ $1 == $OPTION_C ]; then

  clone_repo $DB_MIGRATIONS_REPO $DB_MIGRATIONS_DIR

  build_image db_migrate

  # VERY IMPORTANT: DO NOT remove "--no-deps" to avoid recreating the db container again
  # which can erase the data.
  docker compose run --no-deps --rm db_migrate deploy &>> $LOG_FILE
  print_logs $? "Running DB migrations"


else 
  echo "unknown repo, expected: '$OPTION_A', '$OPTION_B' or '$OPTION_C', but was '$1'"
  exit 1
fi
