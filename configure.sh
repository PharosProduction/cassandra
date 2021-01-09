#!/usr/bin/env bash
set -e

swapoff -a

# # first arg is `-f` or `--some-option` or there are no args
# if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
#   set -- cassandra -f "$@"
# fi

# # allow the container to be started with `--user`
# if [ "$1" = 'cassandra' -a "$(id -u)" = '0' ]; then
#   # Copy JMX files over. Create the directory in case it doesn't exist so
#   if [ -d "/etc/cassandra-jmx" ]; then
#     cp /etc/cassandra-jmx/*.* /etc/cassandra
#   fi

#   chown -R cassandra /var/lib/cassandra /var/log/cassandra "$CASSANDRA_CONFIG"
#   echo "Switching to user 'cassandra'..."
#   exec gosu cassandra "$BASH_SOURCE" "$@"
# fi

# POD_ORDINAL="${POD_NAME##*-}"
# POD_BROADCAST="10.43.50.1$POD_ORDINAL"

# _ip_address() {
#   # scrape the first non-localhost IP address of the container
#   # in Swarm Mode, we often get two IPs -- the container IP, and the (shared) VIP, and the container IP should always be first
#   ip address | awk '
#     $1 == "inet" && $NF != "lo" {
#       gsub(/\/.+$/, "", $2)
#       print $2
#       exit
#     }
#   '
# }

# if [ "$1" = 'cassandra' ]; then
  # if [ "$CASSANDRA_BROADCAST_ADDRESS_LIST" ]; then
  #   index=$((${HOSTNAME: -1}+1))
  #   myAddress=`echo "$CASSANDRA_BROADCAST_ADDRESS_LIST" | sed "$index q;d"`
    
  #   if [ "$myAddress" ]; then
  #     CASSANDRA_BROADCAST_ADDRESS="$myAddress"
  #     echo "Detected \$CASSANDRA_BROADCAST_ADDRESS_LIST, broadcast address is now set to $CASSANDRA_BROADCAST_ADDRESS"
  #   else
  #     >&2 echo "Detected \$CASSANDRA_BROADCAST_ADDRESS_LIST, but no address was found in CASSANDRA_BROADCAST_ADDRESS_LIST at line $index"
  #     >&2 echo "CASSANDRA_BROADCAST_ADDRESS_LIST:"
  #     >&2 echo "---------------------------------"
  #     >&2 printf "$CASSANDRA_BROADCAST_ADDRESS_LIST\n\n"
  #     exit -1
  #   fi
  # fi

  # : ${CASSANDRA_RPC_ADDRESS='0.0.0.0'}

  # : ${CASSANDRA_LISTEN_ADDRESS='auto'}
  # if [ "$CASSANDRA_LISTEN_ADDRESS" = 'auto' ]; then
  #   CASSANDRA_LISTEN_ADDRESS="$(_ip_address)"
  # fi

  # : ${CASSANDRA_BROADCAST_ADDRESS="$POD_BROADCAST"}
  # : ${CASSANDRA_BROADCAST_ADDRESS="$CASSANDRA_LISTEN_ADDRESS"}

  # if [ "$CASSANDRA_BROADCAST_ADDRESS" = 'auto' ]; then
  #   CASSANDRA_BROADCAST_ADDRESS="$(_ip_address)"
  # fi
  # : ${CASSANDRA_BROADCAST_RPC_ADDRESS:=$CASSANDRA_BROADCAST_ADDRESS}

  # if [ -n "${CASSANDRA_NAME:+1}" ]; then
  #   : ${CASSANDRA_SEEDS:="cassandra"}
  # fi
  # : ${CASSANDRA_SEEDS:="$CASSANDRA_BROADCAST_ADDRESS"}

  # CASSANDRA_ETC=/etc/cassandra

  # sed -ri 's/(- seeds:).*/\1 "'"$CASSANDRA_SEEDS"'"/' "$CASSANDRA_ETC/cassandra.yaml"

  # for yaml in \
  #   broadcast_address \
  #   broadcast_rpc_address \
  #   cluster_name \
  #   endpoint_snitch \
  #   listen_address \
  #   num_tokens \
  #   rpc_address \
  #   start_rpc \
  # ; do
  #   var="CASSANDRA_${yaml^^}"
  #   val="${!var}"
  #   if [ "$val" ]; then
  #     sed -ri 's/^(# )?('"$yaml"':).*/\2 '"$val"'/' "$CASSANDRA_ETC/cassandra.yaml"
  #   fi
  # done

  # sed -ri 's/^[# ]*('"prefer_local"'=).*/\1 '"true"'/' "$CASSANDRA_ETC/cassandra-rackdc.properties"

  # for rackdc in dc rack prefer_local; do
  #   var="CASSANDRA_${rackdc^^}"
  #   val="${!var}"
  #   if [ "$val" ]; then
  #     sed -ri 's/^[# ]*('"$rackdc"'=).*/\1 '"$val"'/' "$CASSANDRA_ETC/cassandra-rackdc.properties"
  #   fi
  # done

  # prefer_local=true

  CASSANDRA_HOME=/opt/cassandra

  # sed -ri 's/(- seeds:).*/\1 "'"$CASSANDRA_SEEDS"'"/' "$CASSANDRA_HOME/conf/cassandra.yaml"

  # for yaml in \
  #   broadcast_address \
  #   broadcast_rpc_address \
  #   cluster_name \
  #   endpoint_snitch \
  #   listen_address \
  #   num_tokens \
  #   rpc_address \
  #   start_rpc \
  # ; do
  #   var="CASSANDRA_${yaml^^}"
  #   val="${!var}"
  #   if [ "$val" ]; then
  #     sed -ri 's/^(# )?('"$yaml"':).*/\2 '"$val"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"
  #   fi
  # done

  # sed -ri 's/^[# ]*('"prefer_local"'=).*/\1 '"true"'/' "$CASSANDRA_HOME/conf/cassandra-rackdc.properties"

  # for rackdc in dc rack prefer_local; do
  #   var="CASSANDRA_${rackdc^^}"
  #   val="${!var}"
  #   if [ "$val" ]; then
  #     sed -ri 's/^[# ]*('"$rackdc"'=).*/\1 '"$val"'/' "$CASSANDRA_HOME/conf/cassandra-rackdc.properties"
  #   fi
  # done

