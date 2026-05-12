ARG IMAGE_NODE
ARG IMAGE_NGINX
ARG BACK_URL

FROM $IMAGE_NODE AS build

WORKDIR /app

COPY source/package*.json ./

# avoid using "--mount=type=cache,target=/root/.npm", because it gave me problems
# with the cache, making the changes were not applied.
RUN npm install

RUN npm install -g @angular/cli

# CAREFUL: Just to be sure that bellow here is not cached, it happened me once
ARG CACHE_BUST=$(date -u +%s)
RUN echo $CACHE_BUST > /app/BUILD_DATE.txt

COPY ./source .

RUN sed -i "s|__BACK_URL__|${BACK_URL}|g" src/environments/environment.ts

RUN ng build -c production



# RUN
FROM $IMAGE_NGINX

COPY --from=build app/dist/mod51io/browser /usr/share/nginx/html

COPY Dockerfile-nginx.config /etc/nginx/nginx.conf

EXPOSE 80
