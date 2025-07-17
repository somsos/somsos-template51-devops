#!/bin/bash
set -e

# Request (testing this variable is created by "Generic Webhook Trigger plugin" when gets the webhook request)
TRIGGERING_REPO='template51-backend'


# This scripts run in jenkins, the rea

# Declarations

BRANCH="main"   # CAUTION: Keep sync with .env file

DATE="$(date +"%Y-%m-%d_%H.%M.%S")"

DEVOPS_DIR="devops_$DATE"

DEVOPS_REPO='ssh://git@localhost:22/mario1/template51_devops.git'



# Executions

: "${TRIGGERING_REPO:?Variable TRIGGERING_REPO is not set}"

echo "ENVIRONMENT: $BRANCH"

eval "$(ssh-agent -s)"

git clone  --depth=1 --single-branch --branch $BRANCH $DEVOPS_REPO $DEVOPS_DIR

cd $DEVOPS_DIR

bash ./JenkinsScript-build-and-deploy.sh $TRIGGERING_REPO
