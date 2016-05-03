# Reddit (well, running it on [Bluemix](https://bluemix.net))

## Prereqs

### Services

  1. Compose.io PostgreSQL
  1. CloudAMQP
  1. Memcached Cloud
  
## Configuring Databases

### Configuring Cassandra

This is done for you! Via magical docker compose!

### Configuring PostgreSQL

Once our cloud hosted instance of PostgreSQL is running in compose,
we're going to create a table named `reddit`:

```PLpgSQL
CREATE DATABASE reddit OWNER admin
```

Note that you don't *need* to do this - you can configure your
deployment to access the default database `compose`, but that's no fun!


Next we need to define a few functions that our reddit webserver is
going to invoke. But first, we log in!

```shell
➜ psql "sslmode=require host=<host> port=<port> dbname=reddit user=admin"
Password: <>
```

The following functions are all from [setup_postgres.sh](https://github.com/reddit/reddit/blob/master/install/setup_postgres.sh):

```shell
reddit=> create or replace function hot(ups integer, downs integer, date timestamp with time zone) returns numeric as $$ select round(cast(log(greatest(abs($1 - $2), 1)) * sign($1 - $2) + (date_part('epoch', $3) - 1134028003) / 45000.0 as numeric), 7) $$ language sql immutable;
CREATE FUNCTION

reddit=> create or replace function score(ups integer, downs integer) returns integer as $$ select $1 - $2 $$ language sql immutable;
CREATE FUNCTION

reddit=> create or replace function controversy(ups integer, downs integer) returns float as $$ select CASE WHEN $1 <= 0 or $2 <= 0 THEN 0 WHEN $1 > $2 THEN power($1 + $2, cast($2 as float) / $1) ELSE power($1 + $2, cast($1 as float) / $2) END; $$ language sql immutable;
CREATE FUNCTION

reddit=> create or replace function ip_network(ip text) returns text as $$ select substring($1 from E'[\\d]+\.[\\d]+\.[\\d]+') $$ language sql immutable;
CREATE FUNCTION

reddit=> create or replace function base_url(url text) returns text as $$ select substring($1 from E'(?i)(?:.+?://)?(?:www[\\d]*\\.)?([^#]*[^#/])/?') $$ language sql immutable;
CREATE FUNCTION

reddit=> create or replace function domain(url text) returns text as $$ select substring($1 from E'(?i)(?:.+?://)?(?:www[\\d]*\\.)?([^#/]*)/?') $$ language sql immutable;
CREATE FUNCTION
```

### Configuring RabbitMQ

### Configuring Memcached

## Building

Once everything is configured, create your `myreddit.update` file, and
run `docker-compose build`

## Running

`docker-compose up`
