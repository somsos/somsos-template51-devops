# RUN
ARG DB_MIG_IMAGE

FROM $DB_MIG_IMAGE

USER root

RUN apk add --no-cache tzdata postgresql17-client

RUN mkdir -p /t51/app/db/source && \
    chown -R liquibase:liquibase /t51/app/db/source

USER liquibase

COPY ./source /t51/app/db/source

COPY ./db_utils.entrypoint.sh /db_utils.entrypoint.sh

WORKDIR /t51/app/db/source

ENTRYPOINT [ "bash", "/db_utils.entrypoint.sh" ]