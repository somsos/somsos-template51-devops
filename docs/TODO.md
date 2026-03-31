# ToDo

## Doing (First one is the current task)

- [ ] Return the docker compose command for database migrate deploy and rollback.
  - [ ] One Layer to download
  - [ ] Other layer to migrate/rollback
- [ ] Return the docker compose command for database backup and restore.
- [ ] Design idea of incremental versioning using files, e.g.,  back/VERSION
- [ ] CasC in Gitea to create webhook to trigger Jenkins pipelines
  - [ ] Deploy
    - [ ] Back D
    - [ ] Front D
    - [ ] Database D
  - [ ] Rollback
    - [ ] Back R
    - [ ] Front R
    - [ ] Database R
- [ ] Create scenarios where I need to use all the DevOps features
  - [ ] Deploy and Rollback by layer
    - [ ] Back
    - [ ] Front
    - [ ] Database
  - [ ] Deploy and Rollback back and front
  - [ ] Deploy and Rollback back and database
  - [ ] Deploy and Rollback 3 layers
- [ ] Restore Backend
- [ ] Restore Frontend


## Resume

### Write a manual of how to start the project

Make an manual of how to start the project from an .zip file, and then
upload the manual and the file to github or linkedin.

### My Git flow

I just finished the deploy and rollback on database, I will try the rollback
on backend and frontend by using `git revert`, something like make up an
scenery which I need to rollback the three layers (front, back and db).

**The problem that I have now** is that when i'm developing I do many commit, and
many of them are irrelevant on a production level, so...

I'm thinking on create a feature branch and then merge it to the environment I what
to deploy, using `--no-commit` y `--no-ff` to reduce the commits

```shell
git checkout back_PRODUCTION
git checkout -b new_feature_1

# make changes
git checkout back_develop
# I merge the changes and keep the noise out
git merge --no-commit --no-ff new_feature_1
git add . && git commit -m "implement of new_feature_1"

# if everything goes well I do the same in test
git checkout back_test
git merge --no-commit --no-ff new_feature_1
git add . && git commit -m "implement of new_feature_1"

# If everything goes well I do the same in PRODUCTION
git checkout back_PRODUCTION
git merge --no-commit --no-ff new_feature_1
git add . && git commit -m "implement of new_feature_1"
```

So in theory this way there is no much details hidden, because
the environment branches are just to deploy in previous environments
without modify the PRODUCTION branch.
and the feature branches should be merged/committed the most often
posible.

## List

- [ ] Make a drawing of how would work the git strategy and their commits.
- [ ] Create a happy-path scenery to deploy in all layers.
- [ ] Create an all-bad scenery to rollback in all layers.
- [ ] Include it in your the blog.

<!--
          .
          .
          .
-->

## Finished (Last one is more recently finished)

- [X] (DISCARDED IDEA) use conf.json in docker.
- [X] Implement JCasC `https://plugins.jenkins.io/configuration-as-code/`
- [X] Gitea admin user creation
- [X] Gitea back repository
- [X] Jenkins admin user creation
- [X] Create Gitea front repository
- [X] Create Gitea DbMig repository
- [X] Create Gitea DevOps repository
- [X] I changed the commands runner using JCasC "jenkins.yml -> unclassified:->shell:->shell: "/bin/bash""
- [X] Back Pipeline to build and deploy
  - [X] Using the jenkins terminal for unitary tests create
    - [X] script for download
    - [X] script for build
    - [X] script for deploy
  - [X] Create pipeline and using source command call the scripts
    - [X] Using $JOB_NAME get sure the scripts will run in shell and pipeline
- [X] Front Pipeline to build and deploy
  - [X] I did it like the backend pipeline
- [X] Jenkins pipeline for Docker control.
- [X] DbMig Deploy Pipeline
  - [X] Use a file to manage the version
- [X] DbMig Rollback Pipeline
- [X] Avoid using Docker in Docker for database migrations, because at the moment
    of mounting a volume the files were not accesible
- [X] DbMig Backup
- [X] DbMig Restore Backup
