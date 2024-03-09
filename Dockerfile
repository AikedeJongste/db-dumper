FROM alpine:latest

RUN apk add --no-cache bash wget libpq postgresql-client dcron curl

#COPY --from=postgres:14 /usr/bin/pg_dump /usr/bin/pg_dump14
#COPY --from=postgres:15 /usr/bin/pg_dump /usr/bin/pg_dump15
#COPY --from=postgres:16 /usr/bin/pg_dump /usr/bin/pg_dump16

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY run.sh /run.sh
RUN chmod +x /run.sh

RUN mkdir -p /mnt/target

ENTRYPOINT ["/entrypoint.sh"]

