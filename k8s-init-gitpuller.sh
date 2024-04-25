#!/bin/bash

# Check if target path is defined
if [ -z "$TARGET_PATH" ]; then
    echo "TARGET_PATH is not defined as an environment variable."
    exit 0
fi

# Check if source repository is defined
if [ -z "$SOURCE_REPO" ]; then
    echo "SOURCE_REPO is not defined as an environment variable."
    exit 0
fi

# Define source branch as main if not already defined
if [ -z "$SOURCE_BRANCH" ]; then
    SOURCE_BRANCH="main"
fi

# Pull git repository
gitpuller $SOURCE_REPO $SOURCE_BRANCH /home/$NB_USER/$TARGET_PATH

# Change ownership of target path
chown -R $NB_USER:$NB_USER /home/$NB_USER/$TARGET_PATH

