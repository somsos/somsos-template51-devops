# syntax=docker/dockerfile:1.6

FROM node:25.7-alpine3.23 AS build

WORKDIR /app

COPY source/package*.json ./

RUN --mount=type=cache,target=/root/.npm \
    npm install

RUN --mount=type=cache,target=/root/.npm \
    npm install -g @angular/cli

COPY ./source .

ARG BACK_URL
RUN sed -i "s|__BACK_URL__|${BACK_URL}|g" src/environments/environment.ts

RUN --mount=type=cache,target=/root/.npm \
    ng build -c production



# RUN



FROM nginx:stable-alpine3.23

COPY --from=build app/dist/mod51io/browser /usr/share/nginx/html

COPY Dockerfile-nginx.config /etc/nginx/nginx.conf

EXPOSE 80
