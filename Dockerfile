FROM cassandra:3.11.6

ARG date

LABEL company="Pharos Production Inc."

ENV LANG=C.UTF-8 \
  REFRESHED_AT="$date" \
  TERM=xterm \
  DEBIAN_FRONTEND=noninteractive

ENV LUCENE_PLUGIN_VER=3.11.3.0

RUN curl -LO http://search.maven.org/remotecontent\?filepath\=com/stratio/cassandra/cassandra-lucene-index-plugin/${LUCENE_PLUGIN_VER}/cassandra-lucene-index-plugin-${LUCENE_PLUGIN_VER}.jar
RUN mv cassandra-lucene-index-plugin-${LUCENE_PLUGIN_VER}.jar /opt/cassandra/lib

COPY configure.sh /opt/cassandra
RUN chmod +x /opt/cassandra/configure.sh
RUN chown -R cassandra:cassandra /opt/cassandra

USER cassandra
WORKDIR /opt/cassandra

EXPOSE 7000 7001 7199 9042 9160

ENTRYPOINT ["/opt/cassandra/configure.sh"]
CMD ["/opt/cassandra/bin/cassandra", "-f"]