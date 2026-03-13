#!/bin/bash

# DESCRIPTION
#   Stateless fuction
#
# INPUT
#   $1 repository ssh URI
#   $2 target directory
#   $X3X log file
function clone_repo {
  local CLONE_COMMAND="git clone  --depth=1 --single-branch --branch main "

  echo -e "\nCloning $2"
  echo "$CLONE_COMMAND $1 $2" # >> $3
  $CLONE_COMMAND $1 $2 # &>> $3
  echo -e "\n\n" # >> $3
}
