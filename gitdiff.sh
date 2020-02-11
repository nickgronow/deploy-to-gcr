#!/bin/bash

PREVIOUS_COMMIT=$(git rev-parse --short HEAD^ 2> /dev/null)
COMMIT=$(git rev-parse --short HEAD 2> /dev/null)

DIR_PATH=$1
if [ ! -d "$DIR_PATH" ]; then
    echo "Directory '$DIR_PATH' not exists"
    exit 0
fi

if [ -z "$COMMIT" ]; then
    echo "No current commit... fail"
    exit 0
fi

if [ -z "$PREVIOUS_COMMIT" ]; then
    echo "No previous commit, files are changed!"
    exit 1
fi

# Check is files in given directory changed between commits
if [ "$(git diff --name-only HEAD^ HEAD $DIR_PATH)" ]; then
    echo "Files are changed"
    exit 1
else
    echo "Files remain unchanged"
    exit 0
fi
