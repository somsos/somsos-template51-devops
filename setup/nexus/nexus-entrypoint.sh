#!/bin/bash
set -e
#set -x


NEXUS_URL="http://nexus:8081"
NEXUS_API="$NEXUS_URL/service/rest/v1/security/users"
NEXUS_REPO_API="$NEXUS_URL/service/rest/v1/repositories"

DEFAULT_USER="admin"
DEFAULT_PASS="admin123"


function check_dependencies {
  if [ -z "$NEW_NEXUS_USER" ]; then
    echo "Error: NEW_NEXUS_USER environment variable is not set."
    exit 1
  fi

  if [ -z "$NEW_NEXUS_PASS" ]; then
    echo "Error: NEW_NEXUS_PASS environment variable is not set."
    exit 1
  fi
}

function wait_for_nexus {
  echo "Waiting for Nexus to be ready..."
  until curl -s -f "$NEXUS_URL/service/rest/v1/status" > /dev/null; do
    echo "Nexus not ready yet..."
    sleep 5
  done
  echo "Nexus is ready!"
}

function if_new_credentials_work_stop_configuration {
  RESPONSE_USERS=$(curl -s -o /dev/null -w "%{http_code}"  "$NEXUS_API" -u "$NEW_NEXUS_USER:$NEW_NEXUS_PASS")
  if [ "$RESPONSE_USERS" == "200" ]; then
    echo "new credentials are working. Skipping configuration."
    exit 0;
  fi
}

function if_old_credentials_do_not_work_exit_failing_conf {
  RESPONSE_USERS_2=$(curl -s -o /tmp/response_users_list.log -w "%{http_code}"  "$NEXUS_API" -u "$DEFAULT_USER:$DEFAULT_PASS")
  if [ "$RESPONSE_USERS_2" != "200" ]; then
    echo "Unexpected error default and new credentials not working. Please check Nexus logs for more details."
    exit 1;
  fi
  #cat /tmp/response_users_list.log
}


function change_password_to_default_user {
  echo "Setting admin password..."
  CHANGE_PASS_URL="$NEXUS_API/$DEFAULT_USER/change-password"
  CHANGE_PASS_RESPONSE=$(curl -s -o /tmp/response_change_pass.log -w '%{http_code}' -X PUT "$CHANGE_PASS_URL" \
    -H "Content-Type: text/plain" \
    -u "$DEFAULT_USER:$DEFAULT_PASS" \
    -d "${NEW_NEXUS_PASS}"
  )
  if [ "$CHANGE_PASS_RESPONSE" != 204 ]; then
    echo "error: unexpected change-password response \"$CHANGE_PASS_RESPONSE\"."
    cat /tmp/response_change_pass.log
    exit 1
  fi
  echo "Password changed to default user \"$DEFAULT_USER\"."
}


function create_new_user_with_admin_privileges {
  if [ "$DEFAULT_USER" == "$NEW_NEXUS_USER" ]; then
    if [ "$DEFAULT_PASS" == "$NEW_NEXUS_PASS" ]; then
      echo "default and new credentials are the same, skipping creating new user."
      return 0
    fi
    echo "username the same but different password, changing password"
    change_password_to_default_user
    return 0
  fi

  CREATE_RESPONSE=$(curl -s -o /tmp/response_create.log -w '%{http_code}' \
    -X POST "$NEXUS_API" \
    -u "$DEFAULT_USER:$DEFAULT_PASS" \
    -H 'Content-Type: application/json' \
    -d "{
      \"userId\" : \"$NEW_NEXUS_USER\",
      \"password\" : \"$NEW_NEXUS_PASS\",
      \"firstName\" : \"Administrator\",
      \"lastName\" : \"User\",
      \"emailAddress\" : \"$NEW_NEXUS_USER@example.org\",
      \"status\" : \"active\",
      \"roles\": [ \"nx-admin\" ]
    }"
  )
  if [ "$CREATE_RESPONSE" == "200" ]; then
    echo "User $NEW_NEXUS_USER created successfully."
  else
    echo "Unexpected response $CREATE_RESPONSE for user creation. Please check Nexus logs for more details."
    cat /tmp/response_create.log
    exit 1;
  fi
  RESPONSE_USERS_3=$(curl -s -o /dev/null -w "%{http_code}"  "$NEXUS_API" -u "$NEW_NEXUS_USER:$NEW_NEXUS_PASS")
  if [ "$RESPONSE_USERS_3" != "200" ]; then
    echo "New credentials are not working."
    exit 1;
  fi
}


