#!/bin/bash

ACCOUNT=markfirmware
DOCKER_IMAGE=$ACCOUNT/ultibohub-docker:2.0.029-1
alias uhub="docker run --rm -u $UID:$GID -i -v $(pwd):/workdir --entrypoint /bin/bash $DOCKER_IMAGE -c \"$*\""
