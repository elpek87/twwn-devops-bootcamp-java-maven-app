#!/bin/bash
dnf update -y
dnf install -y docker
systemctl enable docker
systemctl start docker

sudo mkdir -p /usr/libexec/docker/cli-plugins/
sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) -o /usr/libexec/docker/cli-plugins/docker-compose
sudo chmod +x /usr/libexec/docker/cli-plugins/docker-compose
