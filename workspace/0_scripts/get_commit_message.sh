#!/bin/bash
set -e
#set -x

function get_commit_message {
    if [ -d "$1"]; then
        set -x && echo "[ERROR] Path to repository to get its commit message required in function get_commit_message, current value '$1'" && set +x
        exit 1
    fi
    
    MSG=$(git -C $1 log --oneline -n1)
    if [[ -z "$MSG" || $MSG == "" ]]; then
        set -x && echo "[ERROR] something went wrong getting the commit message" && set +x
        exit 1
    fi

    echo $MSG
}
