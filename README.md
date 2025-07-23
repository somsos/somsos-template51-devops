# README

- [README](#readme)
  - [ToDo](#todo)
  - [How it works this DevOps pipeline](#how-it-works-this-devops-pipeline)
  - [Installation](#installation)
    - [Changes in Host (Docker-Host)](#changes-in-host-docker-host)
      - [Unblock the following ports](#unblock-the-following-ports)
      - [add domain in local domain /etc/hosts](#add-domain-in-local-domain-etchosts)
      - [Create a ssh key without keypass](#create-a-ssh-key-without-keypass)
    - [Changes in gitea](#changes-in-gitea)
    - [Changes in Jenkins](#changes-in-jenkins)
      - [Add permissions to docker.socket to jenkins](#add-permissions-to-dockersocket-to-jenkins)
      - [Create Jenkins Job](#create-jenkins-job)
  - [Endpoints for checking](#endpoints-for-checking)

## ToDo

Check the process in a just initiated O.S.

Create documentation

## How it works this DevOps pipeline

using docker, jenkins....

## Installation

### Changes in Host (Docker-Host)

#### Unblock the following ports

```bash
sudo ufw allow 3000
sudo ufw allow 222
sudo ufw allow 3001
sudo ufw allow 5432
sudo ufw allow 8080
sudo ufw allow 80

#So the connection doesn't freeze instead notify is being rejected/refused.
sudo ufw default reject incoming
```

#### add domain in local domain /etc/hosts

Add the new line `127.0.0.1       host.docker.internal` on /etc/hosts
so the scripts connect the same way inside the container or in host.

#### Create a ssh key without keypass

Generate it

```bash
ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519_nopass
```

Add it to conf so is used in gitea service

```c
Host host.docker.internal
    HostName host.docker.internal
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

### Changes in gitea

1, Add allowed hosts in `data_gitea/gitea/conf/app.ini`

```ini
[webhook]
ALLOWED_HOST_LIST=host.docker.internal
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
ssh://git@host.docker.internal:222/mario1/{{NAME}}.git
```

4, Add webhook on back and front repositories settings

```sh
http://host.docker.internal:3001/generic-webhook-trigger/invoke?token=XXXXX

Method: POST

POST Content Type: application/json
```

<!--

-

-

-

-->

### Changes in Jenkins

#### Add permissions to docker.socket to jenkins

If there is an error: `dial unix /var/run/docker.sock: connect: permission denied`, when
inside the jenkins container run `docker ps`

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
sudo chown -R 1000:1000 ./data_jenkins
```

2, Select install the recommended plugins, on first run of Jenkins.

3, Install these extra plugins

- [gitea](https://plugins.jenkins.io/gitea/)
- [custom](https://plugins.jenkins.io/generic-webhook-trigger/)

#### Create Jenkins Job

1. Create a freestyle job
2. Check Generic Webhook Trigger
3. Add in POST token parameter: name: "TRIGGERING_REPO" expression: "$.repository.name", Type: "JSONPath"
4. Add token (same as webhook): 71c27113071788c2f7874f58a584d1138a003693
5. In build steps add "Execute shell" and peste the contant of start.sh
    (comment the declaration of TRIGGERING_REPO)
6. (Optional) You can trigger the web hook manually like this

```shell
# Note the "Content-Type" header is important.

# name: template51_frontend - template51_backend
curl -X POST --data '{"repository": { "name": "template51_backend" }}' \
    -H "Content-Type: application/json" \
    http://host.docker.internal:3001/generic-webhook-trigger/invoke?token=71c27113071788c2f7874f58a584d1138a003693
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
  http://host.docker.internal:8080/auth/create-token
```
