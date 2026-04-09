#!/bin/bash
set -e

source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
if [ "$ENV" = "JENKINS"  ]; then
    echo "In pipeline"
elif [ "$ENV" = "CONTAINER-SHELL"  ]; then
    echo "In container"
elif [ "$ENV" = "HOST"  ]; then
    echo "In DOCKER HOST"
    source "../../.env"
    WORKSPACE="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
    BUILD_NUMBER=11
fi

source "../0_scripts/get_repo_dir.sh"
REPO_DIR=$(get_repo_dir)

FRONT_REPO_DIR="$REPO_DIR/app/front/source"
echo "[INFO] REPO_DIR      : $REPO_DIR"
echo "[INFO] FRONT_REPO_DIR : $FRONT_REPO_DIR"


git -C $FRONT_REPO_DIR log --oneline -n2 --format=%s > ./temp1.txt
TO_DELETE=$(head -n1 temp1.txt)
TO_RE_DEPLOY=$(tail -n1 temp1.txt)
rm ./temp1.txt

echo -e "\e[42m[INFO] TO_DELETE     : $TO_DELETE\e[0m"
echo -e "\e[42m[INFO] TO_RE_DEPLOY  : $TO_RE_DEPLOY\e[0m"

# Checking path
# CAUTION: It happened me that as the path was wrong the command did a revert
# in the wrong path

USED_PATH=$(git -C $FRONT_REPO_DIR rev-parse --show-toplevel)
if [[ ! "$USED_PATH" == *"/front/"* ]]; then
    echo "[ERROR] USED_PATH seems incorrect check path. CAUTION: if the path is bad might revert an upper repo"
    exit 1;
fi

echo "[INFO] Last commit backup created."
mv $FRONT_REPO_DIR $FRONT_REPO_DIR-backup

echo "[INFO] [START-1cg3oi7] Deleting last commit in repository."
set -x
git -C $FRONT_REPO_DIR-backup push --force-with-lease origin +main^1:main
set +x
echo "[INFO] [END---1cg3oi7 Deleting last commit in repository."
