# Docker Compose Workflow

## Use just the Docker Compose commands and detect environment

The idea is just by running `docker compose [build|up] back` our service is
builded or deployed, but we have two different environments, when we run it in
the docker host, and when we run it in a container. The differences are:

- Docker host
  - we use the files in the project, so we do not have to commit a change to
    deploy or build, we just change a file run the command and we can se the
    changes.

- Container
  - When we run the docker compose command in an container, I assume is for a
    pipeline flow, so I download the code form the repository.

To keep it simple we only the following project structure and responsibilities

```shell
----.
----|----app
----|----|----back
----|----|----|----back_entrypoint.sh
----|----|----front
----|----|----|----front_entrypoint.sh
----|----|----db_mig
----|----|----|----db_mig_entrypoint.sh
```

Each entrypoint can notice if it's being run in a host or on a container, knowing
the difference it's going to use the files in the host or download them from the
repository.

So the steps for an build and deploy follows the next steps.

1. Download the files from the repository