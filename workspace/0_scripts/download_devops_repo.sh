#!/bin/bash
set -e
# set -x
source "../0_scripts/get_commit_message.sh" # it looks for the file from it's being executed

# INPUT
#    $2 : 
#    $3 : app directory to keep required
function download_devops_repo {
    
    if [ -z "$1" ]; then
        echo "[ERROR] DevOps Repository URL, not found"
    fi

    if [ -z "$2" ]; then
        echo "[ERROR] Directory where to download the front repo, not found"
    fi

    if [[ "$3" != "back" && "$3" != "front"  && "$3" != "docker-commands" ]]; then
        echo "[ERROR] Required service name to deploy in argument 4 of function deploy"
        exit 1
    fi

    rm -fr $2
    mkdir $2
    git clone --quiet --depth=1 --single-branch --branch main "$1" "$2" \
    && echo "[INFO] Devops repo cloned"
    
    CURRENT_COMMIT_MESSAGE=$(get_commit_message $2)
    echo -e "\e[42m[INFO] $CURRENT_COMMIT_MESSAGE\e[0m"

    # Removing unnecessary folders and files in app
    rm -rf $2/.git/
    rm -rf $2/docs/
    rm -rf $2/README.md
    rm -rf $2/.gitignore

    # Delete all setup folder except for docker-compose file
    mv $2/setup/docker-compose-devops.yml $2/docker-compose-devops.yml
    rm -rf $2/setup/
    mkdir $2/setup/
    mv $2/docker-compose-devops.yml $2/setup
    

    if [ "$3" = "back" ]; then
        rm -rf $2/app/db/
        rm -rf $2/app/front/
        rm -rf $2/app/utils/

        # get sure front folder is empty
        # ToDo: Avoid using the app dir hardcoded
        rm -rf $2/app/back/source
        mkdir $2/app/back/source
    fi
    
    if [ "$3" = "front" ]; then
        rm -rf $2/app/db/
        rm -rf $2/app/back/
        rm -rf $2/app/utils/

        # ToDo: Avoid using the app dir hardcoded
        # get sure front folder is empty
        rm -rf $2/app/front/source
        mkdir $2/app/front/source
    fi
    

    if [ "$3" = "docker-commands" ]; then
        rm -rf $WORKDIR_BUILD/.git/
        rm -rf $WORKDIR_BUILD/docs/
        rm -rf $WORKDIR_BUILD/README.md
        rm -rf $WORKDIR_BUILD/.gitignore

        rm -rf $WORKDIR_BUILD/app/db/
        rm -rf $WORKDIR_BUILD/app/back/
        rm -rf $WORKDIR_BUILD/app/front/
        rm -rf $WORKDIR_BUILD/app/utils/

        rm -rf $WORKDIR_BUILD/setup/gitea
        rm -rf $WORKDIR_BUILD/setup/gitea
        rm -rf $WORKDIR_BUILD/setup/jenkins
        rm -rf $WORKDIR_BUILD/setup/secrets
        rm -rf $WORKDIR_BUILD/setup/shared

        rm -rf $WORKDIR_BUILD/workspace
        rm -rf $WORKDIR_BUILD/z_artt51
        # rm -rf $WORKDIR_BUILD/.env   # We name it
        rm -rf $WORKDIR_BUILD/.vscode
    fi
    
    
}


    