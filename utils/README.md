# Utils container

image for different devops operations, like creation of different types of backups.

## cheat sheet

```shell
docker build -f alpine-utils.dockerfile -t utils:1 .


BUILD_NUMBER=1 docker compose run --rm --no-deps -i --entrypoint bash db_backup

# create backup
pg_dump -h 172.30.0.101 -U jab_db_user -d jab_db_test -F p > \
    /app/backups/db_backup_$(echo $BUILD_NUMBER)_$(date +'%Y-%m-%d_%H-%M-%S').dump


#############

# Restore database

BACKUP_NAME=db_backup_2_2025-09-11_19-34-10.sql docker compose run --rm --no-deps -i --entrypoint bash db_restore

# restore backup
psql -h 172.30.0.101 -U jab_db_user -d jab_db_test < ./${BACKUP_NAME}


SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'jab_db_test'
AND leader_pid  IS NULL;
```
