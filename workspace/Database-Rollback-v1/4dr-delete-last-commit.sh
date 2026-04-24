#!/bin/bash
set -e
set -x

source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
source "../0_scripts/check_necessary_variables.sh"
check_necessary_variables "$ENV"


source "../0_scripts/get_repo_dir.sh"
REPO_DIR=$(get_repo_dir)
DB_REPO_DIR="$REPO_DIR/app/db/source"
echo "[INFO] REPO_DIR: $REPO_DIR"
echo "[INFO] DB_DIR: $DB_REPO_DIR"


USED_PATH=$(git -C $DB_REPO_DIR rev-parse --show-toplevel)
if [[ ! "$USED_PATH" == *"/db/"* ]]; then
    echo "[ERROR] USED_PATH seems incorrect check path. CAUTION: if the path is bad might revert an upper repo"
    echo "[WARN] repo path to delete last commit: $USED_PATH"
    exit 1;
fi

echo "[INFO] [START-cd5mk6lo0] Deleting last commit in repository."
set -x
git -C $DB_REPO_DIR push --force-with-lease origin +main^1:main
set +x
echo "[INFO] [END---cd5mk6lo0] Deleting last commit in repository."

