# https://github.com/sillelien/base-alpine
#   just in case I need this to run under tutum which is usually used in our projects
#
# nodejs and npm installation was inspired by https://github.com/mhart/alpine-node
#   but i need also to run build-essentials equivalent of alpine so, I included
#   the required build packages that makes this image bloat to 180MB :-(

FROM sillelien/base-alpine

# combine with mhart's alpine image nodejs installation.
# https://github.com/mhart/alpine-node

# ENV VERSION=v0.12.11
# ENV VERSION=v4.3.2
ENV VERSION=v5.7.1

RUN apk update && \
    apk add --update curl make gcc g++ binutils-gold libgcc libstdc++ linux-headers paxctl gnupg python  && \
    gpg --keyserver pool.sks-keyservers.net --recv-keys 9554F04D7259F04124DE6B476D5A82AC7E37093B && \
    gpg --keyserver pool.sks-keyservers.net --recv-keys 94AE36675C464D64BAFA68DD7434390BDBE9B9C5 && \
    gpg --keyserver pool.sks-keyservers.net --recv-keys 0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 && \
    gpg --keyserver pool.sks-keyservers.net --recv-keys FD3A5288F042B6850C66B31F09FE44734EB7990E && \
    gpg --keyserver pool.sks-keyservers.net --recv-keys 71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 && \
    gpg --keyserver pool.sks-keyservers.net --recv-keys DD8F2338BAE7501E3DD5AC78C273792F7D83545D && \
    gpg --keyserver pool.sks-keyservers.net --recv-keys C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 && \
    gpg --keyserver pool.sks-keyservers.net --recv-keys B9AE9905FFD7803F25714661B63B535A4C206CA9 && \
    curl -o node-${VERSION}.tar.gz -sSL https://nodejs.org/dist/${VERSION}/node-${VERSION}.tar.gz && \
    curl -o SHASUMS256.txt.asc -sSL https://nodejs.org/dist/${VERSION}/SHASUMS256.txt.asc && \
    grep node-${VERSION}.tar.gz SHASUMS256.txt.asc | sha256sum -c - && \
    tar -zxf node-${VERSION}.tar.gz && \
    cd /node-${VERSION} && \
    ./configure --prefix=/usr --fully-static && \
    make -j$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    make install && \
    paxctl -cm /usr/bin/node && \
    cd / && \
    if [ -x /usr/bin/npm ]; then \
        npm install -g npm@latest && \
        find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf; \
    fi && \
    apk del --purge make gcc g++ binutils-gold libgcc libstdc++ linux-headers paxctl gnupg python && \
    rm -rf /etc/ssl /node-${VERSION}.tar.gz /SHASUMS256.txt.asc /node-${VERSION} \
        /usr/share/man /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp /usr/include /root/.gnupg \
        /usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html
    
