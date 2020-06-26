#!/usr/bin/env bash

CASSANDRA_VERSION=cassandra:3.11.6
IMAGE_VERSION=manual-3

docker rmi cassandra:$CASSANDRA_VERSION

docker build -f Dockerfile -t pharosproduction/cassandra:latest \
  --build-arg cassandra_version=$CASSANDRA_VERSION \
  .
docker push pharosproduction/cassandra:latest

docker tag pharosproduction/cassandra:latest pharosproduction/cassandra:$IMAGE_VERSION
docker push pharosproduction/cassandra:$IMAGE_VERSION
