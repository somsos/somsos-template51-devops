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

git -C $BACK_REPO_DIR reset HEAD^
git -C $BACK_REPO_DIR push local +main^1:main