#!/bin/bash
#set -e

# DESCRIPTION
#    Stateless function
#
# INPUT
#   $1: service name
#   $2: LogFile
function start_container_if_not_running {
  docker ps -a --format="{{.Names}}" | grep $1
  if [ $? -ne 0 ]; then
    echo -e "\nStarting $1 container"
    echo -e "\n\ndocker compose up --no-recreate --no-deps -d $1" >> $2
    docker compose up --no-recreate --no-deps -d $1 &>> $2
    echo -e "Starting $1 container Succeeded\n"
  fi
}