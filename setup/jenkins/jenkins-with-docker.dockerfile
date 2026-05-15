# We pass the docker group id as a build argument because it can change between host machines.

# Keep a specific version because I already had a difficulty because of an automatic update
ARG IMAGE_JENKINS
FROM ${IMAGE_JENKINS}

USER root

RUN apt-get update && apt-get install -y lsb-release

RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y docker-ce-cli

# Adding plugins to install, including JCasC plugin to add conf. at boot
COPY ./casc/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Utils ip, nc, ping: sometime I check thinks since the perspective of a container, using this one
RUN apt-get update && apt-get install -y tzdata iproute2 iputils-ping netcat-openbsd nano bc \
      curl postgresql-client-17 tar

RUN rm -rf /var/lib/apt/lists/*

# The PROBLEM with this approach it's that makes different the workflow for
# pipeline and for developing pipeline, duplicating ways to do the same.
# COPY --from=liquibase:4.33-alpine /liquibase /liquibase
# ENV PATH="/liquibase:${PATH}"

# CAREFUL: GID must match host's docker group GID (in my case 999)
ARG DOCKER_GID
RUN test -n "$DOCKER_GID" || \
    (echo "ERROR: DOCKER_GID is required." && \
     echo "Run: docker compose build --build-arg DOCKER_GID=\$(getent group docker | cut -d: -f3) jenkins" && \
     exit 1)
RUN groupadd -g $DOCKER_GID docker && usermod -aG docker jenkins


COPY ./jenkins-entrypoint.sh /usr/local/bin/jenkins-entrypoint.sh
RUN chmod +x /usr/local/bin/jenkins-entrypoint.sh && chown jenkins:jenkins /usr/local/bin/jenkins-entrypoint.sh

USER jenkins
