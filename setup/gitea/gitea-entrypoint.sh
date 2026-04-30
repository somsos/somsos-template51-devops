#!/bin/bash
#set -e

# Start the original Gitea entrypoint in the background
# This initializes the app and starts the s6 supervisor
/usr/bin/entrypoint /usr/bin/s6-svscan /etc/s6 &

# Wait for the Gitea web service to be reachable
echo "Waiting for Gitea to start..."
until nc -z localhost 3000; do
  sleep 1
done

################################################################################
####################-CHECK-REQUIRED-GLOBAL-VARIABLES-###########################

if [ -z "$GITEA_ADMIN_USER" ]; then
  echo "global environment variable GITEA_ADMIN_USER required"
  exit 1
fi

if [ -z "$GITEA_ADMIN_PASSWORD" ]; then
  echo "global environment variable GITEA_ADMIN_PASSWORD required"
  exit 1
fi

if [ -z "$GITEA_ADMIN_EMAIL" ]; then
  echo "global environment variable GITEA_ADMIN_EMAIL required"
  exit 1
fi

if [ -z "$BACK_NAME" ]; then
  echo "global environment variable BACK_NAME required"
  exit 1
fi

if [ -z "$FRONT_NAME" ]; then
  echo "global environment variable FRONT_NAME required"
  exit 1
fi

if [ -z "$DB_MIG_NAME" ]; then
  echo "global environment variable DB_MIG_NAME required"
  exit 1
fi

if [ -z "$DEVOPS_NAME" ]; then
  echo "global environment variable DEVOPS_NAME required"
  exit 1
fi

if [ -z "$SHARED_TOKEN" ]; then
  echo "global environment variable SHARED_TOKEN required"
  exit 1
fi

####################-ENDS-CHECK-REQUIRED-GLOBAL-VARIABLES-#######################
################################################################################




################################################################################
####################-DECLARATIONS-STARTS-#######################################

#INPUT 
#   1: username
#   2: password
#   3: email
function add_admin_user_if_required {
  if [ -z "$1" ]; then
    set -x && echo "[ERROR]: function argument 1 not defined or empty in add_admin_user_if_required function" && set +x
    exit 1
  fi

  if [ -z "$2" ]; then
    set -x && echo "[ERROR]: function argument 2 not defined or empty in add_admin_user_if_required function" && set +x
    exit 1
  fi

  if [ -z "$3" ]; then
    set -x && echo "[ERROR]: function argument 3 not defined or empty in add_admin_user_if_required function" && set +x
    exit 1
  fi

  # If the user already exist stop the function
  su-exec git gitea admin user list | grep -q "$1"
  if [ $? -eq 0 ]; then
      echo "[INFO] The git admin user already exists, skipping creation."
      return 0
  fi
  
  su-exec git gitea admin user create \
    --admin \
    --username "${1}" \
    --password "${2}" \
    --email "${3}" \
    --must-change-password=false
  
  if [ $? -ne 0 ]; then
      set -x && echo "[INFO] Something went wrong with the user creation." && set +x
      exit 1;
  fi
}


# DEPENDS ON 
#   and admin user already addded defined in fuction add_admin_user_if_required
function get_token {
  TOKEN=$(su-exec git gitea admin user generate-access-token \
    --username "${GITEA_ADMIN_USER}" \
    --token-name "$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 10)" \
    | awk '{print $NF}')
  if [ "$TOKEN" = "" ]; then
    set -x && echo "[ERROR]: Error generating tocken." && set +x
    exit 1
  fi
  echo $TOKEN
}


function add_git_global_config_if_required {
  if [ -z "$1" ]; then
    echo "[ERROR] function arg 1 not found, required email value for user.email git config."
    exit 1
  fi

  if [ -z "$2" ]; then
    echo "[ERROR] function arg 2 not found, required name value for user.name git config."
    exit 1
  fi

  if [[ -z "$(git config user.email)" ]]; then
    git config --global init.defaultBranch main    # to avoid git asking to add it later
    git config --global user.email "$1"
    git config --global user.name "$2"
    echo "Git config added"
  else
    echo "Git config already set up"
  fi
}

# INPUT
#   $1: path to public key file without passkey, e.g. "/data/setup/t51_noPass.pub"
# DEPENDS ON 
#   get_token FUNCTION
function add_public_key {
  if [[ ! -f "$1" ]]; then
    echo "[ERROR]: Public key doesn't exist: $1"
    return 1
  fi
  SSH_KEY_CONTENT=$(cat $1)
  if [[ "$SSH_KEY_CONTENT" = "" ]]; then
    echo "[ERROR]: Public key file is empty: $1"
    return 1
  fi
  if [[ ! -d "/data/setup" ]]; then
    echo "[ERROR]: Setup directory doesn't exist: /data/setup"
    return 1
  fi
  

  chown -R git:git /data/setup/
  chown git:git $1

  TOKEN=$(get_token)

  # 5. Add the SSH Key via API
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X 'POST' \
    "http://localhost:3000/api/v1/user/keys" \
    -H "Authorization: token $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"key\": \"$SSH_KEY_CONTENT\", \"title\": \"t51_project\"}")

  if [ "$STATUS" = "201" ]; then
    echo "[SUCCESS] SSH key added successfully."
  elif [ "$STATUS" = "422" ]; then
    echo "[INFO] SSH key already exists, skipping."
  else
    echo "[ERROR] Failed to add key. HTTP Status: $STATUS"
    exit 1;
  fi
}