function delete_default_admin_user {
  DELETE_RESPONSE=$(curl -s -o /tmp/response_deletion.log -w '%{http_code}' \
    -X DELETE "$NEXUS_API/$DEFAULT_USER" \
    -u "$NEW_NEXUS_USER:$NEW_NEXUS_PASS"
  )
  if [ "$DELETE_RESPONSE" == "204" ]; then
    echo "Default user $DEFAULT_USER deleted successfully."
  else
    echo "Unexpected response $DELETE_RESPONSE for user deletion. Please check Nexus logs for more details."
    cat /tmp/response_deletion.log
  fi
}


function create_npm_proxy_repo {
  echo "Creating npm proxy repository..."
  curl -s -o /dev/null -w "%{http_code}" \
    -X POST "$NEXUS_REPO_API/npm/proxy" \
    -u "$NEW_NEXUS_USER:$NEW_NEXUS_PASS" \
    -H "Content-Type: application/json" \
    -d '{
      "name": "npm-proxy",
      "online": true,
      "storage": {
        "blobStoreName": "default",
        "strictContentTypeValidation": true
      },
      "proxy": {
        "remoteUrl": "https://registry.npmjs.org",
        "contentMaxAge": 1440,
        "metadataMaxAge": 1440
      },
      "negativeCache": {
        "enabled": true,
        "timeToLive": 1440
      },
      "httpClient": {
        "blocked": false,
        "autoBlock": true
      }
    }'
  echo " npm-proxy created."
}

function create_npm_hosted_repo {
  echo "Creating npm hosted repository..."
  curl -s -o /dev/null -w "%{http_code}" \
    -X POST "$NEXUS_REPO_API/npm/hosted" \
    -u "$NEW_NEXUS_USER:$NEW_NEXUS_PASS" \
    -H "Content-Type: application/json" \
    -d '{
      "name": "npm-hosted",
      "online": true,
      "storage": {
        "blobStoreName": "default",
        "strictContentTypeValidation": true,
        "writePolicy": "allow_once"
      }
    }'
  echo " npm-hosted created."
}

function create_npm_group_repo {
  echo "Creating npm group repository..."
  curl -s -o /dev/null -w "%{http_code}" \
    -X POST "$NEXUS_REPO_API/npm/group" \
    -u "$NEW_NEXUS_USER:$NEW_NEXUS_PASS" \
    -H "Content-Type: application/json" \
    -d '{
      "name": "npm-public",
      "online": true,
      "storage": {
        "blobStoreName": "default",
        "strictContentTypeValidation": true
      },
      "group": {
        "memberNames": ["npm-hosted", "npm-proxy"]
      }
    }'
  echo " npm-public group created."
}

function create_npm_repositories {
  create_npm_proxy_repo
  create_npm_hosted_repo
  create_npm_group_repo
}

function if_npm_repos_exist_skip {
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
    "$NEXUS_REPO_API/npm/proxy/npm-proxy" \
    -u "$NEW_NEXUS_USER:$NEW_NEXUS_PASS")
  if [ "$RESPONSE" == "200" ]; then
    echo "npm repositories already configured. Skipping."
    return 1
  fi
  return 0
}








check_dependencies

wait_for_nexus


echo "<<< Setting new user start"
if_new_credentials_work_stop_configuration
if_old_credentials_do_not_work_exit_failing_conf
create_new_user_with_admin_privileges
delete_default_admin_user
echo "Setting new user end >>>"


echo "<<< Setting up npm repositories start"
if_npm_repos_exist_skip && create_npm_repositories
echo "npm repositories done end >>>"


echo "[SUCCESS] Nexus configuration completed!"
