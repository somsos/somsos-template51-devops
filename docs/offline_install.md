# Offline install

- [Offline install](#offline-install)
  - [Requirements](#requirements)
  - [Clone project and copy heavy dependencies](#clone-project-and-copy-heavy-dependencies)
  - [Install and start project](#install-and-start-project)
  - [Link domains](#link-domains)
  - [Clone repositories](#clone-repositories)



## Requirements

- openssh-server
- 15GB free space minimum

## Clone project and copy heavy dependencies


```shell
ssh mario1@192.168.50.49
sudo mkdir -p /p1 && sudo chown -R mario1:mario1 /p1 && cd /p1
git clone https://github.com/somsos/somsos-template51-devops .
    # scp -r -P22 /home/mario/mine/empty_t51 mario1@192.168.50.49:/p1

#In a machine with the files already downloaded
scp -r -P22 /home/mario/mine/t51/dep_data mario1@192.168.50.49:/p1
```

Install and config docker

```shell
cd /p1/dep_data/docker_installer/

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
192.168.50.49 dedo1-qa.com
192.168.50.49 api.dedo1-qa.com
192.168.50.49 gitea.dedo1-qa.com
192.168.50.49 jenkins.dedo1-qa.com
192.168.50.49 registry.dedo1-qa.com
192.168.50.49 nexus.dedo1-qa.com
```

Check created services
```yml
"http://gitea.dedo1-qa.com":                                    Gitea
"http://jenkins.dedo1-qa.com":                                  Jenkins
"http://registry.dedo1-qa.com":                                 Registry
"http://nexus.dedo1-qa.com":                                    Nexus
"http://api.dedo1-qa.com/swagger-ui/index.html":                Backend
"http://dedo1-qa.com":                                          Frontend
"psql postgresql://dedo1:<DB_PASS>@localhost:5001/dedo1db":     Database
```

## Clone repositories

I'm using ssh public-private keys as auth process, so we need to copy the
private key to the PC we want to clone from.

```shell
# the domain can be different in this case it's "gitea.dedo1-qa.com"
scp -r -P22 mario1@192.168.50.49:/p1/setup/secrets/ssh_key.priv ~/.ssh/dedo1.priv

cat >> ~/.ssh/config <<EOF

Host gitea.dedo1-qa.com
    HostName gitea.dedo1-qa.com
    Port 222
    User git
    IdentityFile ~/.ssh/dedo1.priv

EOF
```

We should be able to auth to the Gitea server

```shell
ssh -T git@gitea.dedo1-qa.com
# OUTPUT: Hi there, XXXXX You've successfully authenticated ...
```

Now we can clone the repositories

```shell
git clone ssh://git@gitea.dedo1-qa.com:222/dedo1/t51devops.git /home/mario/mine/dedo1

git clone ssh://git@gitea.dedo1-qa.com:222/dedo1/t51mig-db.git /home/mario/mine/dedo1/app/db/source

git clone ssh://git@gitea.dedo1-qa.com:222/dedo1/t51back.git /home/mario/mine/dedo1/app/back/source

git clone ssh://git@gitea.dedo1-qa.com:222/dedo1/t51front.git /home/mario/mine/dedo1/app/front/source
```




