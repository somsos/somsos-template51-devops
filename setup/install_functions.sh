#!/bin/bash
set -e
#set -x

# this file is thinked to be executed from install.sh, at root of the project.


NEW_ENV_FILE=".env"
KEY_DIR="./setup/secrets"
DEP_DATA_DIR="./dep_data"
ENV_EXAMPLE_FILE=".env.example"

function check_dependencies {
    # check if sudo is available
    if ! command -v sudo &> /dev/null; then
        echo "[ERROR] sudo command is not available. Please install the necessary packages and try again."
        exit 1
    fi

    if ! command -v docker &> /dev/null; then
        echo "[ERROR] Docker is not installed. Please install Docker and try again."
        exit 1
    fi

    if ! systemctl is-active --quiet docker; then
        echo "[ERROR] Docker service is not active. Please start the Docker service and try again."
        echo "        You can run: systemctl start docker.socket docker.service docker"
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

    if ! command -v nc &> /dev/null; then
        echo "[ERROR] nc (netcat) command is not available. Please install the necessary package (e.g., netcat) and try again."
        exit 1
    fi

    if ! command -v realpath &> /dev/null; then
        echo "[ERROR] realpath command is not available. Please install the necessary package (e.g., coreutils) and try again."
        exit 1
    fi

    if ! command -v getent &> /dev/null; then
        set -x && echo "[ERROR] getent command is not available. Please install the necessary package (e.g., libc-bin) and try again." && set +x
        exit 1
    fi

    if [ ! -e /etc/localtime ]; then
        echo "[ERROR] /etc/localtime does not exist. Time synchronization in containers may not work."
        echo "        To fix it Run: sudo ln -sf /usr/share/zoneinfo/Region/City /etc/localtime (e.g., '.../America/Mexico_City')."
        exit 1
    fi

    if [ ! -e /etc/timezone ]; then
        echo "[ERROR] /etc/timezone does not exist. Some containers may expect this file."
        echo "        To fix it Run: echo 'Region/City' | sudo tee /etc/timezone (e.g., '.../America/Mexico_City')."
        exit 1
    fi
}


function check_repository_state {
    if ! grep -q "MY_DOMAIN=" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] MY_DOMAIN variable not set in .env file. Please set the variable and try again."
        exit 1
    fi
    if ! grep -q "DB_SCHEMA=" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] DB_SCHEMA variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    
    if ! grep -q "DB_MIG_REPO=" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] DB_MIG_REPO variable not set in .env file. Please set the variable and try again."
        exit 1
    fi
    if ! grep -q "BACK_REPO=" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] BACK_REPO variable not set in .env file. Please set the variable and try again."
        exit 1
    fi
    if ! grep -q "FRONT_REPO=" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] FRONT_REPO variable not set in .env file. Please set the variable and try again."
        exit 1
    fi

    if ! grep -q "IMAGE_MVN=" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] IMAGE_MVN variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    if ! grep -q "IMAGE_JENKINS=" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] IMAGE_JENKINS variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    if ! grep -q "IMAGE_GITEA=" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] IMAGE_GITEA variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    if ! grep -q "IMAGE_JAVA=" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] IMAGE_JAVA variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    if ! grep -q "IMAGE_NODE=" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] IMAGE_NODE variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    if ! grep -q "IMAGE_NGINX=" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] IMAGE_NGINX variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    if ! grep -q "DB_IMAGE=" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] DB_IMAGE variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    if ! grep -q "DB_MIG_IMAGE=" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] DB_MIG_IMAGE variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    if ! grep -q "IMAGE_HTTPD=" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] IMAGE_HTTPD variable not found in $NEW_ENV_FILE file."
        exit 1
    fi

    if [ ! -f "setup/docker-compose-devops.yml" ]; then
        echo "[ERROR] docker-compose-devops.yml file not found in setup directory. Please make sure the file exists and try again."
        exit 1
    fi

    if ! grep -q "reverse-proxy:" setup/docker-compose-devops.yml; then
        echo "[ERROR] reverse-proxy service not found in docker-compose-devops.yml file. Please make sure the service is defined and try again."
        exit 1
    fi

    if ! grep -q "gitea:" setup/docker-compose-devops.yml; then
        echo "[ERROR] gitea service not found in docker-compose-devops.yml file. Please make sure the service is defined and try again."
        exit 1
    fi

    if ! grep -q "jenkins:" setup/docker-compose-devops.yml; then
        echo "[ERROR] jenkins service not found in docker-compose-devops.yml file. Please make sure the service is defined and try again."
        exit 1
    fi

    if ! grep -q "registry:" setup/docker-compose-devops.yml; then
        echo "[ERROR] registry service not found in docker-compose-devops.yml file. Please make sure the service is defined and try again."
        exit 1
    fi

    if [ ! -f "setup/shared/known_hosts" ]; then
        echo "[WARN] known_hosts file not found in setup/shared creating it"
        touch setup/shared/known_hosts
    fi

    git update-index --assume-unchanged setup/shared/known_hosts

    
}



