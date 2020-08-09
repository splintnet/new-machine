#!/usr/bin/env bash

docker network create db 1>/dev/null 2>/dev/null
docker-compose up -d
