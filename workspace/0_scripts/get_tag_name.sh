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

    COMMIT_ID=$(git -C $1 log -1 --pretty=format:%h)
    if [ -z "$2" ]; then
        set -x && echo "[ERROR] Something when wrong getting the commit short hash in get_tag_name." && set +x
        exit 1
    fi
    
    IMAGE_TAG=${2}-${COMMIT_ID}
    
    echo $IMAGE_TAG
}