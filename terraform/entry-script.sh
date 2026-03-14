#!/bin/bash
dnf update -y
dnf install -y docker
systemctl enable docker
systemctl start docker

export DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v5.0.1/docker-compose-linux-aarch64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
