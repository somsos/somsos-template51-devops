# syntax=docker/dockerfile:1.6

# How to build: "docker build -t template51_backend:0.0.1 . "

# How to run: "docker run -p 8080:8080 template51_backend:0.0.1"


# Dependencies downloader
ARG IMAGE_MVN
FROM $IMAGE_MVN AS deps

RUN mkdir /opt/template51
WORKDIR /opt/template51

COPY source/common/pom.xml        /opt/template51/common/pom.xml
COPY source/user/pom.xml          /opt/template51/user/pom.xml
COPY source/product/pom.xml       /opt/template51/product/pom.xml
COPY source/adapter/pom.xml       /opt/template51/adapter/pom.xml
COPY source/pom.xml               /opt/template51/pom.xml
COPY source/pom-spring-boot.xml   /opt/template51/pom-spring-boot.xml

RUN --mount=type=cache,target=/root/.m2 \
  mvn -B -e org.apache.maven.plugins:maven-dependency-plugin:3.1.2:go-offline






# Builder
FROM $IMAGE_MVN AS builder

RUN mkdir /opt/template51
WORKDIR /opt/template51

#COPY --from=deps /root/.m2                  /root/.m2
COPY --from=deps /opt/template51/           /opt/template51
COPY --from=deps /opt/template51/pom.xml    /opt/template51/pom.xml
COPY --from=deps /opt/template51/pom-spring-boot.xml    /opt/template51/pom-spring-boot.xml

COPY source/common/src   /opt/template51/common/src
COPY source/user/src     /opt/template51/user/src
COPY source/product/src  /opt/template51/product/src
COPY source/adapter/src  /opt/template51/adapter/src

RUN --mount=type=cache,target=/root/.m2 \
   mvn -B -e clean install -DskipTests




# Runner
FROM eclipse-temurin:21-alpine

RUN mkdir /opt/template51
WORKDIR /opt/template51

COPY --from=builder /opt/template51/adapter/target/t51Back*.jar /opt/template51/t51Back.jar

EXPOSE 8080

ENTRYPOINT java -Dspring.profiles.active=default,test-docker -jar t51Back.jar
