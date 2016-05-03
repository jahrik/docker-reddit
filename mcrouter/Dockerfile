FROM jamescarr/mcrouter

EXPOSE 5000

COPY config.json /mcrouter/config.json

ENTRYPOINT mcrouter -p 5000 -f /mcrouter/config.json
