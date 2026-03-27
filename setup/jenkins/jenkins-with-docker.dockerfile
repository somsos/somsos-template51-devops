# Keep a specific version because I already had a difficulty because of an automatic update
FROM jenkins/jenkins:2.541.1-lts-jdk21

USER root

RUN apt-get update && apt-get install -y lsb-release

RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y docker-ce-cli

# CAREFUL: GID must match host's docker group GID (in my case 999): cat /etc/group | grep docker
RUN groupadd -g 999 docker && usermod -aG docker jenkins

# Adding plugins to install, including JCasC plugin to add conf. at boot
COPY ./casc/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

COPY --from=liquibase:4.33-alpine /liquibase /liquibase
ENV PATH="/liquibase:${PATH}"

# Utils ip, nc, ping: sometime I check thinks since the perspective of a container, using this one
RUN apt-get install -y tzdata iproute2 iputils-ping netcat-openbsd nano bc

RUN rm -rf /var/lib/apt/lists/*



USER jenkins

