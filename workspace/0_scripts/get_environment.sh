#!/bin/bash
set -e
#set -x


# DESCRIPTION
#   Gets the name of the current environment running.
# RETURNS:
#   "JENKINS"         : It means it's running in a Jenkins pipeline
#   "CONTAINER_SHELL" : It means it's running in a docker container,
#   "HOST"            : It's running in a host.

function get_environment {
    RESP="none"
    if [ -n "$JENKINS_URL" ]; then
        RESP="JENKINS"
    elif [ -f /.dockerenv ]; then
        RESP="CONTAINER_SHELL"
    elif [ "$(ps -p 1 -o comm=)" = "systemd" ] || [ "$(ps -p 1 -o comm=)" = "init" ]; then
        RESP="HOST"
    fi

    if [[ "$RESP" == "none" ]]; then
        set -x && echo "[ERROR] Unknown environment." && set +x
        exit 1
    fi

    echo $RESP
}

