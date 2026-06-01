
################################################################################
## IMPORTANT
##  - THIS FILE IS A COPY AND PASTE OF "back.dockerfile" SO CHECK IF IT'S SYNC
##
################################################################################

ARG IMAGE_MVN
ARG IMAGE_JAVA

FROM $IMAGE_MVN AS dep_downloader

RUN mkdir /opt/template51
WORKDIR /opt/template51

COPY source/common/pom.xml        /opt/template51/common/pom.xml
COPY source/user/pom.xml          /opt/template51/user/pom.xml
COPY source/product/pom.xml       /opt/template51/product/pom.xml
COPY source/adapter/pom.xml       /opt/template51/adapter/pom.xml
COPY source/pom.xml               /opt/template51/pom.xml
COPY source/pom-spring-boot.xml   /opt/template51/pom-spring-boot.xml

RUN mvn -B -e org.apache.maven.plugins:maven-dependency-plugin:3.1.2:go-offline
  






# Builder
FROM $IMAGE_MVN AS builder

RUN apk add shadow

ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} user1 && useradd -u ${USER_ID} -g user1 -m user1

RUN mkdir /opt/template51 && chown -R user1:user1 /opt/template51 
WORKDIR /opt/template51

USER user1

COPY --from=dep_downloader /opt/template51/                     /opt/template51
COPY --from=dep_downloader /opt/template51/pom.xml              /opt/template51/pom.xml
COPY --from=dep_downloader /opt/template51/pom-spring-boot.xml  /opt/template51/pom-spring-boot.xml

COPY ./back_utils.entrypoint.sh  /opt/back_utils.entrypoint.sh

COPY source/common/src   /opt/template51/common/src
COPY source/user/src     /opt/template51/user/src
COPY source/product/src  /opt/template51/product/src
COPY source/adapter/src  /opt/template51/adapter/src


#RUN mvn -B -e clean install -DskipTests
  
