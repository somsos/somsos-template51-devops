#!/bin/bash
set -e
#set -x # debug mode

source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
source "../0_scripts/check_necessary_variables.sh"
check_necessary_variables "$ENV"

# Check environment variables dependency.
if [[ "$ENV" == "HOST" ]]; then
    read -p "Enter the image ID to tag: " IMAGE_ID
    read -p "Enter the new tag for the image (e.g., 'latest' or 'v1.0'): " NEW_TAG  
fi
if [[ -z "$BACK_NAME" ]]; then 
    echo "[ERROR] Variable 'BACK_NAME' is not set, it must be set in environment variables."
    exit 1
fi
if [[ -z "$FRONT_NAME" ]]; then
    echo "[ERROR] Variable 'FRONT_NAME' is not set, it must be set in environment variables."
    exit 1
fi



# Check script arguments.
LAYER="$1"
if [ "$LAYER" != "back" ] && [ "$LAYER" != "front" ]; then
    echo "[ERROR] File argument LAYER (\$1) required: 'back' or 'front'"
    exit 1
fi
IMAGE_ID="$2"
if [[ -z "$IMAGE_ID" || ! "$IMAGE_ID" =~ ^[a-f0-9]+$ ]]; then
    echo "[ERROR] Image ID is required and must be a valid hexadecimal string."
    exit 1
fi
NEW_TAG="$3"
if [[ -z "$NEW_TAG" || ${#NEW_TAG} -gt 40 ]]; then
    echo "[ERROR] New tag is required and must be less than 40 characters."
    exit 1
fi

echo "IMAGE_ID: '$IMAGE_ID'"
echo "NEW_TAG: '$NEW_TAG'"

REG_HOST="registry.$MY_DOMAIN:5000"
if [ "$LAYER" == "back" ]; then
    IMG_NAME="$BACK_NAME"
fi
if [ "$LAYER" == "front" ]; then
    IMG_NAME="$FRONT_NAME"
fi
if [[ -z "$IMG_NAME" ]]; then
    echo "[ERROR] Image name for layer '$LAYER' is not set. Please set the appropriate variable in environment variables."
    exit 1
fi


PUBLIC_TAG="$REG_HOST/$IMG_NAME:$NEW_TAG"

docker tag "$IMAGE_ID" "$PUBLIC_TAG"
echo "[INFO] Image tagged successfully: $PUBLIC_TAG"

if ! docker push "$PUBLIC_TAG"; then
    echo "[ERROR] Failed to push image: $PUBLIC_TAG , removing the new tag."
    docker rmi "$PUBLIC_TAG" || true
    exit 1
fi

echo "[INFO] Image pushed successfully: $PUBLIC_TAG"

# ToDo
# curl -u user:password http://registry.mariomv-local.org:5000/v2/_catalog
# curl -u user:password http://localhost:5000/v2/_catalog

# curl -u user:password -X GET http://registry.mariomv-local.org:5000/v2/back/tags/list
# curl -u user:password -X GET http://localhost:5000/v2/back/tags/list
