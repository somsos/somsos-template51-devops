#!/bin/bash
set -e

# Request (testing this variable is created by "Generic Webhook Trigger plugin"
# when gets the webhook request)
# TRIGGERING_REPO='template51-frontend'


# This scripts run in jenkins, the rea

# Declarations

BRANCH="main"   # CAUTION: Keep sync with .env file

DATE="$(date +"%Y-%m-%d_%H.%M.%S")"

DEVOPS_DIR="devops_$DATE"

DEVOPS_REPO="ssh://git@host.docker.internal:222/mario1/template51_devops.git"



# Executions

## Validation
: "${TRIGGERING_REPO:?Variable TRIGGERING_REPO is not set}"
if [[ "$TRIGGERING_REPO" != "template51_backend" && "$TRIGGERING_REPO" != "template51_frontend" ]]; then
  echo "TRIGGERING_REPO variable expected to be template51-frontend template51-backend, it was '$TRIGGERING_REPO'"
  exit 1
fi





## Logic

echo "ENVIRONMENT: $BRANCH"

eval "$(ssh-agent -s)"

git clone  --depth=1 --single-branch --branch $BRANCH $DEVOPS_REPO $DEVOPS_DIR

cd $DEVOPS_DIR

bash ./JenkinsScript-build-and-deploy.sh $TRIGGERING_REPO
