#!/bin/bash
set -e
#set -x

# this file is thinked to be executed from install.sh, at root of the project.


NEW_ENV_FILE=".env.test"
KEY_DIR="./setup/secrets"

function check_dependencies {
    if ! command -v docker &> /dev/null; then
        echo "[ERROR] Docker is not installed. Please install Docker and try again."
        exit 1
    fi
    if ! docker compose version &> /dev/null; then
        echo "[ERROR] Docker Compose is not installed. Please install Docker Compose and try again."
        exit 1
    fi
    if ! command -v ssh-keygen &> /dev/null; then
        echo "[ERROR] ssh-keygen is not installed. Please install the necessary package (e.g., openssh-client) and try again."
        exit 1
    fi
}

function is_env_file_loaded_or_exit_with_error {
    # check is already loaded
    if [ ! -f $NEW_ENV_FILE ]; then
        echo "[ERROR] $NEW_ENV_FILE file not found. Please create it with the necessary variables."
        exit 1
    fi

    if [ -z "$MY_ENV" ] || [ -z "$MY_DOMAIN" ] || [ -z "$MY_USER" ] || [ -z "$MY_PASS" ] || [ -z "$MY_EMAIL" ] || [ -z "$SHARED_TOKEN" ]; then
        echo "[ERROR] One or more required environment variables are not set. are you sure you have loaded the environment file?"
        exit 1
    fi    
}



function get_docker_gid {
    if ! command -v getent &> /dev/null; then
        set -x && echo "[ERROR] getent command is not available. Please install the necessary package (e.g., libc-bin) and try again." && set +x
        exit 1
    fi
    DOCKER_GID=$(getent group docker | cut -d: -f3)
    if [ -z "$DOCKER_GID" ]; then
        set -x && echo "[ERROR] Docker group not found. Please make sure Docker is installed and the docker group exists." && set +x
        exit 1
    fi
    echo "$DOCKER_GID"
}



