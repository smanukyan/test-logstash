#!/usr/bin/env bash

# Stop all docker containers
docker rm -f $(docker ps -a -q)

# Remove orphaned docker images "none"
docker rmi $(docker images -a | awk '/\<none\>/ { print $3 }')
