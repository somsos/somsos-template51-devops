#!/bin/bash
set -e

if [ -z "$WORKSPACE" ]; then
    echo "[ERROR] Variable \$WORKSPACE not found, The path to the devops workdir is required."
    exit 1
fi

if [ -z "$BUILD_NUMBER" ]; then
    echo "[ERROR] Variable \$BUILD_NUMBER not found, The incremental number of builds is requiered."
    exit 1
fi

function get_repo_dir {
    BUILD_DIR="$WORKSPACE/$BUILD_NUMBER"
    echo $BUILD_DIR
}