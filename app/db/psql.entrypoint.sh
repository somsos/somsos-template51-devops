#!/bin/bash
set -e
# set -x


if [ -z "$PGDATABASE" ]; then
    echo "[ERROR] var PGDATABASE not found"
    exit 1
fi

if [ -z "$PGHOST" ]; then
    echo "[ERROR] var PGHOST not found"
    exit 1
fi

if [ -z "$PGPORT" ]; then
    echo "[ERROR] var PGPORT not found"
    exit 1
fi

if [ -z "$PGUSER" ]; then
    echo "[ERROR] var PGUSER not found"
    exit 1
fi

if [ -z "$PGPASSWORD" ]; then
    echo "[ERROR] var PGPASSWORD not found"
    exit 1
fi

VERSION=$(psql -t -A -c \
"SELECT tag FROM databasechangelog \
    WHERE tag IS NOT NULL \
    ORDER BY orderexecuted DESC \
    LIMIT 1" 2> /dev/null \
    || echo "0"
);

if [ -z "$VERSION" ]; then
    VERSION="0";
fi

echo "VERSION: $VERSION"

