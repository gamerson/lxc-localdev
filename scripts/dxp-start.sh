#!/usr/bin/env bash

set -ex

ADD_HOST1=coupon-issued-function.localdev.me:172.150.0.1
ADD_HOST2=coupon-added-function.localdev.me:172.150.0.1
IMAGE=dxp-localdev

if [ -z "$LOCALDEV_REPO" ]; then
  echo "Must specify LOCALDEV_REPO env var"
  exit 1
fi


KUBERNETES_CERTIFICATE=$(/repo/scripts/k8s-certificate.sh)
KUBERNETES_TOKEN=$(/repo/scripts/k8s-token.sh)

docker run \
  --name ${IMAGE}-server \
  --rm \
  -v liferayData:/opt/liferay/data:rw \
  -p 8000:8000 \
  -p 8080:8080 \
  -p 11311:11311 \
  -e KUBERNETES_SERVICE_HOST=k3d-localdev-server-0 \
  -e KUBERNETES_SERVICE_PORT=6443 \
  -e KUBERNETES_NAMESPACE=default \
  -e KUBERNETES_CERTIFICATE="$KUBERNETES_CERTIFICATE" \
  -e KUBERNETES_TOKEN="$KUBERNETES_TOKEN" \
  --add-host "$ADD_HOST1" \
  --add-host "$ADD_HOST2" \
  --network k3d-localdev \
  $IMAGE