#!/usr/bin/env bash

CASSANDRA_VERSION=cassandra:4.0-beta4
IMAGE_VERSION=manual-78

docker rmi cassandra:$CASSANDRA_VERSION

docker build -f Dockerfile -t pharosproduction/cassandra:latest \
  --build-arg cassandra_version=$CASSANDRA_VERSION \
  .
docker push pharosproduction/cassandra:latest

docker tag pharosproduction/cassandra:latest pharosproduction/cassandra:$IMAGE_VERSION
docker push pharosproduction/cassandra:$IMAGE_VERSION
