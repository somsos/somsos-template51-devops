#!/bin/bash
set -e

function add_gitea_to_known_hosts {
    SSH_DIR="/var/jenkins_home/.ssh"
    KNOWN_HOSTS="$SSH_DIR/known_hosts"
    mkdir -p "$SSH_DIR"
    touch "$KNOWN_HOSTS"
    if ssh-keygen -F gitea -f "$KNOWN_HOSTS" > /dev/null; then
        echo "[INFO] gitea already exists in known_hosts"
    else
        echo "[INFO] Adding gitea SSH fingerprint..."

        if ssh-keyscan -p 2222 gitea >> "$KNOWN_HOSTS" 2>/dev/null; then
            echo "[INFO] gitea fingerprint added successfully"
        else
            echo "[WARNING] Could not retrieve gitea SSH fingerprint"
            echo "[WARNING] Jenkins will continue startup"
        fi
    fi
}


function docker_login_to_registry {
    DOCKER_CONFIG_PATH="/root/.docker/config.json"
    REGISTRY="registry.$MY_DOMAIN:5000"

    if grep -q "$REGISTRY" "$DOCKER_CONFIG_PATH" 2>/dev/null; then
        echo "[INFO] Docker credentials for $REGISTRY already exist. Skipping login."
    else
        echo "$MY_PASS" | docker login "$REGISTRY" -u "$MY_USER" --password-stdin && {
            echo "[INFO] Docker login successful."
        } || {
            echo "[WARN] Docker login failed. Please check your credentials and registry status."
        }
    fi
}

####### END OF FUNCTION DEFINITIONS #######





docker_login_to_registry

add_gitea_to_known_hosts

exec /usr/bin/tini -- /usr/local/bin/jenkins.sh

