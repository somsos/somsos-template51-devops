#!/bin/bash
set -e
#set -x # debug mode

# Delete dangling images if LAYER is equal to 'delete-dangling'.
if [ -z "$1" ]; then
    echo "[ERROR] File argument LAYER (\$1) required: 'delete-dangling' or 'back' or 'front'"
    exit 1
fi

LAYER="$1"

if [ "$1" == "delete-dangling" ]; then
    DANGLING_IMAGES=$(docker images -f dangling=true -q)
    if [ -n "$DANGLING_IMAGES" ]; then
        echo "[INFO] Deleting dangling images..."
        echo "$DANGLING_IMAGES" | xargs docker rmi
        echo "[INFO] Dangling images deleted successfully."
    else
        echo -e "\033[38;5;27;48;5;231m[INFO] No dangling images to delete. \033[0m"
    fi
fi
