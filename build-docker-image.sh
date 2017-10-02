#!/bin/bash

ACCOUNT=markfirmware
TAG=2.0.029-1
docker build \
    -t $ACCOUNT/ultibohub-docker:$TAG \
    -f ultibohub-docker.dockerfile \
    .
