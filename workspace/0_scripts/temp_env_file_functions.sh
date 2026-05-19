#!/bin/bash
set -e
#set -x

function print_error_and_exit {
    echo "[ERROR] $1"
    exit 1
}

function copy_env_file {
    if [ -z "$1" ]; then
        print_error_and_exit "Temporal .env file full path required on arg.3 func 'temp_env_file_functions.create_temp_env_file'"
    fi
    if [ -z "$ENV_FILE" ]; then
        print_error_and_exit "Environment variable 'ENV_FILE' not set for func 'temp_env_file_functions.create_temp_env_file'"
    fi
    if [ ! -f "$ENV_FILE" ]; then
        print_error_and_exit "Secrets file '$ENV_FILE' not found for func 'temp_env_file_functions.create_temp_env_file'"
    fi
    
    local TEMP_ENV_FILE="$1"

    cp -v $ENV_FILE $TEMP_ENV_FILE
}


function remove_copied_env_file {
    if [ -z "$1" ]; then
        print_error_and_exit "Temporal .env file full path required on arg.1 func 'remove_copied_env_file'"
    fi
    if [ ! -f "$1" ]; then 
        print_error_and_exit "Temporal env file '$1' not found for func 'remove_copied_env_file'"
    fi

    local TEMP_ENV_FILE="$1"

    echo "overwritten for security purposes" > "$TEMP_ENV_FILE"
}