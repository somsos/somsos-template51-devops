#!/bin/bash
set -e

if [ -z "$WORKSPACE" ]; then
    set -x && echo "[ERROR] Variable \$WORKSPACE not found, The path to the devops workdir is required." && set +x
    exit 1
fi

if [ -z "$BUILD_NUMBER" ]; then
    set -x && echo "[ERROR] Variable \$BUILD_NUMBER not found, The incremental number of builds is requiered." && set +x
    exit 1
fi

function get_repo_dir {
    BUILD_DIR="$WORKSPACE/$BUILD_NUMBER"
    echo $BUILD_DIR
}

function get_app_dir {
    if [ -z "$1" ]; then
        set -x && echo "[ERROR] downloaded DevOps repo dir required in get_app_dir function" && set +x
        exit 1
    fi

    if [ "$2" = "db" ]; then
        echo "$1/app/db/source"
    fi

    if [ "$2" = "back" ]; then
        echo "$1/app/back/source"
    fi

    if [ "$2" = "front" ]; then
        echo "$1/app/front/source"
    fi
}


BACK_REPO_DIR="$REPO_DIR/app/back/source"