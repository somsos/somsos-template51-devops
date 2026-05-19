#!/bin/bash
set -e
#set -x # debug mode

if [ -z "$1" ]; then
    echo "[ERROR] File argument IMAGE_IDS (\$1) required with a list of images IDs space separated (e.g., 'abc 123 def')."
    exit 1
fi

IMAGE_IDS="$1"

docker rmi -f $IMAGE_IDS

