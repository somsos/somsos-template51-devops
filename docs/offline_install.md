# Offline install

- [Offline install](#offline-install)
  - [Requirements](#requirements)
  - [Clone project and copy heavy dependencies](#clone-project-and-copy-heavy-dependencies)
  - [Install and start project](#install-and-start-project)
  - [Link domains](#link-domains)
  - [Clone repositories](#clone-repositories)
  - [Approve scrips](#approve-scrips)
  - [Database pipelines](#database-pipelines)
    - [Deploy Database](#deploy-database)
    - [Rollback Database](#rollback-database)
  - [Frontend pipelines](#frontend-pipelines)
    - [Deploy Frontend](#deploy-frontend)
    - [Rollback Frontend](#rollback-frontend)
  - [Backend pipelines](#backend-pipelines)
    - [Deploy Backend](#deploy-backend)
    - [Rollback Backed](#rollback-backed)



## Requirements

- openssh-server
- 15GB free space minimum

## Clone project and copy heavy dependencies


```shell
ssh mario1@192.168.1.81
sudo mkdir -p /p1 && sudo chown -R mario1:mario1 /p1 && cd /p1
git clone https://github.com/somsos/somsos-template51-devops .
    # scp -r -P22 /home/mario/mine/empty_t51 mario1@192.168.1.81:/p1

#In a machine with the files already downloaded
scp -r -P22 /home/mario/mine/t51/dep_data mario1@192.168.1.81:/p1
```

Install and config docker

```shell
cd /p1/dep_data/docker_installer/

# In this point change to a network without internet

sudo dpkg -i ./containerd.io_2.2.4-1~ubuntu.24.04~noble_amd64.deb \
    ./docker-ce_29.5.3-1~ubuntu.24.04~noble_amd64.deb \
    ./docker-ce-cli_29.5.3-1~ubuntu.24.04~noble_amd64.deb \
    ./docker-buildx-plugin_0.34.1-1~ubuntu.24.04~noble_amd64.deb \
    ./docker-compose-plugin_5.1.4-1~ubuntu.24.04~noble_amd64.deb

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world

# To avoid docker starts automatically at the start
        sudo systemctl disable docker.service containerd.service docker.socket docker

        # each time the machine starts
        sudo systemctl start containerd.service docker.socket docker.service docker
        sudo systemctl stop docker containerd.service docker.socket docker.service
```

## Install and start project

```shell
cd /p1
bash ./install.sh
```

## Link domains 

Copy and peste to `/etc/hosts`, for example
```yml
192.168.1.81 tina-qa.com
192.168.1.81 api.tina-qa.com
192.168.1.81 gitea.tina-qa.com
192.168.1.81 jenkins.tina-qa.com
192.168.1.81 registry.tina-qa.com
192.168.1.81 nexus.tina-qa.com
```

Check created services
```yml
"http://gitea.tina-qa.com":                                    Gitea
"http://jenkins.tina-qa.com":                                  Jenkins
"http://registry.tina-qa.com":                                 Registry
"http://nexus.tina-qa.com":                                    Nexus
"http://api.tina-qa.com/swagger-ui/index.html":                Backend
"http://tina-qa.com":                                          Frontend
"psql postgresql://tina1:<DB_PASS>@192.168.1.81:5001/tina1db":     Database
```

## Clone repositories

I'm using ssh public-private keys as auth process, so we need to copy the
private key to the PC we want to clone from.

```shell
# the domain can be different in this case it's "gitea.tina-qa.com"
scp -r -P22 mario1@192.168.1.81:/p1/setup/secrets/ssh_key.priv ~/.ssh/tina1.priv

cat >> ~/.ssh/config <<EOF

Host gitea.tina-qa.com
    HostName gitea.tina-qa.com
    Port 222
    User git
    IdentityFile ~/.ssh/tina1.priv

EOF
```

We should be able to auth to the Gitea server

```shell
ssh -T git@gitea.tina-qa.com
# OUTPUT: Hi there, XXXXX You've successfully authenticated ...
```

Now we can clone the repositories

```shell
git clone ssh://git@gitea.tina-qa.com:222/tina1/t51devops.git /home/mario/mine/tina1

git clone ssh://git@gitea.tina-qa.com:222/tina1/t51mig-db.git /home/mario/mine/tina1/app/db/source

git clone ssh://git@gitea.tina-qa.com:222/tina1/t51back.git /home/mario/mine/tina1/app/back/source

git clone ssh://git@gitea.tina-qa.com:222/tina1/t51front.git /home/mario/mine/tina1/app/front/source
```

## Approve scrips

http://jenkins.tina-qa.com/manage/scriptApproval/



## Database pipelines

### Deploy Database

In this case I have a change already prepared.

```sh
cd /home/mario/mine/tina1/app/db/source

psql postgresql://tina1:tina123p@tina-qa.com:5001/tina1db -c "\dt" | grep bad_design

# EXPECTED OUTPUT (NOTICE THAT THERE IS NO TABLE CALLED "bad_design")
#                  List of tables
#  Schema |         Name          | Type  | Owner
# --------+-----------------------+-------+-------
#  public | databasechangelog     | table | tina1
#  public | databasechangeloglock | table | tina1
#  public | product_images        | table | tina1
#  public | products              | table | tina1
#  public | roles                 | table | tina1
#  public | users                 | table | tina1
#  public | users_picture         | table | tina1
#  public | users_roles           | table | tina1

mv ./docs/03-testTable.changelog.xml  ./changelogs

git add . && git status | grep renamed
# expected output
#	renamed:    docs/03-testTable.changelog.xml -> changelogs/03-testTable.changelog.xml

git commit -m "The first database change."

# Get ready to notice the pipeline being triggered by the git push
#   http://gitea.tina-qa.com/tina1/t51mig-db
#   http://jenkins.tina-qa.com/job/Database-Deploy-v1
git push origin main

psql postgresql://tina1:tina123p@tina-qa.com:5001/tina1db -c "\dt" | grep bad_design
# EXPECTED OUTPUT
# public | bad_design            | table | tina1
```

### Rollback Database

The rollback in database is a little more complex than back or front
applications, because we need to run a sql script to get back to the original
schema state without affected the data.

1. Go to `http://jenkins.tina-qa.com/job/Database-Deploy-v1/`
2. Push on "Build Now"
3. 






## Frontend pipelines

### Deploy Frontend

We add a change in our frontend project

```shell
cd /home/mario/mine/tina1/app/front/source

cat > ./src/app/main/internals/view/pages/home/home.page.html <<EOF
<div>
  <ul>
    <li>This is the change 1</li>
  </ul>
</div>
EOF

git status | grep modified
>        modified:   src/app/main/internals/view/pages/home/home.page.html

git add . && git commit -m "My change number 1"

# Open Gitea and Jenkins in the browser, and prepare to notice the pipeline 
# to be triggered on push
#   http://gitea.tina-qa.com/tina1/t51front
#   http://jenkins.tina-qa.com/job/Frontend-Deploy-v1/
git push origin main

# The deploy Jenkins pipeline should have been triggered and the change deployed.
```

### Rollback Frontend

1. Go to http://jenkins.tina-qa.com/job/Frontend-Rollback/

2. Click on "Build Now"

3. The last commit should have been deleted and the penultimate must 
    be deployed





## Backend pipelines

### Deploy Backend

We add a change in our frontend project

```shell
cd /home/mario/mine/tina1/app/back/source

nano ./adapter/src/main/java/daj/adapter/AdapterApplication.java 
# Edit this Line:
# return Map.of("message", "One is the number of this change.");

git status | grep modified
>        modified:   src/app/main/internals/view/pages/home/home.page.html

git add . && git commit -m "Change One"

# Get ready to notice the pipeline being triggered by the git push
#   http://gitea.tina-qa.com/tina1/t51back
#   http://jenkins.tina-qa.com/job/Backend-Deploy-v1/
git push origin main

# The deploy Jenkins pipeline should have been triggered and the change deployed.

curl http://api.tina-qa.com/test | json_pp
# EXPECTED OUTPUT
# {
#    "message" : "One is the number of this change"
# }
```

### Rollback Backed

1. Go to http://gitea.tina-qa.com/tina1/t51back and notice what is the last commit

2. Go to http://jenkins.tina-qa.com/job/Backend-Rollback/

3. Click on "Build Now"

4. At the end of the pipeline execution we should see the last message that was before

```shell
# 
curl http://api.tina-qa.com/test | json_pp
# EXPECTED OUTPUT
# {
#    "message" : "33-3 Some random change 3-33"
# }
```

5. Return to http://gitea.tina-qa.com/tina1/t51back and the last commit
   should have been deleted.


