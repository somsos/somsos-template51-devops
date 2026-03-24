#!/bin/bash

# DESCRIPTION
#   Posible results: JENKINS, CONTAINER-SHELL, HOST
#   JENKINS: It means it's running in a Jenkins pipeline
#   CONTAINER-SHELL: It means it's running in a docker container,
#   HOST: It's running in a host.
# INPUT
#   $1


function based_on_environment_set_variables {
    if [ -n "$JENKINS_URL" ]; then
        ENV_TYPE="JENKINS"
        source /var/jenkins_home/workspace/.env
        
    elif [ -f /.dockerenv ]; then
        ENV_TYPE="CONTAINER-SHELL"
        source /var/jenkins_home/workspace/.env

    elif [ "$(ps -p 1 -o comm=)" = "systemd" ] || [ "$(ps -p 1 -o comm=)" = "init" ]; then
        ENV_TYPE="HOST"
        DEVOPS_WORKDIR="/home/m51/mine/t51/devops/setup/jenkins/workspace"
        DEVOPS_REPO="ssh://git@gitea.mariomv-local.org:222/mario1/t51DevOps.git"
        BUILD_NUMBER="0.1-test"
    fi
    
    echo $ENV_TYPE
}