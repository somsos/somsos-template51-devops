#!/bin/bash
set -e
#set -x

function print_error_and_exit {
    echo "[ERROR] $1"
    exit 1
}

function create_temp_env_file {
    if [ -z "$1" ]; then
        print_error_and_exit "action name required on arg.1 func 'create_temp_env_file'"
    fi
    if [ -z "$2" ]; then
        print_error_and_exit "Layer name required on arg.2 func 'create_temp_env_file'"
    fi
    if [ -z "$3" ]; then
        print_error_and_exit "Temporal .env file full path required on arg.3 func 'create_temp_env_file'"
    fi
    if [ -z "$ENV_FILE" ]; then
        print_error_and_exit "Environment variable 'ENV_FILE' not set for func 'create_temp_env_file'"
    fi
    if [ ! -f "$ENV_FILE" ]; then
        print_error_and_exit "Secrets file '$ENV_FILE' not found for func 'create_temp_env_file'"
    fi
    
    local ACTION_NAME="$1"
    local LAYER_NAME="$2"
    local TEMP_ENV_FILE="$3"

    echo "[INFO] Getting secrets for action '$ACTION_NAME' and layer '$LAYER_NAME'"

    if [ "$ACTION_NAME" = "deploy" && "$LAYER_NAME" = "back" ]; then
        cat $ENV_FILE | grep -E "DB_SCHEMA|DB_USER|DB_PASS|DB_SERVER|DB_PORT" > "$TEMP_ENV_FILE"
    fi
    
}


function remove_temp_env_file {
    if [ -z "$1" ]; then
        print_error_and_exit "Temporal .env file full path required on arg.1 func 'remove_temp_env_file'"
    fi

    local TEMP_ENV_FILE="$1"

    if [ -f "$TEMP_ENV_FILE" ]; then
        rm "$TEMP_ENV_FILE"
        echo "[INFO] Temporal env file '$TEMP_ENV_FILE' removed successfully."
    else
        print_error_and_exit "Temporal env file '$TEMP_ENV_FILE' not found."
    fi
}