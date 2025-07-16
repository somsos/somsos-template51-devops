#!/bin/bash
#set -e

set -a
source .env
set +a

# Request
TRIGGERING_REPO='template51-backend'

# Declaration


# names
DEVOPS_REPO='ssh://git@localhost:222/mario1/template51_devops.git'
DEVOPS_DIR="devops_temp"

BACK_NAME='testa'
BACK_REPO='ssh://git@localhost:222/mario1/TestA.git'

FRONT_NAME='testb'
FRONT_REPO='ssh://git@localhost:222/mario1/TestA.git'

DATE="$(date +"%Y-%m-%d_%H:%M:%S")"
LOG_FILE="JenkinsScript-$DATE.log"


#commands
CLONE_COMMAND="git clone  --depth=1 --single-branch --branch $BRANCH"


function print_logs {
  echo "aaaa $1"
  if [ $1 -ne 0 ]; then
    echo -e "$2 FAILED\n"
    cat $LOG_FILE
    echo -e "\n"
    remove_files
    exit $1
  fi
  echo -e "$2 Succeeded"
}

function remove_files {
  rm -rf ./$BACK_NAME

  rm -rf ./$DEVOPS_DIR

}

# Executions

echo "ENVIRONMENT: $BRANCH"

eval "$(ssh-agent -s)"

echo "$CLONE_COMMAND $DEVOPS_REPO $DEVOPS_DIR" &>> $LOG_FILE
echo -e "\n cloning $DEVOPS_DIR"
$CLONE_COMMAND $DEVOPS_REPO $DEVOPS_DIR &>> $LOG_FILE 
print_logs $? "Cloning $DEVOPS_DIR"

cd $DEVOPS_DIR

if [ "$TRIGGERING_REPO" == "template51-backend" ]; then


  echo -e "\nCloning $BACK_NAME"
  $CLONE_COMMAND $BACK_REPO $BACK_NAME &>> $LOG_FILE 
  print_logs $? "Cloning $BACK_NAME"


  echo -e "\nBuilding image: $BACK_NAME:$VERSION"
  docker compose build aa$BACK_NAME &>> $LOG_FILE 
  print_logs $? "Building image: $BACK_NAME:$VERSION"


  echo -e "\nSetting up $BACK_NAME"
  docker compose up -d $BACK_NAME &>> $LOG_FILE 
  print_logs $? "Setting up $BACK_NAME"
  
  echo -e "\nRemoving folder $BACK_NAME"
  
  
elif [ "$TRIGGERING_REPO" == "template51-frontend" ]; then
  
  $CLONE_COMMAND $FRONT_FOLDER

  echo "LATER"
  exit 1


  
else 
  echo "unknown"
fi

remove_files