# chat-gpt

Do you see why the TRIGGERING_REPO variable is not getting set by generic-webhook-trigger plugin?

Plugin conf

Post content parameters:
    Variable: TRIGGERING_REPO
    Expression: $.repository.name
    type: JSONPath, XPath (both don't set it)

Request

```bash

curl -i -X POST \
    --data '{"repository": { "name": "Hi-There" }}' \
    http://localhost:3001/generic-webhook-trigger/invoke?token=71c27113071788c2f7874f58a584d1138a003693

Response
{
   "jobs" : {
      "template51" : {
         "id" : 20,
         "regexpFilterExpression" : "",
         "regexpFilterText" : "",
         "resolvedVariables" : {
            "TRIGGERING_REPO" : ""
         },
         "triggered" : true,
         "url" : "queue/item/20/"
      }
   },
   "message" : "Triggered jobs."
}
```

Build Steps: Execute shell

```bash
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
if [[ "$TRIGGERING_REPO" != "template51-backend" && "$TRIGGERING_REPO" != "template51-frontend" ]]; then
  echo "TRIGGERING_REPO variable expected to be template51-frontend template51-backend, it was '$TRIGGERING_REPO'"
  exit 1
fi





## Logic

echo "ENVIRONMENT: $BRANCH"

eval "$(ssh-agent -s)"

git clone  --depth=1 --single-branch --branch $BRANCH $DEVOPS_REPO $DEVOPS_DIR

cd $DEVOPS_DIR

bash ./JenkinsScript-build-and-deploy.sh $TRIGGERING_REPO
```

Behave: the job is triggered but the variable is not set