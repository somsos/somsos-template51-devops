#!/bin/bash
set -e
#set -x


if [ -z "$FRONT_REPO" ]; then
    echo "[ERROR] Variable FRONT_REPO not found."
    exit 1
fi

function download_front_repo {
    if [ -z "$1" ]; then
        echo "[ERROR] The directory to put the frontend repo content is required."
        exit 1
    fi

    
    mkdir -p $1
    rm -rf $1/*
    # "depth=2" because perhaps is to do a rollback
    git clone --quiet --depth=2 --single-branch --branch main "$FRONT_REPO" "$1" \
    && echo "[INFO] Front repo cloned."
    CURRENT_COMMIT_MESSAGE=$(git -C $1 log --oneline -n1)
    echo -e "\e[42m[INFO] $CURRENT_COMMIT_MESSAGE\e[0m"

    #Careful: on rollback if detects a change, will not do the push to del last commit
    if [ ! "$2" = "git" ]; then
        rm -rf $1/.git/
        rm -rf $1/docs/
    fi

}
