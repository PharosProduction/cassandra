#!/usr/bin/env bash

docker build -f Dockerfile -t pharosproduction/cassandra:latest \
    --build-arg date="2020-05-19-1" \
    .
docker push pharosproduction/cassandra:latest
