# Keep a specific version because I already had a difficulty because of an automatic update
FROM jenkins/jenkins:2.516.1-lts-jdk21

USER root

RUN apt-get update && apt-get install -y lsb-release

RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y docker-ce-cli

RUN apt update && apt install tzdata -y

# CAREFUL: GID must match host's docker group GID (in my case 999): cat /etc/group | grep docker
RUN groupadd -g 999 docker && usermod -aG docker jenkins

#ip, nc, ping
RUN apt-get install -y iproute2 iputils-ping netcat-openbsd

RUN rm -rf /var/lib/apt/lists/*

USER jenkins

