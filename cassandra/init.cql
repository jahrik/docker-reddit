CREATE KEYSPACE reddit
  WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE reddit;

CREATE COLUMNFAMILY permacache (
  k int PRIMARY KEY
);
