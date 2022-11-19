FROM redis:6.2.2

LABEL author="symplesims"

COPY  ./redis.conf /etc/redis.conf

EXPOSE 6379

ENTRYPOINT  ["redis-server", "/etc/redis.conf"]
