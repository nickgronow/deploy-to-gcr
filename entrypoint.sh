#!/bin/bash

set -eoux pipefail

WORKING_DIR=${INPUT_WORKING_DIRECTORY:-.}

if [ $INPUT_CHECK_IF_CHANGED != false ]; then
  PREVIOUS_COMMIT=$(git rev-parse --short HEAD^ 2> /dev/null)
  COMMIT=$(git rev-parse --short HEAD 2> /dev/null)

  # If WORKING_DIR is not set, nothing has changed
  if [ ! -d "$WORKING_DIR" ]; then
      echo "Nothing has changed"
      exit 0
  fi

  # If the current commit does not exist,
  # changes are not tracked here yet
  if [ -z "$COMMIT" ]; then
      echo "No commit found"
      exit 0
  fi

  # If the previous commit does not exist,
  # this is the first commit, so everything has changed
  if [ -z "$PREVIOUS_COMMIT" ]; then
      echo "First commit. Everything has changed"
  fi

  # Check is files in given directory changed between commits
  if [ "$(git diff --name-only HEAD^ HEAD $WORKING_DIR)" ]; then
      echo "Changes found.  Continuing to deploy"
  else
      echo "No changes have been found.  Deployment unnecessary"
      exit 0
  fi
fi

REPO_NAME="$(echo $GITHUB_REPOSITORY | sed -e 's|^.*/||')"
REGISTRY="${INPUT_REGISTRY:-gcr.io}"
PROJECT="$INPUT_PROJECT"
NAME="${INPUT_IMAGE:-$REPO_NAME}"
TAG="${INPUT_IMAGE_TAG:-latest}"
SHA="$GITHUB_SHA"
IMAGE="$REGISTRY/$PROJECT/$NAME"
DOCKERFILE="$(echo ${INPUT_DOCKERFILE:-Dockerfile} | sed -e 's|/$||')"

echo "Full image name: $IMAGE:$TAG"

# Login to docker
echo "Authenticate docker"
echo $INPUT_SERVICE_KEY | docker login -u _json_key --password-stdin "https://$REGISTRY"

# Build image
echo "Build image..."
BUILD_PARAMS="--build-arg commit=$SHA"
if [ ! -z "$INPUT_BUILD_ARGS" ]; then
  for ARG in $(echo "$INPUT_BUILD_ARGS" | tr ',' '\n'); do
    BUILD_PARAMS="$BUILD_PARAMS --build-arg ${ARG}"
  done
fi

if docker pull "$IMAGE:$TAG" 2>/dev/null; then
  BUILD_PARAMS="$BUILD_PARAMS --cache-from $IMAGE:$TAG"
fi

echo "docker build $BUILD_PARAMS -t $IMAGE:$TAG -t $IMAGE:$SHA -f $DOCKERFILE $WORKING_DIR"
docker build $BUILD_PARAMS -t $IMAGE:$TAG -t $IMAGE:$SHA -f $DOCKERFILE $WORKING_DIR

echo "Push image..."
docker push "$IMAGE:$TAG"
docker push "$IMAGE:$SHA"
