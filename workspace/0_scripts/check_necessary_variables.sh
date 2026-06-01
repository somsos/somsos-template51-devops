#!/bin/bash
set -e
#set -x


# DESCRIPTION
#   Set necessary variables according to environment name got by the function get_environment.

function check_necessary_variables {
    if [ -z "$1" ]; then
        echo "[ERROR] Environment name required on arg.1 func 'check_necessary_variables'"
        exit 1
    fi
    
    
    if [ "$1" = "JENKINS"  ]; then
        echo "In pipeline"
        HOME="/var/jenkins_home"
    
    elif [ "$1" = "CONTAINER-SHELL"  ]; then
        echo "In container"
    
    elif [ "$1" = "HOST"  ]; then
        echo "In DOCKER HOST"

        source "../../.env"
        WORKSPACE="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
        BUILD_NUMBER=11
        MY_ENV=local
        MY_DOMAIN=mariomv-local.org
        ENV_FILE="/home/mario/mine/t51/.env"

        DB_MIG_REPO=ssh://git@localhost:222/${MY_USER}/${DB_MIG_NAME}.git
        BACK_REPO=ssh://git@localhost:222/${MY_USER}/${BACK_NAME}.git
        FRONT_REPO=ssh://git@localhost:222/${MY_USER}/${FRONT_NAME}.git
        DEVOPS_REPO=ssh://git@localhost:222/${MY_USER}/${DEVOPS_NAME}.git
    fi
}