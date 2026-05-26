# ToDo

## Doing (First one is the current task)

- [ ] Create/Prepare to create install script and manual.
  - [ ] Install script
    - [ ] Last tests in PC and start test in redlap
    - [X] Add host public key to gitea so the docker host can clone.
    - [X] Ask for user/pass, domain, email, env-type(local, stage, prod), 
    - [X] Pull images and set them for offline use.
    - [X] Start/build gitea
      - [X] Check initial repositories.
    - [X] Start/build Jenkins
      - [X] add `docker compose build --build-arg DOCKER_GID=$(getent group docker | cut -d: -f3) jenkins`
    - [X] Start reverse proxy
  - [ ] MANUAL (using just Jenkins)
    - [ ] Mention to 
      - [ ] Run Gitea first then Jenkins
      - [ ] Download the source code in the source directories
      - [ ] create the .env file using as template the .env.example file because for security is ignored in git
      - [ ] Add local domains to etc/hosts
      - [ ] Create secrets reading `setup/secrets/README_secrets.md`
      - [ ] Pre approve pipelines, so the first time the user execute a pipeline, it doesn't give an error ofr this
      - [ ] Add in `/etc/docker/daemon.json` the content `{ "insecure-registries": ["registry.$MY_DOMAIN:5000"] }` for docker login
    - [X] X. Database.
      - [X] X. Start service
      - [X] X. Build the db_utils container
      - [X] X. Install schema.
    - [X] X. Build/Start the backend container
    - [X] X. Build/Start the frontend container

- [ ] Check the pipelines on offline mode (without internet)
    - [ ] Update Maven dependencies and copy .m2 on build image for building
    - [ ] Update Node dependencies and copy node_modules on build image for building
- [ ] Restore Backend
- [ ] Restore Frontend

- [ ] Create pipeline to execute tests and publish a status sticker

- [ ] Check how to avoid exposing secrets for example
  - `docker exec jenkins printenv | grep PASS`
  - `docker exec gitea printenv | grep PASS`
  secrets that still can see them using `docker exec jenkins cat /run/secrets/my_secret` 
  but is not available for all proccesses
    - What happens if in my entrypoint I do this `export MY_PASS="$(cat /run/secrets/my_pass_secret)"` and then UNSET or override
    - What happends if i edit `jenkins.sh` the official file to start jenkins

- [ ] Decide how to test the UI code (Jest, Cypress, etc)
  - [ ] Run them on Jenkins

- [ ] Automate Monitoring and Reporting
  - [ ] Study best approaches for this

- [ ] Create pipeline to add the HTTPS/SSL config.

- [ ] Combine the download_{back|db|devops|front}_repo.sh in just one function

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
- [X] Return the docker compose command for database migrate deploy and rollback.
  - [X] One Layer to download
  - [X] Other layer to migrate/rollback
- [X] Return the docker compose command for database backup and restore.
- [X] Design idea of incremental versioning using files, e.g.,  back/VERSION
- [X] CasC in Gitea to create webhook to trigger Jenkins pipelines
  - [X] Deploy
    - [X] Back D
    - [X] Front D
    - [X] Database D
- [X] Create scripts/commands/pipeline for Frontend Database
- [X] Create scripts/commands/pipeline for Backend Rollback
- [ ] Create pipeline/button for Backend Rollback (I already have the bash scripts)
- [X] Create scripts/commands/pipeline for Frontend Rollback
- [X] Add notes why I'm not using webhook for rollback and the alternative of using `revert`.
- [X] Deploy and Rollback by layer
  - [X] Back
  - [X] Front
  - [X] Database
- [X] Create scenarios where I need to use Deploy and Rollback back and front
- [X] Create scenarios where I need to use Deploy and Rollback back and database
- [X] Fix Avoid the creation of extra/multiple back webhooks in gitea entrypoint.
- [X] Create scenarios where I need to use Deploy and Rollback the 3 layers
- [X] Add in Docker-Control pipeline command to see the containers status
- [X] Research how to use docker image registry for containers app backup
  - `docker compose build --tag back:${BUILD_NUMBER} back`
  - `git log -1 --pretty=format:%h`
  - An image can be tagged several times, so we can refer to the same image with different tags, for example, Note, the first tag is the original/official name, and the second one is the alias.
    - docker tag back:${BUILD_NUMBER}-${COMMIT_ID} back:1.2.3
    - docker tag back:${BUILD_NUMBER}-${COMMIT_ID} back:${COMMIT_ID}
- [X] Create image tagging strategy for backend
  - [X] Backup Backend (with tagging strategy I also create backups )
- [X] Create image tagging strategy for frontend
  - [X] Backup Frontend (with tagging strategy I also create backups )
- [X] Update all the initial_repos, do not forget to keep the same name and remove the .git folder
- [X] Create a initial setup script 
  - [X] X. Build Jenkins passing the docker group id to the build commnad
      - `docker compose build --build-arg DOCKER_GID=$(getent group docker | cut -d: -f3) jenkins`
  - [X] X. Add to jenkins the "ssh-keyscan -p 222 gitea.${MY_DOMAIN} > ./shared/known_hosts"
- [X] Put together the used docker images
- [X] Security Hide .env passwords
- [X] CHeck the use of .env in pipelines because I deleted it from the repo.
- [X] Add tag to images to mark production candidates.
  - [X] Add credentials for docker login in Registry-actions pipeline
  - [X] List Images
  - [X] Use just Jenkins to tag and list de available images, because an UI requieres wierd secret conf.
- [X] Purge Images, get rid of images that are not candidates to production.
  - [X] Delete Dangling images
  - [X] Delete images selected by the user
- [X] Add healthcheck to gitea, jenkins, reverse-proxy, registry
