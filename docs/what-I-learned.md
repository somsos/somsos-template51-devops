# What I Learned

## TL:DR

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
