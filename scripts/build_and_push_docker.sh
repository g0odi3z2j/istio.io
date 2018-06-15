#!/usr/bin/env bash

HUB=gcr.io/istio-testing
VERSION=$(date +%Y-%m-%d)

docker build --no-cache -t $HUB/website-builder:$VERSION .
gcloud docker -- push $HUB/website-builder:$VERSION
