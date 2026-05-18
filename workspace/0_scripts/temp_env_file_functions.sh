#!/bin/bash
set -e
#set -x

function print_error_and_exit {
    echo "[ERROR] $1"
    exit 1
}

function copy_env_file {
    if [ -z "$1" ]; then
        print_error_and_exit "action name required on arg.1 func 'temp_env_file_functions.create_temp_env_file'"
    fi
    if [ -z "$2" ]; then
        print_error_and_exit "Temporal .env file full path required on arg.3 func 'temp_env_file_functions.create_temp_env_file'"
    fi
    if [ -z "$3" ]; then
        print_error_and_exit "Layer name required on arg.2 func 'temp_env_file_functions.create_temp_env_file'"
    fi
    if [ -z "$ENV_FILE" ]; then
        print_error_and_exit "Environment variable 'ENV_FILE' not set for func 'temp_env_file_functions.create_temp_env_file'"
    fi
    if [ ! -f "$ENV_FILE" ]; then
        print_error_and_exit "Secrets file '$ENV_FILE' not found for func 'temp_env_file_functions.create_temp_env_file'"
    fi
    
    local ACTION_NAME="$1"
    local LAYER_NAME="$3"
    local TEMP_ENV_FILE="$2"

    echo "[INFO] Getting secrets for action '$ACTION_NAME' and layer '$LAYER_NAME'"

    if [[ "$ACTION_NAME" = "deploy" && "$LAYER_NAME" = "back" ]]; then
        cp $ENV_FILE $TEMP_ENV_FILE
    fi
    
}


function remove_copied_env_file {
    if [ -z "$1" ]; then
        print_error_and_exit "Temporal .env file full path required on arg.1 func 'remove_copied_env_file'"
    fi
    if [ ! -f "$TEMP_ENV_FILE" ]; then 
        print_error_and_exit "Temporal env file '$TEMP_ENV_FILE' not found for func 'remove_copied_env_file'"
    fi

    local TEMP_ENV_FILE="$1"

    rm -v "$TEMP_ENV_FILE"
}