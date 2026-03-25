# DevOps notes

at the level od this file, we need to put the parent pom.xml
of the file.

## Container for liquibase tests

```shell
docker run -ti --rm  --name liquibase_temp \
    -v ./source:/var/my_migrations \
    -w /var/my_migrations \
    liquibase:4.33-alpine sh
```
