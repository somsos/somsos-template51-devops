#!/bin/bash

# DESCRIPTION
#   Stateless fuction
#
# $1: service name
# $2: service parameter
# $3: Log file
function deploy_container {
  stop_container_if_running $1

  echo -e "\nSetting up $1"
  echo -e "\n\ndocker compose up -d --no-recreate --no-deps $1 $2" >> $3

  docker compose up -d --no-recreate --no-deps $1 $2 &>> $3
  print_logs $? "Setting up $1"
}
