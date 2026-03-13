#!/bin/bash

# DESCRIPTION
#    Stateless function

#   INPUT
#       $1: variable to check
#       $2: Message to show in case of error
function validate_exists_variable {
  if [ -z "$1" ]; then
        echo "[ERROR] $2" 
        exit 1
    fi
}

    

