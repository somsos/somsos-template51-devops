#!/bin/bash
set -e
#set -x

function back_build_image {
    if [ -z "$1" ]; then
        echo "[ERROR] The directory where the main docker-compose is required."
        exit 1
    fi

    if [ -z "$2" ]; then
        echo "[ERROR] Image tag required in back_build_image function."
        exit 1
    fi

    if [ -z "$BACK_NAME" ]; then
        set -x && echo "[ERROR] BACK_NAME not found, it must be gotten through docker-compose-devops.yml env variables"
        exit 1
    fi

    PATH_MDP=$1 # path Main Docker Compose
    IMAGE_BUILD_TAG=$2

    set -x
    
    # We create the image using the build tag fist and the tag it as latest
    # it seems confusing  but this way we overwrite the latest in an more
    # compressive time
    BACK_IMAGE=$IMAGE_BUILD_TAG docker compose -f $PATH_MDP/docker-compose.yml build back
    
    #in this case the value es he one in env variables of OS
    docker tag $IMAGE_BUILD_TAG $BACK_IMAGE 

    set +x

}

