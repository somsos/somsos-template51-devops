#!/bin/bash
#set -e

set -a
source ../.env
set +a

# Request
TRIGGERING_REPO='template51-backend'

# Declaration
DATE="$(date +"%Y-%m-%d_%H.%M.%S")"

# names

DEVOPS_DIR="devops_$DATE"
LOG_FILE="JenkinsScript-$DATE.log"


#commands
CLONE_COMMAND="git clone  --depth=1 --single-branch --branch $BRANCH"


function print_logs {
  if [ $1 -ne 0 ]; then
    echo -e "$2 FAILED\n=========Error logs start============="
    cat $LOG_FILE
    echo -e "=========Error logs finish=============\n"
    post_process
    exit $1
  fi
  echo -e "$2 Succeeded"
}

function post_process {
  #rm -rf ./$BACK_SERVICE_NAME 1> /dev/null && echo "deleted $BACK_SERVICE_NAME"
  #rm -rf ./$FRONT_SERVICE_NAME 1> /dev/null && echo "deleted $FRONT_SERVICE_NAME"
  #rm -rf ./$DEVOPS_DIR 1> /dev/null && echo "deleted $DEVOPS_DIR"
  mv $LOG_FILE $DEVOPS_DIR/logs.log
  echo "END";
}

function clone_repo {
  echo -e "\nCloning ${2#*/}"
  echo "$CLONE_COMMAND $1 $2" >> $LOG_FILE
  $CLONE_COMMAND $1 $2 &>> $LOG_FILE
  echo -e "\n\n" >> $LOG_FILE
  print_logs $? "Cloning ${2#*/}"
}

function build_image {
  echo -e "\nBuilding image: $1:$VERSION"
  echo -e "\n\ndocker compose -f $DEVOPS_DIR/docker-compose.yml build $1" >> $LOG_FILE 
  docker compose -f $DEVOPS_DIR/docker-compose.yml build $1 &>> $LOG_FILE 
  print_logs $? "Building image: $1:$VERSION"
}



# $1: service name
function stop_container_if_running {
  docker ps -a --format="{{.Names}}" | grep $1
  if [ $? -eq 0 ]; then
    echo -e "\nStopping $1 container"
    echo -e "\n\ndocker compose -f $DEVOPS_DIR/docker-compose.yml down $1" >> $LOG_FILE
    docker compose -f $DEVOPS_DIR/docker-compose.yml down $1 &>> $LOG_FILE
    echo -e "Stopping $1 container Succeeded\n"
  fi
}



# $1: service name
function start_container_if_not_running {
  docker ps -a --format="{{.Names}}" | grep $1
  if [ $? -ne 0 ]; then
    echo -e "\nStarting $1 container"
    echo -e "\n\ndocker compose -f $DEVOPS_DIR/docker-compose.yml up -d $1" >> $LOG_FILE
    docker compose -f $DEVOPS_DIR/docker-compose.yml up -d $1 &>> $LOG_FILE
    echo -e "Starting $1 container Succeeded\n"
  fi
}


# $1: service name
function setup_container {
  stop_container_if_running $1

  echo -e "\nSetting up $1"
  echo -e "\n\ndocker compose -f $DEVOPS_DIR/docker-compose.yml up -d $1" >> $LOG_FILE  

  docker compose -f $DEVOPS_DIR/docker-compose.yml up -d $1 &>> $LOG_FILE 
  print_logs $? "Setting up $1"
}





# Executions

echo "ENVIRONMENT: $BRANCH"

eval "$(ssh-agent -s)"

clone_repo $DEVOPS_REPO $DEVOPS_DIR

start_container_if_not_running $DB_SERVICE_NAME

if [ "$TRIGGERING_REPO" == "template51-backend" ]; then

  clone_repo $BACK_REPO $DEVOPS_DIR/$BACK_SERVICE_NAME

  build_image $BACK_SERVICE_NAME

  setup_container $BACK_SERVICE_NAME
  
elif [ "$TRIGGERING_REPO" == "template51-frontend" ]; then
  
  clone_repo $FRONT_REPO $DEVOPS_DIR/$FRONT_SERVICE_NAME

  build_image $FRONT_SERVICE_NAME

  setup_container $FRONT_SERVICE_NAME

else 
  echo "unknown repo"
  exit 1
fi

post_process