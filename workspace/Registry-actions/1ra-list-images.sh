#!/bin/bash
set -e
#set -x # debug mode

source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
source "../0_scripts/check_necessary_variables.sh"
check_necessary_variables "$ENV"

if [ -z "$MY_ENV" ]; then
    echo "[ERROR] Variable 'MY_ENV' is not set, it must be set in environment variables."
    exit 1
fi

LAYER="$1"
if [ "$LAYER" != "back" ] && [ "$LAYER" != "front" ]; then
    echo "[ERROR] File argument LAYER (\$1) required: 'back' or 'front'"
    exit 1
fi

docker images --format 'table {{.Repository}}:{{.Tag}}\t{{.ID}}\t{{.Size}}\t{{.CreatedAt}}' | grep "$LAYER" | sort -k4,5

