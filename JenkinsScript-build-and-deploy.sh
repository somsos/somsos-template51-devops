#!/bin/bash
#set -e

set -a
source .env
set +a

: "${BRANCH:?Variable BRANCH is not set, is .env file loaded?}"

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


function print_logs {
  if [ $1 -ne 0 ]; then
    echo -e "$2 FAILED\n=========Error logs start============="
    cat $LOG_FILE
    echo -e "=========Error logs finish=============\n"
    exit $1
  fi
  echo -e "$2 Succeeded"
}

function clone_repo {
  local CLONE_COMMAND="git clone  --depth=1 --single-branch --branch $BRANCH"


  echo -e "\nCloning $2"
  echo "$CLONE_COMMAND $1 $2" >> $LOG_FILE
  $CLONE_COMMAND $1 $2 &>> $LOG_FILE
  echo -e "\n\n" >> $LOG_FILE
  print_logs $? "Cloning $2"
}




function build_image {
  echo -e "\nBuilding image: $1:$VERSION"
  echo -e "\n\ndocker compose build $1" >> $LOG_FILE 
  docker compose build $1 &>> $LOG_FILE 
  print_logs $? "Building image: $1:$VERSION"
}



# $1: service name
function stop_container_if_running {
  docker ps -a --format="{{.Names}}" | grep $1
  if [ $? -eq 0 ]; then
    echo -e "\nStopping $1 container"
    echo -e "\n\ndocker compose down $1" >> $LOG_FILE
    docker compose down $1 &>> $LOG_FILE
    echo -e "Stopping $1 container Succeeded\n"
  fi
}



# $1: service name
function start_container_if_not_running {
  docker ps -a --format="{{.Names}}" | grep $1
  if [ $? -ne 0 ]; then
    echo -e "\nStarting $1 container"
    echo -e "\n\ndocker compose up -d $1" >> $LOG_FILE
    docker compose up -d $1 &>> $LOG_FILE
    echo -e "Starting $1 container Succeeded\n"
  fi
}


# $1: service name
function setup_container {
  stop_container_if_running $1

  echo -e "\nSetting up $1"
  echo -e "\n\ndocker compose up -d $1" >> $LOG_FILE  

  docker compose up -d $1 &>> $LOG_FILE 
  print_logs $? "Setting up $1"
}





# Executions


start_container_if_not_running $DB_SERVICE_NAME

if [ "$1" == "$OPTION_A" ]; then

  clone_repo $BACK_REPO $BACK_SERVICE_NAME

  build_image $BACK_SERVICE_NAME

  setup_container $BACK_SERVICE_NAME
  
elif [ "$1" == "$OPTION_B" ]; then
  
  clone_repo $FRONT_REPO $FRONT_SERVICE_NAME

  build_image $FRONT_SERVICE_NAME

  setup_container $FRONT_SERVICE_NAME

else 
  echo "unknown repo"
  exit 1
fi
