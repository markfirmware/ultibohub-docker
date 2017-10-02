# ultibohub-docker
Docker installation of the ultibohub repos

usage
-----
```
alias uhub="docker run --rm -u $UID:$GID -i -v $(pwd):/workdir --entrypoint /bin/bash markfirmware/ultibohub-docker:2.0.029-1 -c \"$*\""

uhub fpc test.lpr
```
