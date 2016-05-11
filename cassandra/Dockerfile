# Based off of https://github.com/docker-library/cassandra/blob/master/2.1/Dockerfile
# and https://github.com/reddit/reddit/blob/master/install/install_cassandra.sh

FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive

# explicitly set user/group IDs
RUN groupadd -r cassandra --gid=999 \
  && useradd -r -g cassandra --uid=999 cassandra

# install dependencies
RUN apt-get update \
  && apt-get install -y \
    sudo \
    wget \
    software-properties-common \
    python-software-properties \
    ca-certificates \
    supervisor

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& rm -rf /var/lib/apt/lists/* \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 514A2AD631A57A16DD0047EC749D6EEC0353B12C

# add the datastax cassandra repos
RUN echo 'deb http://debian.datastax.com/community stable main' >> /etc/apt/sources.list.d/cassandra.list
RUN wget -qO- -L https://debian.datastax.com/debian/repo_key | \
        sudo apt-key add -

# add the reddit ppa
RUN apt-add-repository -y ppa:reddit/ppa

# pin the ppa -- packages present in the ppa will take precedence over
# ones in other repositories (unless further pinning is done)
RUN bash -c 'echo -e "Package: *\n\
  Pin: release o=LP-PPA-reddit\n\
  Pin-Priority: 600\n" >/etc/apt/preferences.d/reddit'

# install cassandra
RUN apt-get update \
	&& sudo apt-get install -y cassandra=1.2.19 \
	&& rm -rf /var/lib/apt/lists/*

# https://issues.apache.org/jira/browse/CASSANDRA-11661
RUN sed -ri 's/^(JVM_PATCH_VERSION)=.*/\1=25/' /etc/cassandra/cassandra-env.sh

ENV CASSANDRA_CONFIG /etc/cassandra

ADD cassandra-singlenode.sh /usr/local/bin/cassandra-singlenode
ADD init.cql init.cql
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]

RUN mkdir -p /var/lib/cassandra "$CASSANDRA_CONFIG" \
	&& chown -R cassandra:cassandra /var/lib/cassandra "$CASSANDRA_CONFIG" \
	&& chmod 777 /var/lib/cassandra "$CASSANDRA_CONFIG"
VOLUME /var/lib/cassandra

# 7000: intra-node communication
# 7001: TLS intra-node communication
# 7199: JMX
# 9042: CQL
# 9160: thrift service
EXPOSE 7000 7001 7199 9042 9160