function is_env_file_loaded_or_exit_with_error {
    # check is already loaded
    if [ ! -f $NEW_ENV_FILE ]; then
        echo "[ERROR] $NEW_ENV_FILE file not found."
        exit 1
    fi

    if [ -z "$MY_ENV" ] || [ -z "$MY_DOMAIN" ] || [ -z "$MY_USER" ] || [ -z "$MY_PASS" ] || [ -z "$MY_EMAIL" ] || [ -z "$SHARED_TOKEN" ]; then
        echo "[ERROR] One or more required environment variables are not set. are you sure you have loaded the environment file?"
        exit 1
    fi    
}



function create_env_file_and_load_it {
    if [ -f $NEW_ENV_FILE ]; then
        echo "[INFO] $NEW_ENV_FILE file already exists."
        source $NEW_ENV_FILE
        return
    fi

    if [ ! -f $ENV_EXAMPLE_FILE ]; then
        echo "[ERROR] $ENV_EXAMPLE_FILE file not found. Please create it with the necessary variables."
        exit 1
    fi

    local DOCKER_GID=$(getent group docker | cut -d: -f3)
    if [ -z "$DOCKER_GID" ]; then
        set -x && echo "[ERROR] Docker group not found. Please make sure Docker is installed and the docker group exists." && set +x
        exit 1
    fi
    sed -i "s/DOCKER_GID=■■■/DOCKER_GID=$DOCKER_GID/g" $ENV_EXAMPLE_FILE

    read -p "Enter the environment (local, test, qa, stage, PROD): " MY_ENV
    if [[ -z "$MY_ENV" || ! "$MY_ENV" =~ ^(local|test|qa|stage|PROD)$ ]]; then
        echo "[ERROR] Environment is required and must be one of: local, test, qa, stage, PROD."
        exit 1
    fi
    if ! grep -q "MY_ENV=■■■" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] MY_ENV variable not found in $NEW_ENV_FILE file. Please check the $ENV_EXAMPLE_FILE file and make sure it contains the line 'MY_ENV=■■■'."
        exit 1
    fi



    read -p "Enter the domain (e.g., 'example.com', 'example-test.com'): " MY_DOMAIN
    if [[ -z "$MY_DOMAIN" || ! "$MY_DOMAIN" =~ ^[a-zA-Z0-9-]{3,16}.[a-zA-Z0-9.-]{2,5}+$ ]]; then
        echo "[ERROR] Domain is required and must be a valid domain name."
        exit 1
    fi
    if ! grep -q "MY_DOMAIN=■■■.■■■" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] MY_DOMAIN variable not found in $NEW_ENV_FILE file. Please check the $ENV_EXAMPLE_FILE file and make sure it contains the line 'MY_DOMAIN=■■■.■■■'."
        exit 1
    fi



    read -p "Enter the App username: " MY_USER
    if ! [[ "$MY_USER" =~ ^[a-zA-Z0-9]{3,16}+$ ]]; then
        echo "[ERROR] App username must be a valid username (only letters and numbers and between 3 and 16 characters)."
        exit 1
    fi
    if ! grep -q "MY_USER=■■■" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] MY_USER variable not found in $NEW_ENV_FILE file. Please check the $ENV_EXAMPLE_FILE file and make sure it contains the line 'MY_USER=■■■'."
        exit 1
    fi



    read -s -p "Enter the App password: " MY_PASS
    if [[ -z "$MY_PASS" || ${#MY_PASS} =~ ^[a-zA-Z0-9]{3,16}+$ ]]; then
        echo "[ERROR] App password is required and must be between 6 and 16 characters."
        exit 1
    fi
    if ! grep -q "MY_PASS=■■■" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] MY_PASS variable not found in $NEW_ENV_FILE file. Please check the $ENV_EXAMPLE_FILE file and make sure it contains the line 'MY_PASS=■■■'."
        exit 1
    fi
    echo ""
    read -s -p "Repeat the App password: " MY_PASS_CONFIRM
    if [[ "$MY_PASS" != "$MY_PASS_CONFIRM" ]]; then
        echo -e "\n[ERROR] Passwords do not match. Please try again."
        exit 1
    fi
    echo ""



    
    read -p "Enter the App email: " MY_EMAIL
    if [[ -z "$MY_EMAIL" || ! "$MY_EMAIL" =~ ^[a-zA-Z0-9_+-]{2,16}+@[a-zA-Z0-9-]{2,16}+\.[a-zA-Z]{2,16}$ ]]; then
        echo "[ERROR] App email is required and must be between 6 and 40 characters, and must be a valid email address."
        exit 1
    fi
    if ! grep -q "MY_EMAIL=■■■" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] MY_EMAIL variable not found in $ENV_EXAMPLE_FILE file. Please check the $ENV_EXAMPLE_FILE file and make sure it contains the line 'MY_EMAIL=■■■'."
        exit 1
    fi


    
    read -p "Enter the shared token: " SHARED_TOKEN
    if [[ -z "$SHARED_TOKEN" || ${#SHARED_TOKEN} =~ ^[a-zA-Z0-9]{3,16}+$ ]]; then
        echo "[ERROR] Shared token is required and must be less than 40 characters."
        exit 1
    fi
    if ! grep -q "SHARED_TOKEN=■■■" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] SHARED_TOKEN variable not found in $ENV_EXAMPLE_FILE file. Please check the $ENV_EXAMPLE_FILE file and make sure it contains the line 'SHARED_TOKEN=■■■'."
        exit 1
    fi


    
    read -p "Enter the database schema name: " DB_SCHEMA
    if [[ -z "$DB_SCHEMA" || ${#DB_SCHEMA}  =~ ^[a-zA-Z0-9_-]{3,16}+$ ]]; then
        echo "[ERROR] Database schema name is required and must be less than 40 characters."
        exit 1
    fi
    if ! grep -q "DB_SCHEMA=■■■" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] DB_SCHEMA variable not found in $ENV_EXAMPLE_FILE file. Please check the $ENV_EXAMPLE_FILE file and make sure it contains the line 'DB_SCHEMA=■■■'."
        exit 1
    fi


    
    read -p "Enter the database username: " DB_USER
    if [[ -z "$DB_USER" || ${#DB_USER}  =~ ^[a-zA-Z0-9]{3,16}+$ ]]; then
        echo "[ERROR] Database username is required and must be less than 40 characters."
        exit 1
    fi
    if ! grep -q "DB_USER=■■■" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] DB_USER variable not found in $ENV_EXAMPLE_FILE file. Please check the $ENV_EXAMPLE_FILE file and make sure it contains the line 'DB_USER=■■■'."
        exit 1
    fi


    
    read -p "Enter the database password: " DB_PASS
    if [[ -z "$DB_PASS" || ${#DB_PASS}  =~ ^[a-zA-Z0-9]{3,16}+$ ]]; then
        echo "[ERROR] Database password is required and must be less than 40 characters."
        exit 1
    fi
    if ! grep -q "DB_PASS=■■■" $ENV_EXAMPLE_FILE; then
        echo "[ERROR] DB_PASS variable not found in $ENV_EXAMPLE_FILE file. Please check the $ENV_EXAMPLE_FILE file and make sure it contains the line 'DB_PASS=■■■'."
        exit 1
    fi

    if [ ! -f $NEW_ENV_FILE ]; then
        cp $ENV_EXAMPLE_FILE $NEW_ENV_FILE
        echo "Created $NEW_ENV_FILE file from $ENV_EXAMPLE_FILE. Please edit the $NEW_ENV_FILE file with your configuration."
    else
        echo "[ERROR] $NEW_ENV_FILE file already exists. Skipping creation."
        exit 1
    fi

    sed -i "s/MY_ENV=■■■/MY_ENV=$MY_ENV/g" $NEW_ENV_FILE
    sed -i "s/MY_DOMAIN=■■■.■■■/MY_DOMAIN=$MY_DOMAIN/g" $NEW_ENV_FILE
    sed -i "s/MY_USER=■■■/MY_USER=$MY_USER/g" $NEW_ENV_FILE
    sed -i "s/MY_PASS=■■■/MY_PASS=$MY_PASS/g" $NEW_ENV_FILE
    sed -i "s/MY_EMAIL=■■■/MY_EMAIL=$MY_EMAIL/g" $NEW_ENV_FILE
    sed -i "s/SHARED_TOKEN=■■■/SHARED_TOKEN=$SHARED_TOKEN/g" $NEW_ENV_FILE
    sed -i "s/DB_SCHEMA=■■■/DB_SCHEMA=$DB_SCHEMA/g" $NEW_ENV_FILE
    sed -i "s/DB_USER=■■■/DB_USER=$DB_USER/g" $NEW_ENV_FILE
    sed -i "s/DB_PASS=■■■/DB_PASS=$DB_PASS/g" $NEW_ENV_FILE

    source $NEW_ENV_FILE
}

function download_save_and_load_image {
    is_env_file_loaded_or_exit_with_error
    if [ -z $DEP_DATA_DIR ]; then
        echo "[ERROR] DEP_DATA_DIR variable is not set. Please set it to a valid directory path."
        exit 1
    fi
    if [ ! -d $DEP_DATA_DIR ]; then
        mkdir $DEP_DATA_DIR
    fi
    # check MY_DOMAIN
    if [ -z $MY_DOMAIN ]; then
        echo "[ERROR] MY_DOMAIN variable not set. Please set it in the environment file."
        exit 1
    fi
    

    if [ -z "$1" ]; then
        echo "[ERROR] Image name is required as an argument to the download_save_and_load_image function."
        exit 1
    fi
    if [ -z "$2" ]; then
        echo "[ERROR] .tar name is required as the second argument to the download_save_and_load_image function."
        exit 1
    fi
    IMAGE_NAME=$1
    TAR_FILE_PATH="$DEP_DATA_DIR/$2.tar"

    if [ -f $TAR_FILE_PATH ]; then
        echo "[INFO] $TAR_FILE_PATH file already exists, loading from tar file."
        # check if is already loaded
        if docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "^$IMAGE_NAME$"; then
            echo "[INFO] $IMAGE_NAME image is already loaded in Docker. Skipping loading from tar file."
            return
        fi
        docker load --input $TAR_FILE_PATH
    else
        docker pull $IMAGE_NAME
        docker save --output $TAR_FILE_PATH $IMAGE_NAME
    fi

}


function create_ssh_keys {
    if [ ! -d $KEY_DIR ]; then
        mkdir -p $KEY_DIR
    fi
    KEY_FILE="$KEY_DIR/ssh_key.priv"
    if [ -f $KEY_FILE ]; then
        echo "[ERROR] SSH private key already exists at $KEY_FILE."
        return
    fi
    ssh-keygen -t ed25519 -N '' -f  $KEY_FILE
    mv $KEY_FILE.pub $KEY_DIR/ssh_key.pub
    sudo chmod 0644 $KEY_DIR/ssh_key.pub

    echo "[INFO] SSH keys generated and saved to $KEY_DIR directory."
}


function add_project_ssh_public_key_to_docker_host_ssh_config {
    is_env_file_loaded_or_exit_with_error
    if [ -z $KEY_DIR ]; then
        echo "[ERROR] KEY_DIR variable not set. Please set it to a valid directory path."
        exit 1
    fi
    PUB_KEY_FILE="$KEY_DIR/ssh_key.pub"
    PUB_KEY_FILE=$(realpath $PUB_KEY_FILE)
    if [ ! -f $PUB_KEY_FILE ]; then
        echo "[ERROR] SSH public key file not found at $PUB_KEY_FILE. Please generate the SSH keys first."
        exit 1
    fi

    USER_HOME=$(eval echo ~)
    DOCKER_HOST_SSH_CONFIG_FILE="$USER_HOME/.ssh/config"
    if [ ! -f $DOCKER_HOST_SSH_CONFIG_FILE ]; then
        touch $DOCKER_HOST_SSH_CONFIG_FILE
    fi

    GITEA_DOMAIN="gitea.${MY_DOMAIN}"
    HOST_DOES_NOT_EXIST=$(grep -c "Host ${GITEA_DOMAIN}" $DOCKER_HOST_SSH_CONFIG_FILE || true)
    if [[ "$HOST_DOES_NOT_EXIST" -eq 0 ]]; then
        {
            echo ""
            echo "Host ${GITEA_DOMAIN}"
            echo "    HostName gitea.${MY_DOMAIN}"
            echo "    Port 222"
            echo "    User git"
            echo "    IdentityFile $PUB_KEY_FILE"
        } | sudo tee -a $DOCKER_HOST_SSH_CONFIG_FILE > /dev/null
        echo "[INFO] Added SSH public key to Docker host SSH config."
    else
        echo "[INFO] Docker host SSH config already contains the project SSH public key for $GITEA_DOMAIN."
    fi
}



function create_registry_auth {
    is_env_file_loaded_or_exit_with_error
    if [ ! -d $KEY_DIR ]; then
        mkdir -p $KEY_DIR
    fi
    if [ -z $IMAGE_HTTPD ]; then
        echo "[ERROR] IMAGE_HTTPD variable not found in $NEW_ENV_FILE file."
        exit 1
    fi
    REGISTRY_AUTH_FILE="$KEY_DIR/registry.password"
    if [ -f $REGISTRY_AUTH_FILE ]; then
        echo "[ERROR] Registry auth file already exists at $REGISTRY_AUTH_FILE."
        return
    fi
    docker run --rm $IMAGE_HTTPD htpasswd -Bbn ${MY_USER} ${MY_PASS} > $REGISTRY_AUTH_FILE
}

function add_domain_to_hosts_file {
    if [ -z "$1" ]; then
        echo "[ERROR] Domain name is required as an argument to the add_domain_to_hosts_file function."
        exit 1
    fi
    NEW_DOMAIN=$1
    if ! grep -q "$NEW_DOMAIN" /etc/hosts; then
        echo "127.0.0.1 $NEW_DOMAIN" | sudo tee -a /etc/hosts
    else
        echo "[INFO] Domain $NEW_DOMAIN already exists in /etc/hosts file. Skipping adding it."
    fi
}

function start_and_check_health_devops_service {
    if [ -z "$1" ]; then
        echo "[ERROR] Service name is required as an argument to the start_and_check_health_devops_service function."
        exit 1
    fi
    SERVICE_NAME=$1
    SERVICE_URL="http://$SERVICE_NAME.$MY_DOMAIN"
    
    if docker compose ps --services --filter "status=running" | grep -q "^$SERVICE_NAME$"; then
        echo "[INFO] $SERVICE_NAME already available on \"$SERVICE_URL\"."
        return
    fi

    docker compose up -d $SERVICE_NAME

    until curl -I --retry 5 --retry-max-time 30 $SERVICE_URL > /dev/null 2>&1; do
        echo "Waiting for $SERVICE_NAME to be up..."
        sleep 3
    done
    echo "URL available: $SERVICE_URL"

}

function clone_repository {
    is_env_file_loaded_or_exit_with_error
    if [ -z "$1" ]; then
        echo "[ERROR] Repository URL is required as the first argument to the clone_repository function."
        exit 1
    fi
    if [ -z "$2" ]; then
        echo "[ERROR] Directory path is required as the second argument to the clone_repository function."
        exit 1
    fi
    ORIGINAL_URL=$1
    GITEA_DOMAIN="gitea.${MY_DOMAIN}"
    MODIFIED_URL=$(echo $ORIGINAL_URL | sed "s|gitea:2222|${GITEA_DOMAIN}:222|g")
    if [ -z "$(ls -A $2)" ]; then
        if GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git clone -q $MODIFIED_URL $2; then
            echo "[INFO] Repository $1 cloned successfully."
        else
            echo "[ERROR] Failed to clone repository $1. Please check the repository URL and your network connection, then try again."
            exit 1
        fi
    else
        echo "[INFO] Source directory $2 is not empty, skipping cloning."
    fi
}


function start_app_database_service_and_install_schema {
    is_env_file_loaded_or_exit_with_error

    if docker compose ps --services --filter "status=running" | grep -q "^db$"; then
        echo "[INFO] Database already available on \"psql postgresql://$DB_USER:<DB_PASS>@localhost:5001/$DB_SCHEMA\"."
        return
    fi

    docker compose up --wait --wait-timeout 30 db
    
    tries=0
    until  nc -zv  localhost $DB_PORT &> /dev/null; do
        echo "Waiting for App Database to be up..."
        tries=$((tries + 1))
        if [ $tries -ge 20 ]; then
            echo "[ERROR] App Database did not start within expected time. Please check the Docker containers and try again."
            exit 1
        fi
        sleep 3
    done
    echo "[INFO] App Database is up and accepting connections on localhost port $DB_PORT."

    # "docker compose build  db_utils" not required because is required to be built (--build) at each running.

    LOGS_FILE="./app/db/schema_installation.log"
    echo "[INFO] Installing database schema started. Logs in $LOGS_FILE."
    if ! docker compose run -q --rm --name temp db_utils deploy &> $LOGS_FILE; then
        echo "[ERROR] Failed to install database schema. Please check the logs in $LOGS_FILE."
        exit 1
    fi

    echo "[INFO] Database schema installed successfully."
}

function start_app_backend_service {
    is_env_file_loaded_or_exit_with_error

    BACK_URL="http://api.$MY_DOMAIN"
    if docker compose ps --services --filter "status=running" | grep -q "^back$"; then
        echo "[INFO] Backend already available on \"$BACK_URL/swagger-ui/index.html\"."
        return
    fi

    docker compose up -d --wait --wait-timeout 30 back

    
    until curl -I --retry 5 --retry-max-time 30 $BACK_URL > /dev/null 2>&1; do
        echo "Waiting for App Backend to be up..."
        sleep 3
    done
    echo "URL available: $BACK_URL"
}

function start_app_frontend_service {
    is_env_file_loaded_or_exit_with_error

    FRONT_URL="http://$MY_DOMAIN"

    if docker compose ps --services --filter "status=running" | grep -q "^front$"; then
        echo "[INFO] Frontend already available on \"$FRONT_URL\"."
        return
    fi

    docker compose up -d --wait --wait-timeout 30 front

    until curl -I --retry 5 --retry-max-time 30 $FRONT_URL > /dev/null 2>&1; do
        echo "Waiting for App Frontend to be up..."
        sleep 3
    done
    echo "URL available: $FRONT_URL"
}

