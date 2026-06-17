#!/bin/bash
set -e
# set -x # for debugging.

# Note it's almost a copy peste of back_build_image.sh file, so maybe a change
# here is also required there

function build_image {
    if [ -z "$1" ]; then
        echo "[ERROR] The directory where the main docker-compose is required."
        exit 1
    fi

    if [ -z "$2" ]; then
        echo "[ERROR] Image tag required in back_build_image function."
        exit 1
    fi

    if [[ "$3" != "back" && "$3" != "front" ]]; then
         echo "[ERROR] Required image for what service in build_image function, in function build_image"
        exit 1
    fi

    if [ -z "$BACK_NAME" ]; then
        echo "[ERROR] BACK_NAME not found, it must be gotten through docker-compose-devops.yml env variables"
        exit 1
    fi

    if [ -z "$FRONT_NAME" ]; then
        echo "[ERROR] FRONT_NAME not found, it must be gotten through docker-compose-devops.yml env variables"
        exit 1
    fi

    if [ -z "$BACK_IMAGE" ]; then
        echo "[ERROR] BACK_IMAGE not found, it must be gotten through docker-compose-devops.yml env variables"
        exit 1
    fi

    if [ -z "$FRONT_IMAGE" ]; then
        echo "[ERROR] FRONT_IMAGE not found, it must be gotten through docker-compose-devops.yml env variables"
        exit 1
    fi


    PATH_MDP=$1 # path Main Docker Compose
    IMAGE_BUILD_TAG=$2

    if [ ! -f "$PATH_MDP/.env" ]; then
        echo "[ERROR] .env file not found in $PATH_MDP, it must be copied from the devops repo before building the image"
        exit 1
    fi
    if [ ! -f "$PATH_MDP/docker-compose.yml" ]; then
        echo "[ERROR] docker-compose.yml file not found in $PATH_MDP, it must be copied from the devops repo before building the image"
        exit 1
    fi

    
    # We create the image using the build tag fist and the tag it as latest
    # it seems confusing  but this way we overwrite the latest in an more
    # compressive time

    if [[ "$3" == "back" ]]; then
        set -x
        BACK_IMAGE=$IMAGE_BUILD_TAG docker compose -f $PATH_MDP/docker-compose.yml --progress plain build back
        docker tag $IMAGE_BUILD_TAG $BACK_IMAGE 
        set +x
    fi

    if [[ "$3" == "front" ]]; then
        set -x
        # docker compose -f $PATH_MDP/docker-compose.yml config front # for debugging
        FRONT_IMAGE=$IMAGE_BUILD_TAG docker compose -f $PATH_MDP/docker-compose.yml --progress plain build front
        docker tag $IMAGE_BUILD_TAG $FRONT_IMAGE 
        set +x
    fi
    
    
    

    

}

