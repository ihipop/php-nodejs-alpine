FROM php:7.1-cli-alpine3.4

LABEL maintainer="ihipop <ihipop#gmail.com>"
LABEL description="PHP + NODEJS in Alpine"

#Inspire by https://github.com/mhart/alpine-node

#YOU can use `--build-arg IN_CHINA=true` in command line to overwride this VAR
ARG IN_CHINA="false"
ARG HTTP_PROXY=""
ARG HTTPS_PROXY=""

ARG NODEJS_VERSION=v8.9.4
ARG NPM_VERSION=5
ARG YARN_VERSION=latest
# ENV NODEJS_VERSION=v4.8.7 NPM_VERSION=2
# ENV NODEJS_VERSION=v6.12.3 NPM_VERSION=3
# ENV NODEJS_VERSION=v8.9.4 NPM_VERSION=5 YARN_VERSION=latest
ENV NODEJS_VERSION=${NODEJS_VERSION} NPM_VERSION=${NPM_VERSION} YARN_VERSION=${YARN_VERSION}

RUN [ "$IN_CHINA" == "true" ] && echo 'http://mirrors.ustc.edu.cn/alpine/v3.4/main/' >/etc/apk/repositories \
    && echo 'http://mirrors.ustc.edu.cn/alpine/v3.4/community/' >>/etc/apk/repositories || true

RUN apk update --no-cache \
    && apk add --no-cache \
        unzip git

# For Build NPMs Family
ENV CONFIG_FLAGS="--fully-static" DEL_PKGS="libstdc++" RM_DIRS=/usr/include

RUN apk add --no-cache curl make gcc g++ python linux-headers binutils-gold gnupg libstdc++ && \
    for server in pgp.mit.edu keyserver.pgp.com ha.pool.sks-keyservers.net; do \
        gpg --keyserver $server --recv-keys \
            94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
            FD3A5288F042B6850C66B31F09FE44734EB7990E \
            71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
            DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
            C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
            B9AE9905FFD7803F25714661B63B535A4C206CA9 \
            56730D5401028683275BD23C23EFEFE93C4CFFFE \
            77984A986EBC2AA786BC0F66B01FBB92821C587A && break; \
    done && \
    curl -sfSLO https://nodejs.org/dist/${NODEJS_VERSION}/node-${NODEJS_VERSION}.tar.xz && \
    curl -sfSL https://nodejs.org/dist/${NODEJS_VERSION}/SHASUMS256.txt.asc | gpg --batch --decrypt | \
    grep " node-${NODEJS_VERSION}.tar.xz\$" | sha256sum -c | grep ': OK$' && \
    tar -xf node-${NODEJS_VERSION}.tar.xz && \
    cd node-${NODEJS_VERSION} && \
    ./configure --prefix=/usr ${CONFIG_FLAGS} && \
    make -j$(($(getconf _NPROCESSORS_ONLN)-1)) && \
    make install && \
    cd / && \
    if [ `which npm` ]; then \
        if [ -n "$NPM_VERSION" ]; then \
            if [ "$IN_CHINA" == "true" ]; then \
                npm config set registry https://registry.npm.taobao.org; \
            fi; \
            npm install -g npm@${NPM_VERSION}; \
            npm install -g cnpm; \
        fi; \
        find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf; \
    fi && \
    if [ -n "$YARN_VERSION" ]; then \
        for server in pgp.mit.edu keyserver.pgp.com ha.pool.sks-keyservers.net; do \
        gpg --keyserver $server --recv-keys \
            6A010C5166006599AA17F08146C2130DFD2497F5 && break; \
        done && \
        curl -sfSL -O https://yarnpkg.com/${YARN_VERSION}.tar.gz -O https://yarnpkg.com/${YARN_VERSION}.tar.gz.asc && \
        gpg --batch --verify ${YARN_VERSION}.tar.gz.asc ${YARN_VERSION}.tar.gz && \
        mkdir /usr/local/share/yarn && \
        tar -xf ${YARN_VERSION}.tar.gz -C /usr/local/share/yarn --strip 1 && \
        ln -s /usr/local/share/yarn/bin/yarn /usr/local/bin/ && \
        ln -s /usr/local/share/yarn/bin/yarnpkg /usr/local/bin/ && \
        rm ${YARN_VERSION}.tar.gz*; \
    fi; \
    apk del make gcc g++ python linux-headers binutils-gold gnupg ${DEL_PKGS} && \
    rm -rf ${RM_DIRS} /node-${NODEJS_VERSION}* /usr/share/man /tmp/* /var/cache/apk/* \
    /root/.npm /root/.node-gyp /root/.gnupg /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html /usr/lib/node_modules/npm/scripts

VOLUME ["/project", "/root/.ssh", "/tmp"]
WORKDIR /project
