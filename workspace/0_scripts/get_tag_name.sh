#!/bin/bash
set -e
#set -x


function get_tag_name {

    if [ -z "$1" ]; then
        set -x &&  echo "[ERROR] Repository path to get commit short hash required in get_tag_name function." && set +x
        exit 1
    fi

    if [ -z "$2" ]; then
        set -x &&  echo "[ERROR] BUILD_NUMBER value required in argument 2 of back_build function." && set +x
        exit 1
    fi

    if [ -z "$BACK_NAME" ]; then
        set -x && echo "[ERROR] BACK_NAME not found, it must be gotten through docker-compose-devops.yml env variables"
        exit 1
    fi

    if [ -z "$FRONT_NAME" ]; then
        set -x && echo "[ERROR] FRONT_NAME not found, it must be gotten through docker-compose-devops.yml env variables"
        exit 1
    fi

    if [[ "$3" != "back" && "$3" != "front" ]]; then
        set -x &&  echo "[ERROR] Required image for what service in get_tag_name function" && set +x
        exit 1
    fi

    if [ "$3" == "back" ] ; then
        BASE_NAME="$BACK_NAME"
    fi

    if [ "$3" == "front" ] ; then
        BASE_NAME="$FRONT_NAM"
    fi

    

    COMMIT_ID=$(git -C $1 log -1 --pretty=format:%h)
    if [ -z "$2" ]; then
        set -x && echo "[ERROR] Something when wrong getting the commit short hash in get_tag_name." && set +x
        exit 1
    fi

    if [ -z "$COMMIT_ID" ]; then
        set -x && echo "[ERROR] Something when wrong COMMIT_ID is empty." && set +x
    fi
    
    IMAGE_TAG="$BASE_NAME:$2-$COMMIT_ID"
    
    echo $IMAGE_TAG
}