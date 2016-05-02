CREATE KEYSPACE IF NOT EXISTS reddit
  WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE reddit;

CREATE COLUMNFAMILY IF NOT EXISTS permacache (
  k int PRIMARY KEY
);
