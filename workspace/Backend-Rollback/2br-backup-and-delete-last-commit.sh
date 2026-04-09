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
    BUILD_NUMBER=10
fi

source "../0_scripts/get_repo_dir.sh"
REPO_DIR=$(get_repo_dir)

BACK_REPO_DIR="$REPO_DIR/app/back/source"
echo "[INFO] REPO_DIR      : $REPO_DIR"
echo "[INFO] BACK_REPO_DIR : $BACK_REPO_DIR"


git -C $BACK_REPO_DIR log --oneline -n2 --format=%s > ./temp1.txt
TO_DELETE=$(head -n1 temp1.txt)
TO_RE_DEPLOY=$(tail -n1 temp1.txt)
rm ./temp1.txt

echo -e "\e[42m[INFO] TO_DELETE     : $TO_DELETE\e[0m"
echo -e "\e[42m[INFO] TO_RE_DEPLOY  : $TO_RE_DEPLOY\e[0m"

# Checking path
# CAUTION: It happened me that as the path was wrong the command did a revert
# in the wrong path

if [ -z "$BACK_REPO_DIR" ]; then
    echo "[ERROR] BACK_REPO_DIR variable empty"
    exit 1;
fi

if [[ ! "$BACK_REPO_DIR" == *"/back/"* ]]; then
    echo "[ERROR] BACK_REPO_DIR seems incorrect check path. CAUTION: if the path is bad might revert other repository in upper paths"
    exit 1;
fi

echo "[INFO] Last commit backup created."
mv $BACK_REPO_DIR $BACK_REPO_DIR-backup


echo "[INFO] [START-1xs3cd7] Deleting last commit in repository."
set -x
git -C $BACK_REPO_DIR-backup push --force-with-lease origin +main^1:main
set +x
echo "[INFO] [END---1xs3cd7] Deleting last commit in repository."
