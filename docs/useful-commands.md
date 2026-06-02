# Useful Commands

docker compose --env-file ./.env -f ./setup/docker-compose-devops.yml config jenkins

```shell
docker run --rm \
  -v t51m2_vol2:/mnt/vol \
  nginx:stable-alpine3.23 \
  find /mnt/vol | less
```
