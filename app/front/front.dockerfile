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

ARG MY_USER
ARG MY_PASS
ARG NEXUS_GW

RUN test -n "$MY_USER" || (echo "ERROR: MY_USER required." && exit 1)
RUN test -n "$MY_PASS" || (echo "ERROR: MY_PASS required." && exit 1)
RUN test -n "$NEXUS_GW" || (echo "ERROR: NEXUS_GW required." && exit 1)

# Generate .npmrc at build time with resolved values
RUN NPM_TOKEN=$(echo -n "${MY_USER}:${MY_PASS}" | base64) && \
    echo "registry=http://${NEXUS_GW}:8081/repository/npm-public/" > .npmrc && \
    echo "//${NEXUS_GW}:8081/repository/npm-public/:_auth=${NPM_TOKEN}" >> .npmrc && \
    echo "always-auth=true" >> .npmrc

# I remove this line, because buildX is required and it's less portable: --mount=type=cache,target=/root/.npm \
RUN npm install    

#npm ci --prefer-offline # I think it's better for CI/CD, but still don't why







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
