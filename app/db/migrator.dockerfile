# RUN
ARG DB_MIG_IMAGE
FROM $DB_MIG_IMAGE

COPY ./source/ /app/migrations
WORKDIR /app/migrations

USER root
RUN chown -R liquibase:liquibase /app/migrations
USER liquibase

COPY ./migrator.entrypoint.sh /app/migrator.entrypoint.sh

ARG DB_USER
ARG DB_PASS
ARG DB_SERVER
ARG DB_SCHEMA
RUN rm -f /app/migrations/liquibase.properties && \
cat > /app/migrations/liquibase.properties <<-EOF
url=jdbc:postgresql://$DB_SERVER:5432/$DB_SCHEMA
username=$DB_USER
password=$DB_PASS
changeLogFile=changelog.xml
EOF

