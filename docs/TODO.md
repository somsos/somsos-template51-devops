# ToDo

## Doing (First one is the current task)

- Check if I can create the custom-jenkins-image and create a .tar file to pull
it in offline, because to build this image required of apt update/install, and
for an offline setup this makes all more complex, but if i can have this as a
pre-build so internet is nor required anymore.


- [X] Check why db_utils is trying to re-build db_utils.dockerfile, and install a dependency from internet
  - Remember you created a new project with a new domain an ssh config.
  - [ ] Check on VR machine again

- [ ] Check why ./workspace/.env is empty

- [ ] Create an developer manual to set up his machine with the new environment server created
  - [ ] Tell about download the .env file
  - [ ] Mention about how to add a change in the pipelines
  - [ ] If I can NOT pre-approve the JCasC pipelines, mention to approve them when jenkins starts for firsts time.
  

- [ ] Check why I got a different version of devops-project when I cloned from new Gitea instance in Virtual Machine

- [ ] Add pre-approve to pipelines in JCasC or to the manual

- [ ] Set jenkins as private again public users can see the logs and here there are sensible data.

- [ ] Check if adding "user: "${MY_UID}:${DOCKER_GID}" to all services does
      not affect the current, this might avoid permission errors.


  - [ ] In ubuntu virtual machine
    - [X] Clone repo
    - [X] Copy dependencies
    - [X] Use install.md
    - [X] Use install.md again, just after finish
    - [X] Link Virtual Machine and host and check services created
    - [ ] Check jenkins pipeline for Database
      - [ ] Clone, change and push
      - [ ] check deploy
      - [ ] rollback
    - [ ] Check jenkins pipeline for Back
      - [ ] Clone, change and push
      - [ ] deploy
      - [ ] rollback
    - [ ] Check jenkins pipeline for Front
      - [ ] Clone, change and push
      - [ ] deploy
      - [ ] rollback

- [ ] Create a state/backup folder which takes the one called latest to start up,
  - [ ] Restore Database
  - [ ] Restore Backend
  - [ ] Restore Frontend

- [ ] Decide how to test the UI code (Jest, Cypress, etc)
  - [ ] Run them on Jenkins

- [ ] Check documentation of https://help.sonatype.com/en/sonatype-product-overview.html

- [ ] Create pipeline to add the HTTPS/SSL config.

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

- [ ] Check how to avoid exposing secrets for example
  - `docker exec jenkins printenv | grep PASS`
  - `docker exec gitea printenv | grep PASS`
  secrets that still can see them using `docker exec jenkins cat /run/secrets/my_secret` 
  but is not available for all proccesses
    - What happens if in my entrypoint I do this `export MY_PASS="$(cat /run/secrets/my_pass_secret)"` and then UNSET or override
    - What happends if i edit `jenkins.sh` the official file to start jenkins

- [ ] Combine the download_{back|db|devops|front}_repo.sh in just one function

- [ ] Automate Monitoring and Reporting
  - [ ] Study best approaches for this

## Resume

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
- [X] Check why in redlap the backend URL is wrong, it does not have the "api" subdomain part
- [X] Avoid in install command edit the .env.example, because it might be added an undesired change to the repo.
- [X] Check the timeout in building/deploy backend for slow hosts as redlap
- [X] Check the pipelines on offline mode (without internet)
    - ■■■ BAD IDEA: IT REDUCE THE PORTABILITY AND CREATE WEIRD FILE INTEGRITY ERRORS. ■■■
    - [X] Update Maven dependencies and copy .m2 on build image for building
    - [X] Update Node dependencies and copy node_modules on build image for building
- [X] Create a named volume for m2.
- [■] CANCELED Create a named volume for jenkins, I'm having problems with DinD
  - CANCELED BECAUSE A LOT OF WORK
- [X] Add to copy_env_file an arg to delete the password to the copied filed, if is not required
- [X] Create pipeline to execute tests and publish a status sticker
  - [X] Make the java tests pass
  - [X] make the pipeline can get the positive or negative result
  - [X] Use `badge_XXX.svg` to create the icon to publish
  - [X] Publish an static URL with a changing image
  - [X] Add URL to repository and see that the status match.
- [X] Set up a Sonatype Nexus Repository for maven.
  - [X] Add a compressed file to the repo with a pre-initialized nexus instance.
  - [X] add to Jenkins the public domain of nexus, so no change is required between envs.
    - [X] Check that I can connect from Jenkins to nexus
  - [X] use install.sh to uncompress it in the volume host folder.
  - [X] Use install.sh create an user with the credentials of app user.
  - [X] Add maven config to back.dockerfile
  - [X] Check that still builds in CLI and Jenkins
- [X] Set up a Sonatype Nexus Repository for `npm`.
  - [X] Use install.sh the necesary npm repositories
  - [X] Add npm-nexus config to front.dockerfile
  - [X] Check that still builds in CLI and Jenkins
- [X] offline mode using nexus.
  - [ ] Create a pre-configurated compressed file with 
    - [X] Pre-initialized
    - [X] Default credentials
    - [X] maven dependencies
    - [X] npm dependencies
    - [X] Create .tar file and save it in ./dep_data/`pre_initialized_nexus_mvn_npm.tar.xz`
  - [X] Use install.sh to copy the downloaded dependencies if exists `tar -czf nexus-blobs.tar.gz setup/nexus/vol-data/`
  - [X] Check that it can be created the new user with the full-compressed file
- [X] Add to installer `sudo pacman -S docker-buildx`.
- [X] Re-Check install.sh In my host using uninstall.md
  - [X] Use install.md
  - [X] database
    - [X] deploy
    - [X] rollback
  - [X] Back
    - [X] deploy 
    - [X] rollback
  - [X] Front
    - [X] deploy 
    - [X] rollback
