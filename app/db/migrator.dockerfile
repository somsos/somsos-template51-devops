# RUN
ARG DB_MIG_IMAGE
FROM $DB_MIG_IMAGE

COPY ./source/ /app/migrations
WORKDIR /app/migrations

USER root
RUN chown -R liquibase:liquibase /app/migrations
USER liquibase

COPY ./migrator.entrypoint.sh /app/migrator.entrypoint.sh
