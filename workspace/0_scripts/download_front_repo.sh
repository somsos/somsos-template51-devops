#!/bin/bash
set -e
#set -x

source "../0_scripts/get_commit_message.sh" # it looks for the file from it's being executed

function download_front_repo {
    if [ -z "$1" ]; then
        echo "[ERROR] Frontend repository URL required in function download_front_repo argument 2."
        exit 1
    fi
    
    if [ -z "$2" ]; then
        echo "[ERROR] The directory to put the frontend repo content is required."
        exit 1
    fi

    
    mkdir -p $1
    rm -rf $1/*
    # "depth=2" because perhaps is to do a rollback
    git clone --quiet --depth=2 --single-branch --branch main "$1" "$2" \
    && echo "[INFO] Front repo cloned."
    
    CURRENT_COMMIT_MESSAGE=$(get_commit_message $2)
    echo -e "\e[42m[INFO] $CURRENT_COMMIT_MESSAGE\e[0m"

    #Careful: on rollback if detects a change, will not do the push to del last commit
    if [ ! "$3" = "git" ]; then
        rm -rf $1/.git/
        rm -rf $1/docs/
    fi

}
