# syntax=docker/dockerfile:1.6
ARG IMAGE_MVN
ARG IMAGE_JAVA

# How to build: "docker build -t template51_backend:0.0.1 . "

# How to run: "docker run -p 8080:8080 template51_backend:0.0.1"


# Dependencies downloader
FROM $IMAGE_MVN AS dep_downloader

RUN apk add shadow
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} user1 && useradd -u ${USER_ID} -g user1 -m user1

RUN mkdir /opt/template51
WORKDIR /opt/template51

COPY source/common/pom.xml        /opt/template51/common/pom.xml
COPY source/user/pom.xml          /opt/template51/user/pom.xml
COPY source/product/pom.xml       /opt/template51/product/pom.xml
COPY source/adapter/pom.xml       /opt/template51/adapter/pom.xml
COPY source/pom.xml               /opt/template51/pom.xml
COPY source/pom-spring-boot.xml   /opt/template51/pom-spring-boot.xml

RUN mkdir -p /home/user1/.m2/repository
RUN chown -R user1:user1 /home/user1/.m2
RUN chown -R user1:user1 /opt/template51
USER user1

# --mount=type=cache,target=/root/.m2 \
RUN mvn -B -e org.apache.maven.plugins:maven-dependency-plugin:3.1.2:go-offline
  






# Builder
FROM $IMAGE_MVN AS builder

RUN apk add shadow
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} user1 && useradd -u ${USER_ID} -g user1 -m user1

RUN mkdir /opt/template51
WORKDIR /opt/template51

COPY --from=dep_downloader /opt/template51/           /opt/template51
COPY --from=dep_downloader /opt/template51/pom.xml    /opt/template51/pom.xml
COPY --from=dep_downloader /opt/template51/pom-spring-boot.xml    /opt/template51/pom-spring-boot.xml

COPY source/common/src   /opt/template51/common/src
COPY source/user/src     /opt/template51/user/src
COPY source/product/src  /opt/template51/product/src
COPY source/adapter/src  /opt/template51/adapter/src

RUN mkdir -p /home/user1/.m2/repository
RUN chown -R user1:user1 /home/user1/.m2
RUN chown -R user1:user1 /opt/template51
USER user1

# --mount=type=cache,target=/root/.m2 \
RUN mvn -B -e clean install -DskipTests
  




# Runner
FROM $IMAGE_JAVA AS runner

RUN mkdir /opt/template51
WORKDIR /opt/template51

COPY --from=builder /opt/template51/adapter/target/t51Back*.jar /opt/template51/t51Back.jar

EXPOSE 8080

ENTRYPOINT java -Dspring.profiles.active=default,test-docker -jar t51Back.jar
