#!/usr/bin/env bash

if [ -z "$LOCALDEV_REPO" ]; then
  echo "Must specify LOCALDEV_REPO as arg."
  exit 1
fi

docker \
  run \
  --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $LOCALDEV_REPO:/repo \
  localdev \
  /repo/scripts/cluster-stop.sh