FROM liquibase:4.33-alpine

WORKDIR /var/my_migrations

COPY ./source /var/my_migrations
COPY ./db_migrate_docker-entrypoint.sh /var/my_migrations/db_migrate_docker-entrypoint.sh

ENV DB_PREVIOUS_VERSION=v01

ENV DB_VERSION=v02
