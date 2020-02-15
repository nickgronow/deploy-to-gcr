#!/bin/sh

set -eoux pipefail

WORKING_DIR=${INPUT_WORKING_DIRECTORY-.}
HAS_CHANGED=true

if [ "$INPUT_CHECK_IF_CHANGED" ]; then
  HAS_CHANGED=$(gitdiff $WORKING_DIR)
fi

if [ $HAS_CHANGED = false ]; then
  echo "Nothing has changed.  Deployment unnecessary"
  exit 0;
fi

REPO_NAME="$($GITHUB_REPOSITORY | sed 's|^.*/||')"
REGISTRY="${INPUT_REGISTRY-gcr.io}"
PROJECT="$INPUT_PROJECT"
NAME="${INPUT_IMAGE_NAME-$REPO_NAME}"
TAG="$INPUT_IMAGE_TAG"
SHA="$GITHUB_SHA"
IMAGE="$REGISTRY/$PROJECT/$NAME"

echo "Full image name: $IMAGE:$TAG"

# Login to docker
echo "Authenticate docker"
echo $INPUT_SERVICE_KEY | docker login -u _json_key --password-stdin "https://$REGISTRY"

# Pull image
echo "Pull image..."
docker pull "$IMAGE:$TAG"

# Build image
echo "Build image..."
docker build \
  -t "$IMAGE:$TAG" \
  -t "$IMAGE:$SHA" \
  --cache-from "$IMAGE:$TAG" \
  --build-arg commit="$GITHUB_SHA" \
  "$WORKING_DIR"

echo "Push image..."
docker push "$IMAGE:$TAG"
docker push "$IMAGE:$SHA"
