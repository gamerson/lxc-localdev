#!/usr/bin/env bash

set -e

REPO="${LOCALDEV_REPO:-/repo}"

# Check to see if tilt is up, if so tell that container to build, otherwise we can call build

TILT_CONTAINER=$(docker container list --format '{{json .}}' | jq -sr '.[] | select(.Names=="localdev-extension-runtime")')

BUILD_CMD="/workspace/gradlew --project-dir /workspace clean build"

# call the build command at appropriate location

if [ "$TILT_CONTAINER" != "" ]; then
  BUILD_OUTPUT=$(docker exec -i $TILT_CONTAINER "sh -c \"$BUILD_CMD\"")
else
  BUILD_OUTPUT=$($BUILD_CMD)
fi

# now we have built client extensions, search for the zips and then return in a string

find /workspace/client-extensions -name 'dist/*.zip' 