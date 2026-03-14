# Readme for Back directory

## Useful commands

```sh
# Run container
docker run --rm --name temp_back t51back:0.0.1

# Copy file (3 commands)
docker create --name t51back-temp t51back:0.0.1
docker cp t51back-temp:/opt/template51/t51Back.jar ./t51Back.jar
docker rm t51back-temp
```
