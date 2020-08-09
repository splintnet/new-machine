#!/usr/bin/env bash

docker network create traefik 1>/dev/null 2>/dev/null
docker-compose up -d
