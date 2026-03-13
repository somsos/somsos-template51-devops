#!/bin/bash

THIS_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
SCRIPTS_PATH="$THIS_PATH/../0_scripts/stateless_functions"

source $SCRIPTS_PATH/validate_exists_variable.sh
source $SCRIPTS_PATH/build_image.sh
source $SCRIPTS_PATH/deploy_container.sh 
source $SCRIPTS_PATH/start_container_if_not_running.sh
source $SCRIPTS_PATH/clone_repo.sh
source $SCRIPTS_PATH/print_logs.sh
source $SCRIPTS_PATH/stop_container_if_running.sh


stop_container_if_running "some_container_name" "$THIS_PATH/log.log"


