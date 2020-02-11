#!/bin/sh

HAS_CHANGED=true
WORKING_DIR=${INPUT_WORKING_DIRECTORY-.}

if [ "$INPUT_CHECK_IF_CHANGED" ]; then
  HAS_CHANGED=$(gitdiff $WORKING_DIRECTORY)
fi

if [ $HAS_CHANGED = false ]; then
  echo "Nothing has changed.  Deployment unnecessary"
  exit 0;
fi

set -e

BRANCH=$(echo $GITHUB_REF | rev | cut -f 1 -d / | rev)
LOCAL_IMAGE_NAME=${GITHUB_REPOSITORY}_${WORKING_DIRECTORY}:${GITHUB_SHA}
GCR_IMAGE_NAME=${INPUT_REGISTRY}/${INPUT_PROJECT}/${LOCAL_IMAGE_NAME}

echo "BRANCH = ${BRANCH}"
echo "LOCAL_IMAGE_NAME = ${LOCAL_IMAGE_NAME}"
echo "GCR_IMAGE_NAME = ${GCR_IMAGE_NAME}"

# service key

echo "$INPUT_GCP_SERVICE_KEY" | base64 --decode > "$HOME"/gcloud.json

# Prepare env vars if `env` is set to file 

if [ "$INPUT_ENV" ]; then
    ENVS=$(cat "$INPUT_ENV" | xargs | sed 's/ /,/g')
fi

if [ "$ENVS" ]; then
    ENV_FLAG="--set-env-vars $ENVS"
fi

# run 

echo "Authenticate docker"
echo $GCR_ACCT | docker login -u _json_key --password-stdin "https://$INPUT_GCR_HOST"

cd ${GITHUB_WORKSPACE}/${WORKING_DIRECTORY}

echo "\nBuild image..."
docker build -t ${LOCAL_IMAGE_NAME} .
echo "\nTag image..."
docker tag ${LOCAL_IMAGE_NAME} ${GCR_IMAGE_NAME}
echo "\nPush image..."
docker push "$GCR_IMAGE_NAME"
