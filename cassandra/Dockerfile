FROM spotify/cassandra:latest

# install supervisord
RUN apt-get update
RUN apt-get install -y supervisor

# add our cassandra init query that's called from supervisord.conf
ADD init.cql init.cql

# add our supervisord.conf so we can call it in our entry point
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# our entry point kicks off cassandra and initializes the keyspace and column family
ENTRYPOINT ["/usr/bin/supervisord"]
