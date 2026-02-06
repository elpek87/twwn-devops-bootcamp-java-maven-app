#!/usr/bin/env bash

export IMAGE=$1 # first parameter passed to the script

docker compose -f docker-compose.yml up -d
echo "success"
