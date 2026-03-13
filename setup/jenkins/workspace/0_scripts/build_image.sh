#!/bin/bash

# DESCRIPTION
#   Stateless fuction
#
# INPUT
#   $1: Image name, ex: 't51Front', 't51Back', 't51DbMig'
#   $2: Version ex: '0.0.1'
#   $3: Log file
#
function build_image {
  echo -e "\nBuilding image: $1:$2"
  echo -e "\n\ndocker compose build $1" >> $3
  docker compose build $1 &>> $3
  print_logs $? "Building image: $1:$2"
}
