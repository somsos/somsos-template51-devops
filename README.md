# README

- [README](#readme)
  - [ToDo](#todo)
  - [How it works the DevOps pipeline](#how-it-works-the-devops-pipeline)
  - [Installation](#installation)
    - [Changes in Host (Docker-Host)](#changes-in-host-docker-host)
      - [Unblock the following ports](#unblock-the-following-ports)
      - [add domain in local domain /etc/hosts](#add-domain-in-local-domain-etchosts)
      - [Create a ssh key without keypass](#create-a-ssh-key-without-keypass)
    - [Deploy and setup gitea](#deploy-and-setup-gitea)
    - [Deploy and setup Jenkins](#deploy-and-setup-jenkins)
      - [Add permissions to docker.socket to jenkins](#add-permissions-to-dockersocket-to-jenkins)
      - [Create Jenkins Job](#create-jenkins-job)
  - [Endpoints for checking](#endpoints-for-checking)

## ToDo

- [ ] Add it to C.V.
- [ ] Implement rollback on back and front.
- [ ] Implement an evolutionary Database.
- [ ] Create the blog with the 3 diagrams and it explication of each layer.
- [ ] Add in manual before making developing tests, disconnect from internet and update the `/etc/hosts`

## How it works the DevOps pipeline

The idea is to abstract or reduce the commands to build and deploy,
to only the following two docker commands:

- `docker compose build {db|back|front}`
- `docker compose up -d {db|back|front}`

These two commands are standard on those who knows docker, and from
just watching them, they can get an idea of how works by behind, with
in resume, the `docker-compose.yml` defines how to run the containerized app,
and the `Dockerfile` defines how to build it and deploy it.

So in theory this two commands could build and deploy any kind of
app, whether it uses Java, Python, GoLand, Node, Angular, React, etc.

Here a graph of the working flow which goes from the git push to the
deploy of the app.

![devops pipeline flow](./1_documentation/devops-pipeline.png)

For the connections and https management, I'm using a reverse proxy
to centralize and facilitate the implementation.

![reverse-proxy-conf](./1_documentation/reverse-proxy-conf.png)

## Installation

### Changes in Host (Docker-Host)

Installed

- Ubuntu 24.04 LTS

- git v2.50.1

- OpenSSH_9.6p1

- Docker 28.3.2 (with Docker as a non-root user)

#### Unblock the following ports

```bash
sudo ufw allow 222 &&
sudo ufw allow 5432
sudo ufw allow 8080
sudo ufw allow 80
sudo ufw allow 3000
sudo ufw allow 443

# (optional) So the connections don't freeze,
# and instead notify it is being rejected/refused.
sudo ufw default reject incoming
```

#### add domain in local domain /etc/hosts

Add the new line `127.0.0.1       mariomv.duckdns.org` on /etc/hosts
so the scripts connect the same way inside the container or in host.

#### Create a ssh key without keypass

Generate it

```bash
ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519_nopass
```

Add it to conf so is used in gitea service

```c
Host mariomv.duckdns.org
    HostName mariomv.duckdns.org
    Port 222
    User git
    IdentityFile ~/.ssh/id_ed25519_nopass
    StrictHostKeyChecking no
```

<!--

-

-

-

-

-->

### Deploy and setup gitea

Initialize gitea using `docker compose up -g gitea` in the devops root
project folder.

1, Add allowed hosts in `data_gitea/gitea/conf/app.ini`

```ini
[webhook]
ALLOWED_HOST_LIST=mariomv.duckdns.org
```

2, Add in user setting the ssh key generated

```bash
id_ed25519_nopass.pub
```

3, Upload repositories back and front to gitea (using git push)

```bash
# With the names
template51_devops
template51_back
template51_front

# Using format
ssh://git@gitea.mariomv.duckdns.org:222/mario1/{{NAME}}.git
```

4, Add webhook on back and front repositories settings

```sh
http://jenkins.mariomv.duckdns.org/generic-webhook-trigger/invoke?token=someToken_xxxxx

Method: POST

POST Content Type: application/json
```

<!--

-

-

-

-->

### Deploy and setup Jenkins

deploy jenkins: `docker compose up -d jenkins`

#### Add permissions to docker.socket to jenkins

If executing `docker exec -t jenkins docker ps` there were an error:
`dial unix /var/run/docker.sock: connect: permission denied`.

Or before init jenkins container check the docker group number.
because it can change between machines, so, check that both
numbers match.

```shell
(host)$ getent group docker
#In my case 999

(host)$ cat jenkins-with-docker.dockerfile | grep groupadd
#In my case 999
```

1, If there is an error `Can not write on /var/jenkins_home/copy_reference.log. Wrong volume permissions?`
change the folder permisions using this command in the docker-host in root devops project.

```bash
sudo chown -R 1000:1000 ./data/jenkins
```

2, Select install the recommended plugins, on first run of Jenkins.

3, Install these extra plugins

- [gitea](https://plugins.jenkins.io/gitea/)
- [generic webhook trigger](https://plugins.jenkins.io/generic-webhook-trigger/)

#### Create Jenkins Job

1. Create a freestyle job
2. Check the "Generic Webhook Trigger" box.
   1. Note: for testing check the `Print post content` box for testing proposes.
3. Add in POST content parameters: name: "TRIGGERING_REPO" expression: "$.repository.name", Type: "JSONPath"
4. Add token (same as webhook): XXXX
5. In build steps add "Execute shell" and peste the contant of start.sh
    (comment the declaration of TRIGGERING_REPO)
6. (Optional) You can trigger the web hook manually like this

```shell
# Test running inside the jenkins container to see if there is communication
git clone  --depth=1 --single-branch --branch main ssh://git@gitea.mariomv.duckdns.org:222/mario1/template51_devops.git one



# Note the "Content-Type" header is important.

# name: template51_front - template51_back
curl -X POST --data '{"repository": { "name": "template51_front" }}' \
    -H "Content-Type: application/json" \
    https://jenkins.mariomv.duckdns.org/generic-webhook-trigger/invoke?token=someToken_xxxxx
```

<!--

-

-

-

-->

## Endpoints for checking

```sh
curl -X POST -i \
  --header "Content-Type: application/json" \
  --data '{"username":"mario1","password":"mario1p"}' \
  https://api.mariomv.duckdns.org/auth/create-token
```

mariomv.duckdns.org

eclipse-temurin:21-alpine
nginx:stable-alpine3.21

docker run --rm -ti --name temp-test \
  --add-host api.mariomv.duckdns.org:host-gateway \
  nginx:stable-alpine3.21 sh



url=jdbc:postgresql://mariomv.duckdns.org:5432/jab_db_test
spring.datasource.username=jab_db_user
spring.datasource.password=jab_db_pass

psql postgresql://jab_db_user:jab_db_pass@mariomv.duckdns.org:5432/jab_db_test
