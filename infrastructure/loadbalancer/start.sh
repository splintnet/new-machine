#!/usr/bin/env bash

NETWORK=loadbalancer

docker network create traefik 1>/dev/null 2>/dev/null
docker-compose up -d
