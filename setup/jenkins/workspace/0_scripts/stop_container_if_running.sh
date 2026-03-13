#!/bin/bash


# DESCRIPTION
#    Stateless function

# $1: service name
# $2: log file
function stop_container_if_running {
  docker ps -a --format="{{.Names}}" | grep $1
  if [ $? -eq 0 ]; then
    echo -e "\nStopping $1 container"
    echo -e "\n\ndocker compose down $1" >> $2
    docker compose down $1 &>> $2
    echo -e "Stopping $1 container Succeeded\n"
  else
    echo -e "\nContainer $1 not running to stop it" &>> $2
  fi
}