# fi

CASSANDRA_HOST="$(hostname --ip-address)"
echo "AAAA CASSANDRA HOST: ${CASSANDRA_HOST}"
# CLUSTER_NAME="cluster"
# WRITE_TIME_OUT=20000
POD_ORDINAL="${POD_NAME##*-}"
echo "AAAA ORDINAL: ${POD_ORDINAL}"
POD_BROADCAST="$POD_NAME.cassandra-cql-$POD_ORDINAL.cassandra-ns.svc.cluster.local" # "10.43.50.1$POD_ORDINAL"
echo "AAAA POD_BROADCAST: ${POD_BROADCAST}"

##########################################################################################################################

# sed -ri 's/^(# )?('"cluster_name"':).*/\2 '"$CLUSTER_NAME"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"
# sed -ri 's/^(# )?('"write_request_timeout_in_ms"':).*/\2 '"$WRITE_TIME_OUT"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"

if [ -z "$CASSANDRA_BROADCAST_ADDRESS" ]; then
    CASSANDRA_BROADCAST_ADDRESS=$CASSANDRA_HOST
fi

if [ -z "$CASSANDRA_SEEDS" ]; then
	CASSANDRA_SEEDS=$CASSANDRA_BROADCAST_ADDRESS
fi

##########################################################################################################################

sed -ri 's/^(# )?('"listen_address"':).*/\2 '"$CASSANDRA_HOST"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"
sed -ri 's/^(# )?('"rpc_address"':).*/\2 '"0.0.0.0"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"
sed -ri 's/^(# )?('"broadcast_address"':).*/\2 '"$POD_BROADCAST"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"
sed -ri 's/^(# )?('"broadcast_rpc_address"':).*/\2 '"0.0.0.0"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"
sed -ri 's/(- seeds:).*/\1 "'"$CASSANDRA_SEEDS"'"/' "$CASSANDRA_HOME/conf/cassandra.yaml"

