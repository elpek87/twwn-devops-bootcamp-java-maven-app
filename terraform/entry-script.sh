#!/bin/bash
dnf update -y
dnf install -y docker
systemctl enable docker
systemctl start docker

mkdir -p /usr/libexec/docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) -o /usr/libexec/docker/cli-plugins/docker-compose
chmod +x /usr/libexec/docker/cli-plugins/docker-compose
