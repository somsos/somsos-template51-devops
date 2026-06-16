#!/bin/bash
set -e
set -x


NEXUS_URL="http://nexus:8081"
NEXUS_API="$NEXUS_URL/service/rest/v1/security/users"

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

  NEW_NEXUS_PASS="mario1p1p"
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


function create_new_user_with_admin_privileges {
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






check_dependencies

wait_for_nexus

if_new_credentials_work_stop_configuration

if_old_credentials_do_not_work_exit_failing_conf

create_new_user_with_admin_privileges

delete_default_admin_user


# ToDo: Create hosted Maven repository

# ToDo: Create proxy repository for Maven Central

# ToDo: Create group repository


echo "[SUCCESS] Nexus configuration completed!"
