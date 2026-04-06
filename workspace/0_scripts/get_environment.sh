#!/bin/bash

# DESCRIPTION
#   Posible results: JENKINS, CONTAINER-SHELL, HOST
#   JENKINS: It means it's running in a Jenkins pipeline
#   CONTAINER-SHELL: It means it's running in a docker container,
#   HOST: It's running in a host.
# INPUT
#   $1

function get_environment {
    if [ -n "$JENKINS_URL" ]; then
        echo "JENKINS"
        
    elif [ -f /.dockerenv ]; then
        echo "CONTAINER-SHELL"

    elif [ "$(ps -p 1 -o comm=)" = "systemd" ] || [ "$(ps -p 1 -o comm=)" = "init" ]; then
        echo "HOST"
        
    fi
}