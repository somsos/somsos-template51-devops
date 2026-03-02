# README

- [README](#readme)
  - [ToDo](#todo)
  - [How it works the DevOps pipeline](#how-it-works-the-devops-pipeline)

## ToDo

- [ ] Create backup
  - [ ] For database
  - [ ] for backend
  - [ ] for frontend
- [ ] Create restore backup
  - [ ] for database
  - [ ] for backend
  - [ ] for frontend
- [ ] Create complete backup
- [ ] Create complete restore

## How it works the DevOps pipeline

The idea is to abstract or reduce the commands to build and deploy,
to only the following two docker commands:

- `docker compose build { db-migration | back | front}`
- `docker compose up -d { db-migration | back | front}`

These two commands are standard on those who knows docker, and from
just watching them, they can get an idea of how works by behind, with
in resume, the `docker-compose.yml` defines how to run the containerized app,
and the `Dockerfile` defines how to build it and deploy it.

So in theory this two commands could build and deploy any kind of
app, whether it uses MAriaDB, Java, GoLand, Angular, React, etc.

Here a graph of the working flow which goes from the `git push` to the
deploy of the app, and in case of rollback it's the same pipeline
just instead of using `git commit` we use `git revert` to apply again the
commit that was working before.

![devops pipeline flow](./1_documentation/devops-pipeline.png)

For the connections and https management, I'm using a reverse proxy
to centralize and facilitate the implementation.

![reverse-proxy-conf](./1_documentation/reverse-proxy-conf.png)

