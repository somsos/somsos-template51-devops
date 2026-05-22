#!/bin/bash
set -e
#set -x

source setup/install_functions.sh

check_dependencies
check_repository_state

create_env_file_and_load_it

download_save_and_load_image $IMAGE_JENKINS "IMAGE_JENKINS"
download_save_and_load_image $IMAGE_GITEA "IMAGE_GITEA"
download_save_and_load_image $IMAGE_JAVA "IMAGE_JAVA"
download_save_and_load_image $IMAGE_NODE "IMAGE_NODE"
download_save_and_load_image $IMAGE_NGINX "IMAGE_NGINX"
download_save_and_load_image $IMAGE_HTTPD "IMAGE_HTTPD"
download_save_and_load_image $DB_IMAGE "DB_IMAGE"
download_save_and_load_image $DB_MIG_IMAGE "DB_MIG_IMAGE"

create_ssh_keys
create_registry_auth

start_and_check_health_devops_service gitea
start_and_check_health_devops_service jenkins
start_and_check_health_devops_service registry
docker compose up -d reverse-proxy


# root access required to add entries to /etc/hosts file
add_domain_to_hosts_file $MY_DOMAIN
add_domain_to_hosts_file api.$MY_DOMAIN
add_domain_to_hosts_file gitea.$MY_DOMAIN
add_domain_to_hosts_file jenkins.$MY_DOMAIN
add_domain_to_hosts_file registry.$MY_DOMAIN


clone_repository $BACK_REPO ./app/back/source
clone_repository $DB_MIG_REPO ./app/db/source
clone_repository $FRONT_REPO ./app/front/source

start_app_database_service_and_install_schema

start_app_backend_service

start_app_frontend_service

echo "Installation completed successfully."


# example of running the install.sh script:
# bash ./install.sh <<EOF 
#   test
#   neey1-test.com
#   neey1
#   neey1p
#   neey1p
#   neey1@email.com
#   neey1token
#   neey1db
#   neey1
#   neey1p
# EOF