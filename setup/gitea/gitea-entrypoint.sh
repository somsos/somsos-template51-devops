#!/bin/sh

# Start the original Gitea entrypoint in the background
# This initializes the app and starts the s6 supervisor
/usr/bin/entrypoint /usr/bin/s6-svscan /etc/s6 &



# Wait for the Gitea web service to be reachable
echo "Waiting for Gitea to start..."
until nc -z localhost 3000; do
  sleep 1
done

# 0. Fix permissions while still root
chown -R git:git /data
chown git:git /data/setup/t51_noPass.pub

# 1. Create the Admin User
# We use '|| true' so the script doesn't fail if the user already exists
 
 
su-exec git gitea admin user create \
  --admin \
  --username "${GITEA_ADMIN_USER}" \
  --password "${GITEA_ADMIN_PASSWORD}" \
  --email "${GITEA_ADMIN_EMAIL}" \
  --must-change-password=false \
  || echo "Admin user already exists."



TOKEN=$(su-exec git gitea admin user generate-access-token \
  --username "${GITEA_ADMIN_USER}" \
  --token-name "$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 1)" \
  | awk '{print $NF}')

# 5. Add the SSH Key via API
SSH_KEY_CONTENT=$(cat /data/setup/t51_noPass.pub)

STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X 'POST' \
  "http://localhost:3000/api/v1/user/keys" \
  -H "Authorization: token $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"key\": \"$(cat /data/setup/t51_noPass.pub)\", \"title\": \"t51_project\"}")

if [ "$STATUS" = "201" ]; then
  echo "SSH key added successfully."
elif [ "$STATUS" = "422" ]; then
  echo "SSH key already exists, skipping."
else
  echo "Failed to add key. HTTP Status: $STATUS"
fi

# Add Git global config.
if [[ -z "$(git config user.email)" ]]; then
  git config --global init.defaultBranch main    # to avoid git asking to add it later
  git config --global user.email "${GITEA_ADMIN_EMAIL}"
  git config --global user.name "${GITEA_ADMIN_USER}"
  echo "Git config added"
else
  echo "Git config already set up"
fi


# INPUT
#   $1: Repository name used also in compressed file and URL
function addRepo {

  TOKEN_TWO=$(su-exec git gitea admin user generate-access-token \
  --username "${GITEA_ADMIN_USER}" \
  --token-name "$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 1)" \
  | awk '{print $NF}')
    
    # Attempt to create the repo via API
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X 'POST' \
      "http://localhost:3000/api/v1/user/repos" \
      -H "Authorization: token $TOKEN_TWO" \
      -H "Content-Type: application/json" \
      -d "{\"name\": \"$1\", \"private\": true}")


    if [ "$RESPONSE" = "201" ]; then
        echo "Successfully created repository: $1"

        # Generate content
        TAR_FILE="/tmp/initial_repos/$1.tar.xz"
        if [[ ! -f "$TAR_FILE" ]]; then
          echo "[ERROR]: Compressed file do not exist: $TAR_FILE"
          return 1
        fi

        mkdir -p /tmp/content-$1/ && cd /tmp/content-$1/
        tar -xJf /tmp/initial_repos/$1.tar.xz -C .
        
        # Create first commit
        git init
        git branch -M main # rename current branch to main, to be sure when pushing
        git add .
        git commit --quiet -m "Initial commit" &> /dev/null \
          && echo "Commit created on $1" \
          || echo "Commit Error on $1"
        
        # Use the token for passwordless push (safer than password)
        git push -q http://${TOKEN_TWO}@localhost:3000/${GITEA_ADMIN_USER}/${1}.git main

        rm -rf /tmp/repos/$1/$1.tar.xz

        echo "[SUCCESS]: Repo $1 added"

    elif [ "$RESPONSE" = "409" ] || [ "$RESPONSE" = "422" ]; then
        echo "Repository '$1' already exists. Skipping creation."
    else
        echo "Something went wrong creating repo. HTTP Status: $RESPONSE"
    fi
}

addRepo "$BACK_NAME"
sleep 1

addRepo "$FRONT_NAME"
sleep 1

addRepo "$DB_MIG_NAME"
sleep 1

addRepo "$DEVOPS_NAME"
sleep 1


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

  TOKEN=$(su-exec git gitea admin user generate-access-token \
    --username "${GITEA_ADMIN_USER}" \
    --token-name "$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 10)" \
    | awk '{print $NF}')

  if [ -z "$TOKEN" ]; then
    echo "[ERROR] TOKEN empty, it should have a random string."
    exit 1
  fi

  HOOK_URL="http://localhost:3000/api/v1/repos/${GITEA_ADMIN_USER}/${1}/hooks"
  HOOK_JENKINS="http://jenkins:8080/generic-webhook-trigger/invoke?token=${1}-${SHARED_TOKEN}"

  RESPONSE=$(curl -s -i -o /tmp/resp_${1}.txt -w "%{http_code}" -X 'POST'  \
    "${HOOK_URL}" \
    -H "Authorization: token $TOKEN" \
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
      echo "[DEBUG] TOKEN: ${TOKEN}"
      echo "[DEBUG] HOOK_URL: ${HOOK_URL}"
      echo "[DEBUG] HOOK_JENKINS: ${HOOK_JENKINS}"
      cat /tmp/resp_${1}.txt
    fi
    
}

addWebHook "$BACK_NAME"
sleep 1

addWebHook "$FRONT_NAME"
sleep 1

addWebHook "$DB_MIG_NAME"
sleep 1

addWebHook "$DEVOPS_NAME"
sleep 1



# Bring the background process back to the foreground to keep container alive
wait
