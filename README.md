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

### Configuring RabbitMQ

### Configuring Memcached

## Building

Once everything is configured, create your `myreddit.update` file, and
run `docker-compose build`

## Running

`docker-compose up`
