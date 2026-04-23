#!/bin/bash
set -e
# set -x


# INPUT
#    $1 : Repo URL
#    $2 : Directory where to download
#    $3 : app directory to keep required
function download_devops_repo {
    rm -fr $2
    mkdir $2
    git clone --quiet --depth=1 --single-branch --branch main "$1" "$2" \
    && echo "[INFO] Devops repo cloned"
    CURRENT_COMMIT_MESSAGE=$(git -C $2 log --oneline -n1)
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
    fi
    
    if [ "$3" = "front" ]; then
        rm -rf $2/app/db/
        rm -rf $2/app/back/
        rm -rf $2/app/utils/    
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


    