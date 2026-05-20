#!/bin/bash
set -e
#set -x

source setup/install_functions.sh

check_dependencies

create_env_file

download_save_and_load_images

create_ssh_keys

create_registry_auth

echo "Installation completed successfully. You can now run 'docker compose up' to start the services."
