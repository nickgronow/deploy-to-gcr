#!/bin/bash

DIR_PATH=$1

PREVIOUS_COMMIT=$(git rev-parse --short HEAD^ 2> /dev/null)
COMMIT=$(git rev-parse --short HEAD 2> /dev/null)

# If dirpath is nto set, nothing has changed
if [ ! -d "$DIR_PATH" ]; then
    echo false
    exit 0
fi

# If the current commit does not exist,
# changes are not tracked here yet
if [ -z "$COMMIT" ]; then
    echo false
    exit 0
fi

# If the previous commit does not exist,
# this is the first commit, so everything has changed
if [ -z "$PREVIOUS_COMMIT" ]; then
    echo true
    exit 0
fi

# Check is files in given directory changed between commits
if [ "$(git diff --name-only HEAD^ HEAD $DIR_PATH)" ]; then
    echo true
else
    echo false
fi
