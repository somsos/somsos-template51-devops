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



# 4. Generate a temporary API Token for the admin
# Note: '--name' is the label for the token itself
TOKEN=$(su-exec git gitea admin user generate-access-token \
  --username "${GITEA_ADMIN_USER}" \
  --token-name "SetupToken" | awk '{print $NF}')

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

# Attempt to create the repo via API
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X 'POST' \
  "http://localhost:3000/api/v1/user/repos" \
  -H "Authorization: token $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"$BACK_NAME\", \"private\": true}")


if [[ -z "$(git config user.email)" ]]; then
  git config --global init.defaultBranch main    # to avoid git asking to add it later
  git config --global user.email "${GITEA_ADMIN_EMAIL}"
  git config --global user.name "${GITEA_ADMIN_USER}"
  echo "Git config added"
else
  echo "Git config already set up"
fi




if [ "$RESPONSE" = "201" ]; then
    echo "Successfully created repository: $BACK_NAME"

    # Generate content
    mkdir -p /tmp/repos/back/content && cd /tmp/repos/back/content
    tar -xJf /tmp/repos/back/$BACK_NAME.tar.xz -C .
    
    # Create first commit
    git init
    git branch -M main # rename current branch to main, to be sure when pushing
    git add .
    git commit --quiet -m "Initial commit" &> /dev/null \
      && echo "Commit created on $BACK_NAME" \
      || echo "Commit Error on $BACK_NAME"
    
    # Use the token for passwordless push (safer than password)
    git push -q http://${TOKEN}@localhost:3000/${GITEA_ADMIN_USER}/${BACK_NAME}.git main

    echo "Initial content pushed to $BACK_NAME."
    rm -rf /tmp/init-repo

elif [ "$RESPONSE" = "409" ] || [ "$RESPONSE" = "422" ]; then
    echo "Repository '$BACK_NAME' already exists. Skipping creation."
else
    echo "Something went wrong creating repo. HTTP Status: $RESPONSE"
fi


# Bring the background process back to the foreground to keep container alive
wait
