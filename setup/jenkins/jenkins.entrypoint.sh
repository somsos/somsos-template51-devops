#!/bin/bash
set -e

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

exec /usr/bin/tini -- /usr/local/bin/jenkins.sh