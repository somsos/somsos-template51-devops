#!/bin/bash
set -e

# IMPORTANT: When you update the script make sure to update the
# jenkins job configuration "`template51` -> shell" 

# Request (testing this variable is created by "Generic Webhook Trigger plugin"
# when gets the webhook request)
# TRIGGERING_REPO='template51-test'


# This scripts run in jenkins, the rea

# Declarations

BRANCH="main"   # CAUTION: Keep sync with .env file

DEVOPS_REPO="ssh://git@gitea.mariomv.duckdns.org:222/mario1/template51_devops.git"

OPTION_A="template51_back"
OPTION_B="template51_front"
OPTION_C="template51_db"

## Validation
: "${TRIGGERING_REPO:?Variable TRIGGERING_REPO is not set}"
if [[ "$TRIGGERING_REPO" != "$OPTION_A" && "$TRIGGERING_REPO" != "$OPTION_B" && "$TRIGGERING_REPO" != "$OPTION_C" ]]; then
  echo "TRIGGERING_REPO variable expected to be $OPTION_A, $OPTION_B or $OPTION_C, it was '$TRIGGERING_REPO'"
  exit 1
fi

DEVOPS_DIR="$(echo $BUILD_NUMBER)_deploy_$TRIGGERING_REPO"




## Logic

echo "ENVIRONMENT: $BRANCH"

eval "$(ssh-agent -s)"

git clone  --depth=1 --single-branch --branch $BRANCH $DEVOPS_REPO $DEVOPS_DIR

cd $DEVOPS_DIR

bash ./JenkinsScript-build-and-deploy.sh $TRIGGERING_REPO