# INPUT
#   $1: Repository name used also in compressed file and URL
function addRepo {

    TOKEN_TWO=$(get_token)
    
    # Attempt to create the repo via API
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X 'POST' \
      "http://localhost:3000/api/v1/user/repos" \
      -H "Authorization: token $TOKEN_TWO" \
      -H "Content-Type: application/json" \
      -d "{\"name\": \"$1\", \"private\": true}")


    if [ "$RESPONSE" = "201" ]; then
        echo "[SUCCESS] Created repository: $1"

        # Generate content
        TAR_FILE="/tmp/initial_repos/$1.tar.xz"
        if [[ ! -f "$TAR_FILE" ]]; then
          echo "[ERROR]: Compressed file do not exist: $TAR_FILE"
          return 1
        fi

        NEW_REPO_DIR="/tmp/content-$1/"
        mkdir -p $NEW_REPO_DIR
        tar -xJf $TAR_FILE -C $NEW_REPO_DIR \
          && echo "[INFO] Repo populated: $1 using $TAR_FILE" \
          || echo "[ERROR] $1 something went wrong uncompressed $TAR_FILE"
        
        # Create first commit
        git -C $NEW_REPO_DIR init -q && echo "[INFO] Repo init in $NEW_REPO_DIR" || echo "[ERROR] git init $NEW_REPO_DIR"
        git -C $NEW_REPO_DIR branch -M main # rename current branch to main, to be sure when pushing
        git -C $NEW_REPO_DIR add .
        git -C $NEW_REPO_DIR commit --quiet -m "Initial commit" &> /dev/null && echo "[INFO] Commit created on $1"
        if [ $? -ne 0 ]; then
          echo "[ERROR] Commit Error on $1"
        fi

        # Use the token for passwordless push (safer than password)
        git -C $NEW_REPO_DIR push -q http://${TOKEN_TWO}@localhost:3000/${GITEA_ADMIN_USER}/${1}.git main

        rm -rf $TAR_FILE

        echo "[SUCCESS]: Repo added: $1"

    elif [ "$RESPONSE" = "409" ] || [ "$RESPONSE" = "422" ]; then
        echo "[INFO] Repository '$1' already exists. Skipping creation."
    else
        echo "[ERROR] Something went wrong creating repo. HTTP Status: $RESPONSE"
        exit 1;
    fi
}

# DESCRIPTION
#    Adds the an webhook to jenkins, so on an push a pipeline is executed
# INPUT
#    $1 : Repository name
#
function addWebHook {

  if [ -z "$SHARED_TOKEN" ]; then
    echo "[ERROR] Variable SHARED_TOKEN not found, random token required."
    exit 1
  fi

  HOOK_URL="http://localhost:3000/api/v1/repos/${GITEA_ADMIN_USER}/${1}/hooks"
  HOOK_JENKINS="http://jenkins:8080/generic-webhook-trigger/invoke?token=${1}-${SHARED_TOKEN}"

  # Check if exists the webhook already
  TOKEN_CHECK=$(get_token)
  if curl -s -H "Authorization: token $TOKEN_CHECK" "$HOOK_URL" | grep -qF "\"url\":\"${HOOK_JENKINS}\""; then
    echo "[INFO] Webhook for $1 already exists. Skipping."
    return 0
  fi

  TOKEN_CREATE=$(get_token)
  if [ -z "$TOKEN_CREATE" ]; then
    echo "[ERROR] TOKEN empty, it should have a random string."
    exit 1
  fi

  RESPONSE=$(curl -s -i -o /tmp/resp_${1}.txt -w "%{http_code}" -X 'POST'  \
    "${HOOK_URL}" \
    -H "Authorization: token $TOKEN_CREATE" \
    -H "Content-Type: application/json" \
    -d "{
      \"type\": \"gitea\",
      \"config\": {
        \"content_type\": \"json\",
        \"url\": \"${HOOK_JENKINS}\"
      },
      \"events\": [\"push\"],
      \"active\": true
    }")

    if [ "$RESPONSE" = "201" ]; then
      echo "[INFO] WebHook for ${1} created"
    elif [ "$RESPONSE" = "409" ] || [ "$RESPONSE" = "422" ]; then
      echo "[INFO] Webhook already exists."
    else
      echo "[ERROR] Error creating webhook for ${1}."
      echo "[DEBUG] TOKEN: ${TOKEN_CREATE}"
      echo "[DEBUG] HOOK_URL: ${HOOK_URL}"
      echo "[DEBUG] HOOK_JENKINS: ${HOOK_JENKINS}"
      cat /tmp/resp_${1}.txt
    fi
    
}

################################################################################
####################-END-DECLARATIONS-##########################################
################################################################################














add_admin_user_if_required $GITEA_ADMIN_USER $GITEA_ADMIN_PASSWORD $GITEA_ADMIN_EMAIL


add_public_key "/data/setup/t51_noPass.pub"


add_git_global_config_if_required $GITEA_ADMIN_EMAIL $GITEA_ADMIN_USER


addRepo "$BACK_NAME"
sleep 1

addRepo "$FRONT_NAME"
sleep 1

addRepo "$DB_MIG_NAME"
sleep 1

addRepo "$DEVOPS_NAME"
sleep 1


addWebHook "$BACK_NAME"
sleep 1

addWebHook "$FRONT_NAME"
sleep 1

addWebHook "$DB_MIG_NAME"
sleep 1


echo "[INFO] Entrypoint completed."

# Bring the background process back to the foreground to keep container alive
wait
