# Useful Commands

docker compose --env-file ./.env -f ./setup/docker-compose-devops.yml config jenkins

```shell


$ docker run -ti --rm -v ./this-does-not-exists:/tmp/something nginx:stable-alpine3.23 touch /tmp/something/myFile.txt
$ ls -la this-does-not-exists/
drwxr-xr-x  2 root  root  4096 Jun  2 11:18 .
-rw-r--r--  1 root  root     0 Jun  2 11:18 myFile.txt


docker run --rm \
  --user $(id -u):$(id -g) \
  -v ./test-3:/tmp/something \
  nginx:stable-alpine3.23 \
  touch /tmp/something/myFile.txt
```
