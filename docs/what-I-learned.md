# What I Learned

## TL:DR

- Keep the files host and volumes the same, because will need DinD, but if they
  are different you will have problems on syncing files.

- If you're using DinD avoid running containers mounting host volumes, either -v
  flag or `volume:` yaml property, It happened me that it was working fine and
  suddenly stopped working, and I had to do the same by building an image,
  because in that case the files are "copied" so there is no problem.