function create_env_file {
    if [ ! -f .env.example ]; then
        echo "[ERROR] .env.example file not found. Please create it with the necessary variables."
        exit 1
    fi

    if [ ! -f $NEW_ENV_FILE ]; then
        cp .env.example $NEW_ENV_FILE
        echo "Created $NEW_ENV_FILE file from .env.example. Please edit the $NEW_ENV_FILE file with your configuration."
    else
        echo "[ERROR] $NEW_ENV_FILE file already exists. Skipping creation."
        exit 1
    fi

    echo "DOCKER_GID=$(get_docker_gid)" >> $NEW_ENV_FILE

    
    read -p "Enter the environment (local, test, qa, stage, PROD): " MY_ENV
    if [[ -z "$MY_ENV" || ! "$MY_ENV" =~ ^(local|test|qa|stage|PROD)$ ]]; then
        echo "[ERROR] Environment is required and must be one of: local, test, qa, stage, PROD."
        exit 1
    fi
    if ! grep -q "MY_ENV=■■■" $NEW_ENV_FILE; then
        echo "[ERROR] MY_ENV variable not found in $NEW_ENV_FILE file. Please check the .env.example file and make sure it contains the line 'MY_ENV=■■■'."
        exit 1
    fi
    sed -i "s/MY_ENV=■■■/MY_ENV=$MY_ENV/g" $NEW_ENV_FILE



    read -p "Enter the domain (e.g., 'example.com', 'example-test.com'): " MY_DOMAIN
    if [[ -z "$MY_DOMAIN" || ! "$MY_DOMAIN" =~ ^[a-zA-Z0-9-]{3,16}.[a-zA-Z0-9.-]{2,5}+$ ]]; then
        echo "[ERROR] Domain is required and must be a valid domain name."
        exit 1
    fi
    if ! grep -q "MY_DOMAIN=■■■.■■■" $NEW_ENV_FILE; then
        echo "[ERROR] MY_DOMAIN variable not found in $NEW_ENV_FILE file. Please check the .env.example file and make sure it contains the line 'MY_DOMAIN=■■■.■■■'."
        exit 1
    fi
    sed -i "s/MY_DOMAIN=■■■.■■■/MY_DOMAIN=$MY_DOMAIN/g" $NEW_ENV_FILE



    read -p "Enter the registry username: " MY_USER
    if ! [[ "$MY_USER" =~ ^[a-zA-Z0-9]{3,16}+$ ]]; then
        echo "[ERROR] Registry username must be a valid username (only letters and numbers and between 3 and 16 characters)."
        exit 1
    fi
    if ! grep -q "MY_USER=■■■" $NEW_ENV_FILE; then
        echo "[ERROR] MY_USER variable not found in $NEW_ENV_FILE file. Please check the .env.example file and make sure it contains the line 'MY_USER=■■■'."
        exit 1
    fi
    sed -i "s/MY_USER=■■■/MY_USER=$MY_USER/g" $NEW_ENV_FILE



    read -s -p "Enter the registry password: " MY_PASS
    if [[ -z "$MY_PASS" || ${#MY_PASS} =~ ^[a-zA-Z0-9]{3,16}+$ ]]; then
        echo "[ERROR] Registry password is required and must be between 6 and 16 characters."
        exit 1
    fi
    if ! grep -q "MY_PASS=■■■" $NEW_ENV_FILE; then
        echo "[ERROR] MY_PASS variable not found in $NEW_ENV_FILE file. Please check the .env.example file and make sure it contains the line 'MY_PASS=■■■'."
        exit 1
    fi
    sed -i "s/MY_PASS=■■■/MY_PASS=$MY_PASS/g" $NEW_ENV_FILE


    
    read -p "Enter the registry email: " MY_EMAIL
    if [[ -z "$MY_EMAIL" || ! "$MY_EMAIL" =~ ^[a-zA-Z0-9_+-]{2,16}+@[a-zA-Z0-9-]{2,16}+\.[a-zA-Z]{2,16}$ ]]; then
        echo "[ERROR] Registry email is required and must be between 6 and 40 characters, and must be a valid email address."
        exit 1
    fi
    if ! grep -q "MY_EMAIL=■■■" $NEW_ENV_FILE; then
        echo "[ERROR] MY_EMAIL variable not found in $NEW_ENV_FILE file. Please check the .env.example file and make sure it contains the line 'MY_EMAIL=■■■'."
        exit 1
    fi
    sed -i "s/MY_EMAIL=■■■/MY_EMAIL=$MY_EMAIL/g" $NEW_ENV_FILE


    
    read -p "Enter the shared token: " SHARED_TOKEN
    if [[ -z "$SHARED_TOKEN" || ${#SHARED_TOKEN} =~ ^[a-zA-Z0-9]{3,16}+$ ]]; then
        echo "[ERROR] Shared token is required and must be less than 40 characters."
        exit 1
    fi
    if ! grep -q "SHARED_TOKEN=■■■" $NEW_ENV_FILE; then
        echo "[ERROR] SHARED_TOKEN variable not found in $NEW_ENV_FILE file. Please check the .env.example file and make sure it contains the line 'SHARED_TOKEN=■■■'."
        exit 1
    fi
    sed -i "s/SHARED_TOKEN=■■■/SHARED_TOKEN=$SHARED_TOKEN/g" $NEW_ENV_FILE


    
    read -p "Enter the database schema name: " DB_SCHEMA
    if [[ -z "$DB_SCHEMA" || ${#DB_SCHEMA}  =~ ^[a-zA-Z0-9_-]{3,16}+$ ]]; then
        echo "[ERROR] Database schema name is required and must be less than 40 characters."
        exit 1
    fi
    if ! grep -q "DB_SCHEMA=■■■" $NEW_ENV_FILE; then
        echo "[ERROR] DB_SCHEMA variable not found in $NEW_ENV_FILE file. Please check the .env.example file and make sure it contains the line 'DB_SCHEMA=■■■'."
        exit 1
    fi
    sed -i "s/DB_SCHEMA=■■■/DB_SCHEMA=$DB_SCHEMA/g" $NEW_ENV_FILE


    
    read -p "Enter the database username: " DB_USER
    if [[ -z "$DB_USER" || ${#DB_USER}  =~ ^[a-zA-Z0-9]{3,16}+$ ]]; then
        echo "[ERROR] Database username is required and must be less than 40 characters."
        exit 1
    fi
    if ! grep -q "DB_USER=■■■" $NEW_ENV_FILE; then
        echo "[ERROR] DB_USER variable not found in $NEW_ENV_FILE file. Please check the .env.example file and make sure it contains the line 'DB_USER=■■■'."
        exit 1
    fi
    sed -i "s/DB_USER=■■■/DB_USER=$DB_USER/g" $NEW_ENV_FILE


    
    read -p "Enter the database password: " DB_PASS
    if [[ -z "$DB_PASS" || ${#DB_PASS}  =~ ^[a-zA-Z0-9]{3,16}+$ ]]; then
        echo "[ERROR] Database password is required and must be less than 40 characters."
        exit 1
    fi
    if ! grep -q "DB_PASS=■■■" $NEW_ENV_FILE; then
        echo "[ERROR] DB_PASS variable not found in $NEW_ENV_FILE file. Please check the .env.example file and make sure it contains the line 'DB_PASS=■■■'."
        exit 1
    fi
    sed -i "s/DB_PASS=■■■/DB_PASS=$DB_PASS/g" $NEW_ENV_FILE

    source $NEW_ENV_FILE
}


function download_save_and_load_images {
    is_env_file_loaded_or_exit_with_error

    # check id image varialbes exist ($IMAGE_MVN $IMAGE_JENKINS $IMAGE_GITEA $IMAGE_JAVA $IMAGE_NODE $IMAGE_NGINX $DB_IMAGE $DB_MIG_IMAGE)
    if [ -z $IMAGE_MVN ]; then
        echo "[ERROR] IMAGE_MVN variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    if [ -z $IMAGE_JENKINS ]; then
        echo "[ERROR] IMAGE_JENKINS variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    if [ -z $IMAGE_GITEA ]; then
        echo "[ERROR] IMAGE_GITEA variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    if [ -z $IMAGE_JAVA ]; then
        echo "[ERROR] IMAGE_JAVA variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    if [ -z $IMAGE_NODE ]; then
        echo "[ERROR] IMAGE_NODE variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    if [ -z $IMAGE_NGINX ]; then
        echo "[ERROR] IMAGE_NGINX variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    if [ -z $DB_IMAGE ]; then
        echo "[ERROR] DB_IMAGE variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    if [ -z $DB_MIG_IMAGE ]; then
        echo "[ERROR] DB_MIG_IMAGE variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    
    # Pull and save the docker images to local files, then load them again to
    # ensure they are available locally. This is useful for offline installations
    # or to speed up subsequent installations by avoiding re-downloading the images.
    DEP_DATA_DIR="./dep_data"
    if [ ! -d $DEP_DATA_DIR ]; then
        mkdir $DEP_DATA_DIR
    fi
    docker pull $IMAGE_MVN
    docker save --output $DEP_DATA_DIR/IMAGE_MVN.tar
    docker load --input $DEP_DATA_DIR/IMAGE_MVN.tar

    docker pull $IMAGE_JENKINS
    docker save --output $DEP_DATA_DIR/IMAGE_JENKINS.tar
    docker load --input $DEP_DATA_DIR/IMAGE_JENKINS.tar

    docker pull $IMAGE_GITEA
    docker save --output $DEP_DATA_DIR/IMAGE_GITEA.tar
    docker load --input $DEP_DATA_DIR/IMAGE_GITEA.tar

    docker pull $IMAGE_JAVA
    docker save --output $DEP_DATA_DIR/IMAGE_JAVA.tar
    docker load --input $DEP_DATA_DIR/IMAGE_JAVA.tar

    docker pull $IMAGE_NODE
    docker save --output $DEP_DATA_DIR/IMAGE_NODE.tar
    docker load --input $DEP_DATA_DIR/IMAGE_NODE.tar

    docker pull $IMAGE_NGINX
    docker save --output $DEP_DATA_DIR/IMAGE_NGINX.tar
    docker load --input $DEP_DATA_DIR/IMAGE_NGINX.tar

    docker pull $DB_IMAGE
    docker save --output $DEP_DATA_DIR/DB_IMAGE.tar
    docker load --input $DEP_DATA_DIR/DB_IMAGE.tar

    docker pull $DB_MIG_IMAGE
    docker save --output $DEP_DATA_DIR/DB_MIG_IMAGE.tar
    docker load --input $DEP_DATA_DIR/DB_MIG_IMAGE.tar

}

function create_ssh_keys {
    if [ ! -d $KEY_DIR ]; then
        mkdir -p $KEY_DIR
    fi
    KEY_FILE="$KEY_DIR/ssh_key.priv"
    if [ -f $KEY_FILE ]; then
        echo "[ERROR] SSH private key already exists at $KEY_FILE. Skipping SSH key generation."
        return
    fi
    ssh-keygen -t ed25519 -N '' -f  $KEY_FILE
    mv $KEY_FILE.pub $KEY_DIR/ssh_key.pub

    echo "[INFO] SSH keys generated and saved to $KEY_DIR directory."
}

function create_registry_auth {
    is_env_file_loaded_or_exit_with_error
    if [ ! -d $KEY_DIR ]; then
        mkdir -p $KEY_DIR
    fi
    REGISTRY_AUTH_FILE="$KEY_DIR/registry.password"
    if [ -f $REGISTRY_AUTH_FILE ]; then
        echo "[ERROR] Registry auth file already exists at $REGISTRY_AUTH_FILE. Skipping registry auth creation."
        return
    fi
    docker run --rm httpd:2 htpasswd -Bbn ${MY_USER} ${MY_PASS} > $REGISTRY_AUTH_FILE
}