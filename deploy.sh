#!/usr/bin/env bash

CASSANDRA_VERSION=cassandra:4.0

docker rmi cassandra:$CASSANDRA_VERSION

docker build -f Dockerfile -t pharosproduction/cassandra:latest \
  --build-arg cassandra_version=$CASSANDRA_VERSION \
  .
docker push pharosproduction/cassandra:latest