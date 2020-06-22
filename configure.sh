#!/usr/bin/env bash

ISTIO_LOCALHOST=127.0.0.1
CASSANDRA_HOST="$(hostname --ip-address)"
CLUSTER_NAME="cluster"
WRITE_TIME_OUT=20000

##########################################################################################################################

sed -ri 's/^(# )?('"cluster_name"':).*/\2 '"$CLUSTER_NAME"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"
sed -ri 's/^(# )?('"write_request_timeout_in_ms"':).*/\2 '"$WRITE_TIME_OUT"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"

##########################################################################################################################

CASSANDRA_HOME=/opt/cassandra

sed -ri 's/^(# )?('"listen_address"':).*/\2 '"$ISTIO_LOCALHOST"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"
sed -ri 's/^(# )?('"rpc_address"':).*/\2 '"$ISTIO_LOCALHOST"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"
sed -ri 's/^(# )?('"broadcast_address"':).*/\2 '"$CASSANDRA_HOST"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"
sed -ri 's/^(# )?('"broadcast_rpc_address"':).*/\2 '"$CASSANDRA_HOST"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"

# config cassandra seeds
if [ -z "$CASSANDRA_SEEDS" ]; then
	CASSANDRA_SEEDS=$CASSANDRA_HOST
fi

sed -ri 's/(- seeds:).*/\1 "'"$CASSANDRA_SEEDS"'"/' "$CASSANDRA_HOME/conf/cassandra.yaml"

##########################################################################################################################

CASSANDRA_ETC=/etc/cassandra

sed -ri 's/^(# )?('"listen_address"':).*/\2 '"$ISTIO_LOCALHOST"'/' "$CASSANDRA_ETC/cassandra.yaml"
sed -ri 's/^(# )?('"rpc_address"':).*/\2 '"$ISTIO_LOCALHOST"'/' "$CASSANDRA_ETC/cassandra.yaml"
sed -ri 's/^(# )?('"broadcast_address"':).*/\2 '"$CASSANDRA_HOST"'/' "$CASSANDRA_ETC/cassandra.yaml"
sed -ri 's/^(# )?('"broadcast_rpc_address"':).*/\2 '"$CASSANDRA_HOST"'/' "$CASSANDRA_ETC/cassandra.yaml"

# config cassandra seeds
if [ -z "$CASSANDRA_SEEDS" ]; then
	CASSANDRA_SEEDS=$CASSANDRA_HOST
fi

sed -ri 's/(- seeds:).*/\1 "'"$CASSANDRA_SEEDS"'"/' "$CASSANDRA_ETC/cassandra.yaml"

##########################################################################################################################

exec "$@"