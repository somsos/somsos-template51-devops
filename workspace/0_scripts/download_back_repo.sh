#!/bin/bash
set -e
#set -x

# INPUT
#    $1 : Repo URL
#    $2 : Directory where to download
#    $3 : keep .git directory use "git" only.

function download_back_repo {
    if [ -z "$1" ]; then
        echo "[ERROR] The URL to the backend repository is required."
        exit 1
    fi

    if [ -z "$2" ]; then
        echo "[ERROR] The directory to put the backend repository content is required."
        exit 1
    fi

    
    mkdir -p $2
    rm -rf $2/*
    # "depth=2" because perhaps is to do a rollback
    git clone --quiet --depth=2 --single-branch --branch main "$1" "$2" \
    && echo "[INFO] Back repo cloned."
    CURRENT_COMMIT_MESSAGE=$(git -C $2 log --oneline -n1)
    echo -e "\e[42m[INFO] $CURRENT_COMMIT_MESSAGE\e[0m"

    if [ ! "$3" = "git" ]; then
        rm -rf $2/.git/
    fi

    
    rm -rf $2/docs/
}
