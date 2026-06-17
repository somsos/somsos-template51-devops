

## Todos los archivos y carpetas

```yml
./docker_installer/
  containerd.io_2.2.4-1~ubuntu.24.04~noble_amd64.deb
  docker-buildx-plugin_0.34.1-1~ubuntu.24.04~noble_amd64.deb
  docker-ce_29.5.3-1~ubuntu.24.04~noble_amd64.deb
  docker-ce-cli_29.5.3-1~ubuntu.24.04~noble_amd64.deb
  docker-compose-plugin_5.1.4-1~ubuntu.24.04~noble_amd64.deb
pre_initialized_nexus_mvn_npm.tar.xz
DB_IMAGE.tar
DB_MIG_IMAGE.tar
IMAGE_ACME_COMPANION.tar
IMAGE_CURL.tar
IMAGE_GITEA.tar
IMAGE_HTTPD.tar
IMAGE_JAVA.tar
IMAGE_JENKINS.tar
IMAGE_NEXUS.tar
IMAGE_NGINX.tar
IMAGE_NODE.tar
IMAGE_REGISTRY.tar
IMAGE_REVERSE_PROXY.tar
```


## Imagenes

Tal y como las entrega el comando `docker save --output <path/file.tar> <IMAGE_NAME>`

Em mi caso la ultima vez tuve esta lista de imagenes.

```yml
DB_IMAGE.tar
DB_MIG_IMAGE.tar
IMAGE_ACME_COMPANION.tar
IMAGE_CURL.tar
IMAGE_GITEA.tar
IMAGE_HTTPD.tar
IMAGE_JAVA.tar
IMAGE_JENKINS.tar
IMAGE_NEXUS.tar
IMAGE_NGINX.tar
IMAGE_NODE.tar
IMAGE_REGISTRY.tar
IMAGE_REVERSE_PROXY.tar
```

## docker installer

Se siguio la documentacion oficial para instalacion de ubuntu, en mi caso termine
con estos archivos

```yml
./docker_installer/
  containerd.io_2.2.4-1~ubuntu.24.04~noble_amd64.deb
  docker-buildx-plugin_0.34.1-1~ubuntu.24.04~noble_amd64.deb
  docker-ce_29.5.3-1~ubuntu.24.04~noble_amd64.deb
  docker-ce-cli_29.5.3-1~ubuntu.24.04~noble_amd64.deb
  docker-compose-plugin_5.1.4-1~ubuntu.24.04~noble_amd64.deb
```

## mvn and npm dependencies

Se crea un comprimido con el contenido de `setup/nexus/vol-data/*`, (CUIDADO: NO
debe de incluir la carpeta `vol-data` solo su contenido.)

```yml
pre_initialized_nexus_mvn_npm.tar.xz
```
