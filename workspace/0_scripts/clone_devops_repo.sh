#!/bin/bash

# DESCRIPTION
#   Stateless fuction
#   
#   
#
# INPUT
#   $1 URL of the repo
#   $2 directory where to put the repo
#

function clone_devops_repo {
    rm -fr $2
    git clone --quiet --depth=1 --single-branch --branch main "$1" "$2" \
    && echo -e "\e[42m[INFO] Devops repo cloned.\e[0m"
    git -C $2 log --oneline -n1
}







# ######## Remove incesesary things (CAUTION: Keep in sync with back & db_mig/1-download.sh
rm -rf $WORKDIR_BUILD/.git/
rm -rf $WORKDIR_BUILD/docs/
rm -rf $WORKDIR_BUILD/README.md
rm -rf $WORKDIR_BUILD/.gitignore

rm -rf $WORKDIR_BUILD/app/db/
rm -rf $WORKDIR_BUILD/app/back/
rm -rf $WORKDIR_BUILD/app/front/
rm -rf $WORKDIR_BUILD/app/utils/

echo -e "\e[42m[Success] downloaded and cleaned.\e[0m"