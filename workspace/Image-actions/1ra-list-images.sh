#!/bin/bash
set -e
#set -x # debug mode
set +x # Jenkins by default sets -x, we disable it for cleaner output.

function print_app_images {
    echo "■■■■■■■■■■■■■■■■■■■■■■■■■-$1-images-■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    docker images --format 'table {{.Repository}}:{{.Tag}}\t{{.ID}}\t{{.Size}}\t{{.CreatedAt}}' | grep $1 | grep -v "registry" | sort -k4,5
    echo -e "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■\n\n"
}

################# END OF FUNCTION DEFINITIONS #################




source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
source "../0_scripts/check_necessary_variables.sh"
check_necessary_variables "$ENV"

if [ -z "$MY_ENV" ]; then
    echo "[ERROR] Variable 'MY_ENV' is not set, it must be set in environment variables."
    exit 1
fi

LAYER="$1"
if [ "$LAYER" != "back" ] && [ "$LAYER" != "front" ] && [ "$LAYER" != "status" ]; then
    echo "[ERROR] File argument LAYER (\$1) required: 'back', 'front', or 'status'"
    exit 1
fi

if [ "$LAYER" == "back" ] || [ "$LAYER" == "front" ]; then
    print_app_images $LAYER
fi

if [ "$LAYER" == "status" ]; then

    echo "■■■■■■■■■■■■■■■■■■■■■■■■■-images-being-run-■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    docker ps --format '{{.Image}}' | sort | uniq
    echo -e "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■\n\n"
    
    print_app_images "back"

    print_app_images "front"

    echo "■■■■■■■■■■■■■■■■■■■■■■■■■-images-in-registry-■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    docker images --format 'table {{.Repository}}:{{.Tag}}\t{{.ID}}\t{{.Size}}\t{{.CreatedAt}}' | grep "registry." | grep -E "front|back" | sort -k4,5
    echo -e "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■\n\n"

    echo "■■■■■■■■■■■■■■■■■■■■■■■■■-other-images-■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    docker images --format 'table {{.Repository}}:{{.Tag}}\t{{.ID}}\t{{.Size}}\t{{.CreatedAt}}' | grep -vE "front|back" | sort -k4,5
    echo -e "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■\n\n"

    echo "■■■■■■■■■■■■■■■■■■■■■■■■■-dangling-images-■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    docker images -f dangling=true
    echo -e "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■\n\n"
fi
