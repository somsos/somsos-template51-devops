# Readme for Back directory

## Useful commands

```sh
# Run container
docker run --rm --name temp_back t51back:0.0.1

# Copy file (3 commands)
docker create --name t51back-temp t51back:0.0.1
docker cp t51back-temp:/opt/template51/t51Back.jar ./t51Back.jar
docker rm t51back-temp

# Create a Postgres instance for developing back mode
docker run -d --rm --name local_db \
  -e POSTGRES_DB=local_schema \
  -e POSTGRES_USER=local_db_user \
  -e POSTGRES_PASSWORD=local_db_pass \
  -p 5003:5432 \
  postgres:17.6-alpine3.22 -c log_statement=all

# Run with development profile
mvn spring-boot:run -Dspring-boot.run.profiles=default,development

# Run test
curl -i http://localhost:8080/test
```
