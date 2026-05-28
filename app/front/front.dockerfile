#
##############################################################################
#   INPUT FOR FROM SENTENCES

ARG IMAGE_NODE
ARG IMAGE_NGINX
# ARG BACK_URL  CAREFUL the variables are reset after a FROM between stages.
#               So if we put BACK_URL here it will not be available after the
#               the FROM sentence,


#
##############################################################################
#   DOWNLOADER

FROM $IMAGE_NODE AS downloader

WORKDIR /app

COPY source/package*.json ./

# avoid using "--mount=type=cache,target=/root/.npm", because it gave me problems
# with the cache, making the changes were not applied.
RUN npm install


#
##############################################################################
#   BUILDER


FROM $IMAGE_NODE AS builder

WORKDIR /app

# Reuse downloaded dependencies
COPY --from=downloader /app/node_modules /app/node_modules

# CAREFUL: Just to be sure that bellow here is not cached, it happened me once
#ARG CACHE_BUST=$(date -u +%s)
#RUN echo $CACHE_BUST > /app/BUILD_DATE.txt

COPY ./source .

ARG BACK_URL
RUN test -n "$BACK_URL" || (echo "ERROR: BACK_URL required." && exit 1)
RUN sed -i "s|__BACK_URL__|${BACK_URL}|g" src/environments/environment.ts

RUN npx ng build -c production


#
##############################################################################
#   RUNNER



FROM $IMAGE_NGINX

COPY --from=builder app/dist/mod51io/browser /usr/share/nginx/html

COPY Dockerfile-nginx.config /etc/nginx/nginx.conf

EXPOSE 80
