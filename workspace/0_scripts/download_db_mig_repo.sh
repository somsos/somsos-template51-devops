#!/bin/bash
set -e
# set -x
source "../0_scripts/get_commit_message.sh" # it looks for the file from it's being executed

# INPUT
#    $1 : DB-mig repository URL
#    $2 : Directory where to download the db-mig repo
function download_db_mig_repo {
    
    if [ -z "$1" ]; then
        echo "[ERROR] DB-mig repository URL, not found"
    fi

    if [ -z "$2" ]; then
        echo "[ERROR] Directory where to download the db-mig repo, not found"
    fi

    rm -fr $2
    mkdir $2
    git clone --quiet --depth=1 --single-branch --branch main "$1" "$2" \
    && echo "[INFO] DB-mig repo cloned"
    
    CURRENT_COMMIT_MESSAGE=$(get_commit_message $2)
    echo -e "\033[38;5;27;48;5;231m[INFO] DB-mig commit: $CURRENT_COMMIT_MESSAGE\033[0m"

    #Careful: on rollback if detects a change, will not do the push to del last commit
    if [ ! "$3" = "git" ]; then
        rm -rf $1/.git/
        rm -rf $1/docs/
    fi
    
}


    