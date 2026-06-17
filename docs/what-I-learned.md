# What I Learned

## TL:DR

- When you create a `dockerfile` make sure you are creating and switching user,
  because by default use root and if create files this files belong to root and
  it's always a headache.

- When a folder does not exist in the container `docker run --rm -v ./not-exists:...`
  the folder `./not-exists` is created by the daemon (which runs as root).
  So thats why `./not-exists` will belong to `root`, the standard way to avoid
  this is by run a `mkdir` before running the Docker command, so the daemon does
  have to create the folder. and using either way `--user $(id -u):$(id -g)` or
  `user: "${UID}:${GID}"`.

- Make the secret management first, if you do it after you will have to test again.

- Keep the files host and volumes the same, because will need DinD, but if they
  are different you will have problems on syncing files.

- If you're using DinD avoid running containers mounting host volumes, either -v
  flag or `volume:` yaml property, It happened me that it was working fine and
  suddenly stopped working, and I had to do the same by building an image,
  because in that case the files are "copied" so there is no problem.

- Adding tags in **liquibase** is at the start not at the end, otherwise the
  rollback will delete also the tag, and that behavior is not useful, check
  the chapter `liquibase.md#${id:mvi48blw}` for details.

- The flag `--force-recreate` in `docker compose up` re-create the container not
  the image, because if we just stop the container and not remove it, the next
  time will preserve the previous state, but if we recreate the container it's
  going to start with a new state, more details in
  `docker_pitfalls#{id:6fn04mh87}`.

- Be careful with the the order of `ARG` and `FROM` in the dockerfile when is
   passed trought docker-compose.yml using `build.args`
   `docker_pitfalls#id{mcg385nvh502hrc}#`

- In docker we have 2 runtimes, build-time and run-time, and in both we have to
  declare what network use, *it happened me* that I set up with the builder
  container and a nexus container, with this error `Name has no usable address`
  because I could reach it on run-time but not in build-time, so I had to
  add in my docker-compose.yml this property: `services.back.build.network: myNet`
  so I could have access to this network on buildtime.

