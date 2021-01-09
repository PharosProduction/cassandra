ARG cassandra_version

FROM $cassandra_version

LABEL company="Pharos Production Inc."

ENV LANG=C.UTF-8 \
  TERM=xterm \
  DEBIAN_FRONTEND=noninteractive

ENV LUCENE_PLUGIN_VER=3.11.3.0

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y -qq \
    dnsutils \
    libcap2-bin && \
  rm -rf /var/lib/apt/lists/*

COPY limits.conf /etc/security/limits.conf
COPY sysctl.conf /etc/sysctl.conf

RUN curl -LO http://search.maven.org/remotecontent\?filepath\=com/stratio/cassandra/cassandra-lucene-index-plugin/${LUCENE_PLUGIN_VER}/cassandra-lucene-index-plugin-${LUCENE_PLUGIN_VER}.jar
RUN mv cassandra-lucene-index-plugin-${LUCENE_PLUGIN_VER}.jar /opt/cassandra/lib

COPY configure.sh /opt/cassandra
RUN chmod +x /opt/cassandra/configure.sh

COPY ready-probe.sh /opt/cassandra
RUN chmod +x /opt/cassandra/ready-probe.sh

RUN chown -R cassandra:cassandra /opt/cassandra

USER cassandra
WORKDIR /opt/cassandra

EXPOSE 7000 7001 7199 9042 9160

ENTRYPOINT ["/opt/cassandra/configure.sh"]
CMD ["/opt/cassandra/bin/cassandra", "-f", "-Dcassandra.config=file:///opt/cassandra/conf/cassandra.conf"]