# RUN
ARG DB_MIG_IMAGE

FROM $DB_MIG_IMAGE

USER root

RUN apk add --no-cache tzdata postgresql17-client

USER liquibase

WORKDIR /t51/app/db/source