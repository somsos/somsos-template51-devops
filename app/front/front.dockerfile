# syntax=docker/dockerfile:1.6

FROM node:25.7-alpine3.23 AS build

WORKDIR /app

COPY source/package*.json ./

RUN npm install

RUN npm install -g @angular/cli

# CAREFUL: I do not know why started to cache the copy of code making the
# changes were not applied, so I add the bellow command ARG ... to avoid
# caching this part
ARG CACHE_BUST=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 10)
RUN echo $CACHE_BUST

COPY ./source .

ARG BACK_URL
RUN sed -i "s|__BACK_URL__|${BACK_URL}|g" src/environments/environment.ts

RUN ng build -c production



# RUN



FROM nginx:stable-alpine3.23

COPY --from=build app/dist/mod51io/browser /usr/share/nginx/html

COPY Dockerfile-nginx.config /etc/nginx/nginx.conf

EXPOSE 80
