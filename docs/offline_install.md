

```shell
ssh mario1@192.168.1.81
sudo mkdir /p1 && chown -R mario1:mario1 /p1 && cd /p1
git clone https://github.com/somsos/somsos-template51-devops .

#In a machine with the files already downloaded
scp -r -P22 ./dep_data mario1@192.168.1.81:/p1

cd p1/docker-installer
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
        sudo systemctl disable docker.service
        sudo systemctl disable containerd.service
        sudo systemctl disable docker.socket
        sudo systemctl disable docker

        # each time the machine starts
        sudo systemctl start containerd.service docker.socket docker.service docker
        sudo systemctl stop docker containerd.service docker.socket docker.service

```