# sed -ri 's/^(# )?('"endpoint_snitch"':).*/\2 '"GossipingPropertyFileSnitch"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"
# sed -ri 's/^(# )?('"commitlog_total_space_in_mb"':).*/\2 '"4139"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"
# sed -ri 's/^(# )?('"cdc_total_space_in_mb"':).*/\2 '"2069"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"

# sed -ri 's/^(# )?('"enable_materialized_views"':).*/\2 '"true"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"
# sed -ri 's/^(# )?('"enable_sasi_indexes"':).*/\2 '"true"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"
# sed -ri 's/^(# )?('"enable_transient_replication"':).*/\2 '"true"'/' "$CASSANDRA_HOME/conf/cassandra.yaml"

rm "$CASSANDRA_HOME/conf/cassandra-topology.properties"

# sed -ri 's/^[# ]*('"prefer_local"'=).*/\1'"true"'/' "$CASSANDRA_HOME/conf/cassandra-rackdc.properties"

# for rackdc in dc rack prefer_local; do
#   var="CASSANDRA_${rackdc^^}"
#   val="${!var}"
  
#   if [ "$val" ]; then
#     sed -ri 's/^[# ]*('"$rackdc"'=).*/\1'"$val"'/' "$CASSANDRA_HOME/conf/cassandra-rackdc.properties"
#   fi
# done

##########################################################################################################################

# CASSANDRA_ETC=/etc/cassandra

# sed -ri 's/^(# )?('"listen_address"':).*/\2 '"$CASSANDRA_HOST"'/' "$CASSANDRA_ETC/cassandra.yaml"
# sed -ri 's/^(# )?('"rpc_address"':).*/\2 '"$CASSANDRA_HOST"'/' "$CASSANDRA_ETC/cassandra.yaml"
# sed -ri 's/^(# )?('"broadcast_address"':).*/\2 '"$CASSANDRA_HOST"'/' "$CASSANDRA_ETC/cassandra.yaml"
# sed -ri 's/^(# )?('"broadcast_rpc_address"':).*/\2 '"$CASSANDRA_HOST"'/' "$CASSANDRA_ETC/cassandra.yaml"
# sed -ri 's/(- seeds:).*/\1 "'"$CASSANDRA_SEEDS"'"/' "$CASSANDRA_ETC/cassandra.yaml"

# sed -ri 's/^(# )?('"endpoint_snitch"':).*/\2 '"GossipingPropertyFileSnitch"'/' "$CASSANDRA_ETC/cassandra.yaml"
# sed -ri 's/^(# )?('"commitlog_total_space_in_mb"':).*/\2 '"4139"'/' "$CASSANDRA_ETC/cassandra.yaml"
# sed -ri 's/^(# )?('"cdc_total_space_in_mb"':).*/\2 '"2069"'/' "$CASSANDRA_ETC/cassandra.yaml"

# sed -ri 's/^(# )?('"enable_materialized_views"':).*/\2 '"true"'/' "$CASSANDRA_ETC/cassandra.yaml"
# sed -ri 's/^(# )?('"enable_sasi_indexes"':).*/\2 '"true"'/' "$CASSANDRA_ETC/cassandra.yaml"
# sed -ri 's/^(# )?('"enable_transient_replication"':).*/\2 '"true"'/' "$CASSANDRA_ETC/cassandra.yaml"

# sed -ri 's/^[# ]*('"prefer_local"'=).*/\1'"true"'/' "$CASSANDRA_ETC/cassandra-rackdc.properties"

# for rackdc in dc rack prefer_local; do
#   var="CASSANDRA_${rackdc^^}"
#   val="${!var}"
  
#   if [ "$val" ]; then
#     sed -ri 's/^[# ]*('"$rackdc"'=).*/\1'"$val"'/' "$CASSANDRA_ETC/cassandra-rackdc.properties"
#   fi
# done

##########################################################################################################################

echo "Executing '$@'"
exec "$@"