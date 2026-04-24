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
    
    elif [ "$1" = "CONTAINER-SHELL"  ]; then
        echo "In container"
    
    elif [ "$1" = "HOST"  ]; then
        echo "In DOCKER HOST"

        source "../../.env"
        WORKSPACE="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
        BUILD_NUMBER=11
    fi
}